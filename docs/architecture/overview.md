# jol-deploy Architecture Overview

## System Context

```
                    ┌─────────────────┐
                    │   GitHub CI/CD   │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │   jol-deploy    │
                    │  (this repo)    │
                    └────────┬────────┘
                             │
          ┌──────────────────┼──────────────────┐
          │                  │                  │
  ┌───────▼───────┐ ┌───────▼───────┐ ┌───────▼───────┐
  │  her-prod-lt01│ │ rag-prod-lt01 │ │ llm-prod-lt01 │
  │  (web hosts)  │ │ (RAG service) │ │ (LLM service) │
  └───────┬───────┘ └───────────────┘ └───────────────┘
          │
  ┌───────▼───────────────────┐
  │  Tenant Websites (spokes) │
  │  basilica, cathedral, ... │
  └───────────────────────────┘
```

## Deployment Pipeline

```
DISCOVER → VERIFY → PLAN → TEST → BACKUP → BUILD →
SECURITY SCAN → DEPLOY → HEALTH CHECK → SMOKE TEST →
SECURITY VERIFICATION → FUNCTIONAL VERIFICATION →
MONITOR → ACCEPT / ROLLBACK → AUDIT
```

## Key Components

| Component | Purpose | Technology |
|-----------|---------|------------|
| IaC | VM provisioning | Terraform/OpenTofu |
| Configuration | OS + app setup | Ansible |
| Bootstrap | Initial VM setup | cloud-init |
| Deployment | Tenant lifecycle | Bash + Docker Compose |
| Security | Scanning + policies | Trivy, Semgrep, OPA |
| Observability | Metrics + logs | Prometheus, Grafana, Loki |
| Backup | Data protection | PBS + pg_dump |
| CI/CD | Pipeline automation | GitHub Actions |

## Tenant Isolation Model

Each tenant runs in:
- Its own Docker network (bridge driver)
- Its own container set (app + nginx)
- Its own port range (assigned per tenant config)
- Its own data directory (`/opt/jol/tenants/<tenant>/`)

No cross-tenant access at network, filesystem, or secret level.
