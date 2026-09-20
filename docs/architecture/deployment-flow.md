# Deployment Flow

## Single Tenant Deployment

```
1. Validate tenant config (schema + OPA policy)
2. Pre-deployment backup (database + files)
3. Build container image (from spoke repo)
4. Security scan (SAST + deps + secrets + container + IaC)
5. Deploy (rolling/canary/blue-green)
6. Health check (/health endpoint)
7. Smoke test (functional verification)
8. Security verification (post-deploy)
9. Audit record (immutable JSON)
```

## Canary Promotion

```
5% → verify (30s) → 25% → verify (60s) → 100%
```

If any step fails: automatic rollback to previous version.

## Multi-Tenant Batch Deployment

```
Batch 1: 5 tenants (canary)
  ↓ verify
Batch 2: 25 tenants
  ↓ verify
Batch 3: remaining tenants
  ↓ verify
All tenants deployed
```
