# Security Architecture

## Defense in Depth

```
Layer 1: Network (VLAN segmentation, UFW)
  ↓
Layer 2: Host (SSH hardening, fail2ban, AIDE)
  ↓
Layer 3: Container (non-root, read-only, resource limits)
  ↓
Layer 4: Application (input validation, RBAC, CORS)
  ↓
Layer 5: Data (encryption at rest, TLS in transit)
```

## Secret Flow

```
GitHub Secrets (CI/CD only)
  ↓
Ansible Vault (IaC)
  ↓
Docker env files (runtime, mode 0640)
  ↓
Application (env vars only)
```

## Compliance Mapping

| Control | GDPR | PCI-DSS | SOC 2 | ISO 27001 |
|---------|------|---------|-------|-----------|
| Tenant isolation | Art. 5(1)(b) | 7.2 | CC6.1 | A.8.13 |
| Audit trail | Art. 5(2) | 10.2 | CC7.2 | A.12.4 |
| Backup/DR | Art. 32 | 12.10 | CC7.4 | A.17.1 |
| Secret management | Art. 32 | 3.5 | CC6.1 | A.10.1 |
| Vulnerability scanning | Art. 32 | 6.1 | CC7.1 | A.12.6 |
