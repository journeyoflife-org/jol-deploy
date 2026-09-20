# jol-deploy — JOL Deployment Platform

**Organization**: Journey Of Life (JOL) — Roman Catholic Digital Mission Platform
**Purpose**: Centralized deployment platform for all JOL spoke websites across Europe
**Scale**: 1 → 1,200 (Lithuania) → ~400,000 (Europe) websites
**Compliance**: GDPR Article 9, PCI-DSS, SOC 2 Type II, ISO 27001:2022

---

## Overview

`jol-deploy` is the Infrastructure-as-Code + CI/CD + Deployment Control Plane + Tenant
Provisioning + Security Gates + Observability Integration + Backup/DR Verification +
Deployment Audit system for the Journey Of Life platform.

### Core Principle

```
DISCOVER → VERIFY → PLAN → TEST → BACKUP → BUILD → SECURITY SCAN → DEPLOY →
HEALTH CHECK → SMOKE TEST → SECURITY VERIFICATION → FUNCTIONAL VERIFICATION →
MONITOR → ACCEPT / ROLLBACK → AUDIT
```

---

## Repository Structure

```
jol-deploy/
├── infrastructure/        # IaC: Terraform, Ansible, cloud-init
├── deployment/            # Controllers, strategies, rollout, rollback
├── templates/             # Parameterized Dockerfile, compose, nginx
├── tenants/               # Tenant configs (schemas, per-country)
├── environments/          # Environment definitions (dev, staging, production)
├── dns/                   # DNS provisioning and verification
├── tls/                   # TLS certificate management
├── database/              # Migration management
├── backup/                # Backup policies, restore tests, DR
├── security/              # Security policies and scanning configs
├── observability/         # Prometheus, Grafana, Loki, Alertmanager
├── scripts/               # Deployment and operational scripts
├── robots/                # Automation agents
├── supply-chain/          # SBOM, image signing, provenance
├── .github/workflows/     # CI/CD reusable workflows
├── tests/                 # Full test suite (unit → scale)
├── policies/              # OPA Rego + Checkov policies
└── docs/                  # Architecture, operations, security, runbooks
```

---

## Quick Start

```bash
make validate-tenant TENANT=basilica-vilnius
make pre-deploy TENANT=basilica-vilnius ENV=production
make deploy TENANT=basilica-vilnius ENV=production
make health-check TENANT=basilica-vilnius
make smoke-test TENANT=basilica-vilnius
```

## Integration with JOL Ecosystem

```
jol-hub/                    # Platform packages (Tier 0)
jol-site-basilica/          # Spoke app
jol-deploy/                 # THIS — deployment infrastructure
jol-infrastructure/         # Fleet management, hardening, networking
    ↓
Proxmox VMs (her-prod-lt01, rag-prod-lt01, mcp-prod-lt01, llm-prod-lt01)
    ↓
Tenant domains (*.gyvenimo-kelias.lt, etc.)
```

## Scaling Model

| Tenants     | Architecture                    | Orchestration     |
|-------------|---------------------------------|-------------------|
| 1–50        | VM + Docker + reverse proxy     | Ansible + scripts |
| 50–500      | Multi-VM + load balancer        | Ansible + GitOps  |
| 500–5,000   | Cluster + auto-scaling          | Kubernetes        |
| 5,000+      | Multi-region + CDN + edge       | Kubernetes + mesh |

> **Rule**: Introduce orchestration when operational complexity requires it,
> not merely when a tenant-count threshold is reached.

## License

Proprietary — Journey Of Life (JOL) Organization. All rights reserved.
