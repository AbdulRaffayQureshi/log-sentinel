DATA=$(cat logs/app.log)
export PIPELINE_NAME="Crypto Market Pulse (BTC/USDT)"
export METRIC_1_NAME="Current Price"; export METRIC_1_VAL="$(echo "$DATA" | jq -r '.lastPrice // "N/A"')"
export METRIC_2_NAME="24h Change"; export METRIC_2_VAL="$(echo "$DATA" | jq -r '(.priceChangePercent // "0") + "%"')"
export METRIC_3_NAME="Total Volume"; export METRIC_3_VAL="$(echo "$DATA" | jq -r '.volume // "N/A"')"
export MAIN_CONTENT="24h High: $(echo "$DATA" | jq -r '.highPrice // "N/A"') | 24h Low: $(echo "$DATA" | jq -r '.lowPrice // "N/A"')"
export SEND_ALERT=1
