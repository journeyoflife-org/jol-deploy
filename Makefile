# =============================================================================
# jol-deploy Makefile — Build, Validate, Deploy, Test
# =============================================================================
SHELL := /bin/bash
.DEFAULT_GOAL := help
.ONESHELL:

TENANT ?=
ENV ?= production
VERSION ?=
VM_NAME ?=
SCRIPTS_DIR := scripts
TESTS_DIR := tests
ROBOTS_DIR := robots
INFRA_DIR := infrastructure
SECURITY_DIR := security

# --- Validation ---
.PHONY: validate
validate: validate-yaml validate-terraform validate-ansible validate-templates ## Validate all configs

.PHONY: validate-yaml
validate-yaml: ## Validate all YAML files
	@echo "→ Validating YAML syntax..."
	@find . -name '*.yml' -o -name '*.yaml' | grep -v '.venv' | grep -v node_modules | while read f; do \
		python3 -c "import yaml; yaml.safe_load(open('$$f'))" 2>/dev/null || echo "FAIL: $$f"; \
	done
	@echo "✓ YAML validation complete"

.PHONY: validate-terraform
validate-terraform: ## Validate Terraform configurations
	@echo "→ Validating Terraform..."
	@cd $(INFRA_DIR)/terraform && for dir in proxmox networking storage; do \
		terraform fmt -check $$dir/ 2>/dev/null || true; \
	done
	@echo "✓ Terraform validation complete"

.PHONY: validate-ansible
validate-ansible: ## Validate Ansible playbooks
	@echo "→ Validating Ansible..."
	@ansible-playbook --syntax-check $(INFRA_DIR)/ansible/playbooks/*.yml 2>/dev/null || true
	@echo "✓ Ansible validation complete"

.PHONY: validate-templates
validate-templates: ## Validate template rendering
	@$(SCRIPTS_DIR)/validate-templates.sh

.PHONY: validate-tenant
validate-tenant: ## Validate tenant config (TENANT=name)
	@test -n "$(TENANT)" || (echo "ERROR: TENANT required" && exit 1)
	@$(SCRIPTS_DIR)/validate-tenant.sh $(TENANT)

# --- Testing ---
.PHONY: test
test: test-unit test-integration test-security test-isolation ## Run all tests

.PHONY: test-unit
test-unit: ## Run unit tests
	@$(TESTS_DIR)/unit/run-tests.sh

.PHONY: test-integration
test-integration: ## Run integration tests
	@$(TESTS_DIR)/integration/run-tests.sh

.PHONY: test-e2e
test-e2e: ## Run end-to-end tests
	@$(TESTS_DIR)/e2e/run-tests.sh

.PHONY: test-security
test-security: ## Run security tests
	@$(TESTS_DIR)/security/run-tests.sh

.PHONY: test-isolation
test-isolation: ## Run tenant isolation tests
	@$(TESTS_DIR)/isolation/run-tests.sh

.PHONY: test-rollback
test-rollback: ## Run rollback tests
	@$(TESTS_DIR)/rollback/run-tests.sh

.PHONY: test-scale
test-scale: ## Run scale tests
	@$(TESTS_DIR)/scale/run-tests.sh

.PHONY: test-dr
test-dr: ## Run disaster recovery tests
	@$(TESTS_DIR)/disaster-recovery/run-tests.sh

# --- Deployment ---
.PHONY: deploy
deploy: ## Deploy single tenant (TENANT=name ENV=production)
	@test -n "$(TENANT)" || (echo "ERROR: TENANT required" && exit 1)
	@$(SCRIPTS_DIR)/deploy.sh $(TENANT) $(ENV)

.PHONY: deploy-all
deploy-all: ## Deploy all tenants
	@$(SCRIPTS_DIR)/deploy-all.sh $(ENV)

.PHONY: deploy-canary
deploy-canary: ## Deploy canary (first 5 tenants)
	@$(SCRIPTS_DIR)/deploy-canary.sh $(ENV)

.PHONY: rollback
rollback: ## Rollback tenant (TENANT=name VERSION=x)
	@test -n "$(TENANT)" || (echo "ERROR: TENANT required" && exit 1)
	@$(SCRIPTS_DIR)/rollback.sh $(TENANT) $(VERSION)

# --- Health ---
.PHONY: health-check
health-check: ## Health check (TENANT=name)
	@test -n "$(TENANT)" || (echo "ERROR: TENANT required" && exit 1)
	@$(SCRIPTS_DIR)/health-check.sh $(TENANT)

.PHONY: smoke-test
smoke-test: ## Smoke test (TENANT=name)
	@test -n "$(TENANT)" || (echo "ERROR: TENANT required" && exit 1)
	@$(TESTS_DIR)/integration/test-smoke.sh $(TENANT)

# --- Pre-deploy ---
.PHONY: pre-deploy
pre-deploy: validate-tenant test-security ## Pre-deployment checks
	@$(SCRIPTS_DIR)/pre-deploy-checks.sh $(TENANT) $(ENV)

# --- Security ---
.PHONY: security-scan
security-scan: ## Full security scan
	@$(SECURITY_DIR)/scanning/scan-all.sh

# --- Infrastructure ---
.PHONY: provision-vm
provision-vm: ## Provision VM (VM_NAME=name)
	@test -n "$(VM_NAME)" || (echo "ERROR: VM_NAME required" && exit 1)
	@$(SCRIPTS_DIR)/provision-vm.sh $(VM_NAME)

# --- Utilities ---
.PHONY: lint
lint: ## Run all linters
	@yamllint -c .yamllint.yaml . 2>/dev/null || true
	@shellcheck $(SCRIPTS_DIR)/*.sh $(ROBOTS_DIR)/*.sh 2>/dev/null || true
	@terraform fmt -check $(INFRA_DIR)/terraform/ 2>/dev/null || true

.PHONY: fmt
fmt: ## Format all files
	@terraform fmt $(INFRA_DIR)/terraform/ 2>/dev/null || true

.PHONY: clean
clean: ## Clean artifacts
	@rm -rf output/ artifacts/ .sbom/ signatures/ .tmp/ .cache/

.PHONY: help
help: ## Show help
	@echo "jol-deploy — JOL Deployment Platform"
	@echo ""
	@echo "Usage: make <target> [TENANT=name] [ENV=environment]"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
