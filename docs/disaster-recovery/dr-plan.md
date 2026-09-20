# Disaster Recovery Plan

## Scope

This plan covers recovery of the entire JOL deployment platform from a
complete infrastructure failure.

## Recovery Priorities

| Priority | Component | RTO | RPO |
|----------|-----------|-----|-----|
| P1 | DNS | 1 hour | 0 |
| P2 | Web server VMs | 4 hours | 24 hours |
| P3 | AI services (RAG, LLM, MCP) | 8 hours | 24 hours |
| P4 | Monitoring | 12 hours | Best effort |

## Recovery Procedure

### Phase 1: Assess (0-30 min)
1. Identify failure scope
2. Notify stakeholders
3. Activate DR team

### Phase 2: Infrastructure (30 min - 2 hours)
1. Restore VMs from PBS backups
2. Verify network connectivity
3. Restore DNS records

### Phase 3: Application (2-4 hours)
1. Restore tenant data from backups
2. Restore databases
3. Start application containers
4. Verify health endpoints

### Phase 4: Verification (4-6 hours)
1. Run full test suite
2. Verify tenant accessibility
3. Confirm monitoring operational

### Phase 5: Post-Incident (within 48 hours)
1. Write incident report
2. Identify root cause
3. Update DR plan if needed
