# Secret Management Policy

## Principles

1. **Zero secrets in code** — no API keys, tokens, passwords, or private keys
   in any committed file (including Dockerfiles, compose files, scripts)
2. **Zero secrets in CLI arguments** — shell history exposure risk
3. **Zero secrets in environment variables of CI logs** — mask all secrets

## Secret Storage by Context

| Context | Tool | Format |
|---------|------|--------|
| IaC (Terraform) | SOPS + age | `.tfvars` encrypted |
| Ansible | Ansible Vault | `*.vault.yml` |
| Runtime (Docker) | Docker secrets / env files | `.env` (mode 0640) |
| CI/CD | GitHub Secrets | Encrypted at rest |
| Cross-repo | Vaultwarden | API-accessed |

## Rotation Schedule

| Secret Type | Rotation Period |
|-------------|-----------------|
| Database passwords | 90 days |
| API keys | 180 days |
| TLS certificates | Auto-renew (Let's Encrypt) |
| Deploy tokens | 90 days |
| SSH keys | Annual + on personnel change |

## Incident Response

If a secret is accidentally committed:
1. **Immediately** rotate the exposed secret
2. **Revoke** the old credential
3. **Audit** git history for exposure window
4. **File** a security incident report
