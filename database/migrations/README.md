# Database Migrations

Migration files follow the naming convention:
```
YYYYMMDD_HHMMSS_description.sql
```

Example: `20260920_120000_add_tenants_table.sql`

## Rules

1. Migrations MUST be backward-compatible with the previous application version
2. Each migration must be idempotent (use `IF NOT EXISTS`, `IF EXISTS`)
3. Large migrations must be tested against staging first
4. A rollback migration must accompany every forward migration
5. Never drop columns in the same deploy as the code stops reading them
