#!/usr/bin/env bash
# =============================================================================
# notify-bot.sh — Notification agent (Slack/email)
# =============================================================================
set -euo pipefail

CHANNEL="${1:-#jol-deploy}"
MESSAGE="${2:?Usage: notify-bot.sh <channel> <message>}"

echo "[$(date -u +%Y-%m-%dT%H:%M:%SZ)] Notification → $CHANNEL: $MESSAGE"

# Slack webhook integration
if [ -n "${SLACK_WEBHOOK_URL:-}" ]; then
  PAYLOAD=$(jq -nc --arg ch "$CHANNEL" --arg txt "$MESSAGE" '{channel: $ch, text: $txt}')
  curl -sf -X POST "$SLACK_WEBHOOK_URL" \
    -H 'Content-Type: application/json' \
    -d "$PAYLOAD" || true
fi

# Email notification (via sendmail/msmtp)
if [ -n "${ALERT_EMAIL:-}" ]; then
  echo "$MESSAGE" | mail -s "[jol-deploy] $CHANNEL" "$ALERT_EMAIL" 2>/dev/null || true
fi
