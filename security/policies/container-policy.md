# Container Security Policy

## Base Image Rules

1. **Alpine-based only** — minimal attack surface
2. **Pin versions** — never use `latest` tag
3. **Non-root user** — every container MUST run as non-root
4. **Read-only filesystem** — where possible (`readOnlyRootFilesystem: true`)

## Build Rules

1. **Multi-stage builds** — build tools never in production image
2. **No secrets in layers** — use runtime env vars or mounted secrets
3. **SBOM required** — every image must have a generated SBOM
4. **Image signing** — all production images signed with cosign

## Runtime Rules

1. **Resource limits** — CPU and memory limits mandatory
2. **Network isolation** — each tenant in its own Docker network
3. **Health checks** — every container must define a HEALTHCHECK
4. **Log rotation** — JSON file driver with max-size/max-file

## Vulnerability Scanning

- **Build time**: Trivy scan in CI, fail on CRITICAL
- **Registry**: Grype scan on push, fail on CRITICAL/HIGH
- **Runtime**: Weekly scan of all running images
