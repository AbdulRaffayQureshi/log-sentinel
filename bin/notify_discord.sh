#!/usr/bin/env bash
set -euo pipefail

# Safely grab variables
WEBHOOK_URL="${DISCORD_WEBHOOK_URL:-}"
DO_ALERT="${SEND_ALERT:-0}"

# Foolproof condition checks
if [ "$WEBHOOK_URL" = "" ]; then
    echo "[-] Webhook URL missing. Exiting silently."
    exit 0
fi

if [ "$DO_ALERT" != "1" ]; then
    echo "[-] Alert condition not met. Exiting silently."
    exit 0
fi

# Build the JSON Payload with safety fallbacks (:-"N/A")
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
JSON_PAYLOAD=$(jq -n \
  --arg title "🚨 ${PIPELINE_NAME:-Unknown Pipeline}" \
  --arg m1_n "${METRIC_1_NAME:-Metric 1}" --arg m1_v "${METRIC_1_VAL:-N/A}" \
  --arg m2_n "${METRIC_2_NAME:-Metric 2}" --arg m2_v "${METRIC_2_VAL:-N/A}" \
  --arg m3_n "${METRIC_3_NAME:-Metric 3}" --arg m3_v "${METRIC_3_VAL:-N/A}" \
  --arg desc "${MAIN_CONTENT:-No details provided}" --arg ts "$TIMESTAMP" \
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

# Fire the alert
curl -s -H "Content-Type: application/json" -d "$JSON_PAYLOAD" "$WEBHOOK_URL"
echo -e "\n[+] Discord notification deployed."
