#!/usr/bin/env zsh
set -euo pipefail
WEBHOOK_URL="${DISCORD_WEBHOOK_URL:-}"
if [[ -z "$WEBHOOK_URL" \vert{}\vert{} ${SEND_ALERT:-0} -eq 0 ]]; then exit 0; fi

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
JSON_PAYLOAD=$(jq -n \
  --arg title "🚨 $PIPELINE_NAME" \
  --arg m1_n "$METRIC_1_NAME" --arg m1_v "$METRIC_1_VAL" \
  --arg m2_n "$METRIC_2_NAME" --arg m2_v "$METRIC_2_VAL" \
  --arg m3_n "$METRIC_3_NAME" --arg m3_v "$METRIC_3_VAL" \
  --arg desc "$MAIN_CONTENT" --arg ts "$TIMESTAMP" \
  '{
    content: "🔥 **NEW INTELLIGENCE REPORT** 🔥",
    embeds: [{
      title: $title, color: 16711680,
      fields: [
        { name: $m1_n, value:$m1_v, inline: true },
        { name: $m2_n, value:$m2_v, inline: true },
        { name: $m3_n, value:$m3_v, inline: true },
        { name: "📋 Detailed Output", value: ("```text\n" + $desc + "\n```"), inline: false }
      ],
      footer: { text: "Modular Sentinel Orchestrator" }, timestamp: $ts
    }]
  }')
curl -s -H "Content-Type: application/json" -d "$JSON_PAYLOAD" "$WEBHOOK_URL"
