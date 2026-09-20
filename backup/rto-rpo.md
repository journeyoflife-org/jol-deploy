# RPO/RTO Definitions

## Recovery Point Objective (RPO)

Maximum acceptable data loss measured in time.

| Environment | RPO | Justification |
|-------------|-----|---------------|
| Production | 24 hours | Daily backups; donation data requires minimal loss |
| Staging | 24 hours | Recreatable from production data (anonymized) |
| Development | Best effort | No SLA; data is ephemeral |

## Recovery Time Objective (RTO)

Maximum acceptable downtime during recovery.

| Environment | RTO | Justification |
|-------------|-----|---------------|
| Production | 4 hours | Parish websites must be available for services |
| Staging | 8 hours | Development continuity |
| Development | Best effort | No SLA |

## Escalation

| Severity | Response Time | Escalation |
|----------|---------------|------------|
| P1 — Full outage | 15 minutes | Platform architect + on-call |
| P2 — Partial degradation | 1 hour | On-call engineer |
| P3 — Non-critical failure | 4 hours | Next business day |
