# Database Rollback Policy

## Principles

1. **Database rollback is separate from application rollback.** A failed
   application deploy can roll back the container without touching the database.
   A failed migration requires explicit database rollback.

2. **Expand-then-contract pattern.** Additions (new columns, new tables) are
   safe to deploy. Removals (drop column, drop table) must be deferred to a
   later deploy after the code no longer references them.

3. **Backward compatibility.** Every migration must be compatible with the
   PREVIOUS application version running against the NEW schema.

## Rollback Procedure

```
1. Stop the application (prevent new writes)
2. Assess the failure — is it a data migration or schema change?
3. If schema: run the corresponding rollback migration
4. If data: restore from the pre-migration backup
5. Verify data integrity
6. Restart the previous application version
7. Run health checks
```

## RPO/RTO

- **RPO**: 0 (pre-migration backup is mandatory)
- **RTO**: 30 minutes maximum
