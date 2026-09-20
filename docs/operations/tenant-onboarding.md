# Tenant Onboarding Guide

## Prerequisites

- Approved tenant request (GitHub Issue)
- Domain name reserved
- Country assignment confirmed
- Resource allocation approved

## Steps

### 1. Create Tenant Configuration

```bash
# Copy template
cp tenants/schemas/tenant-config.schema.json /tmp/reference.json

# Create config file
cat > tenants/<country>/<tenant-id>.yml << EOF
---
tenant_id: <tenant-id>
name: "<Display Name>"
country: <country-code>
domain: "<domain>"
environment: production
resources:
  cpu: "1.0"
  memory: "512M"
  disk: "10G"
features: []
contacts:
  admin_email: "admin@<domain>"
  tech_email: "tech@gyvenimo-kelias.lt"
backup:
  rpo_hours: 24
  rto_hours: 4
  retention_days: 30
vm:
  host: her-prod-lt01
  ip: 10.40.40.20
  port: <next-available-port>
EOF
```

### 2. Validate Configuration

```bash
make validate-tenant TENANT=<tenant-id>
```

### 3. Provision DNS

```bash
./dns/provision-domain.sh <tenant-id> <domain>
```

### 4. Deploy

```bash
make deploy TENANT=<tenant-id> ENV=production
```

### 5. Verify

```bash
make health-check TENANT=<tenant-id>
./dns/verify-dns.sh <domain> <expected-ip>
./dns/certificate-check.sh <domain>
```

### 6. Monitor

Verify tenant appears in Grafana dashboard.
