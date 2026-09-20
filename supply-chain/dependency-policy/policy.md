# Dependency Policy

## Principles

1. **Pin all versions** — no floating dependencies
2. **Automated updates** — Dependabot/Renovate for patch updates
3. **Security-first** — critical vulnerabilities block deployment
4. **License compliance** — no GPL-incompatible licenses in production

## Allowed Package Sources

| Ecosystem | Source | Policy |
|-----------|--------|--------|
| npm | registry.npmjs.org | Scoped packages via .npmrc |
| pip | pypi.org | Hash-verified installs |
| Docker | Docker Hub / GHCR | Pinned digests, not tags |
| Terraform | HashiCorp Registry | Pinned provider versions |

## Vulnerability Response

| Severity | Response Time | Action |
|----------|---------------|--------|
| Critical | 24 hours | Immediate patch + deploy |
| High | 7 days | Scheduled patch |
| Medium | 30 days | Next maintenance window |
| Low | 90 days | Best effort |
