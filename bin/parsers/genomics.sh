DATA=$(cat logs/app.log)
export PIPELINE_NAME="Genomic Variant Sentinel (SLC6A4)"
export METRIC_1_NAME="Gene Symbol"; export METRIC_1_VAL="$(echo "$DATA" | jq -r '.display_name // "SLC6A4"')"
export METRIC_2_NAME="Biotype"; export METRIC_2_VAL="$(echo "$DATA" | jq -r '.biotype // "N/A"')"
export METRIC_3_NAME="Assembly"; export METRIC_3_VAL="$(echo "$DATA" | jq -r '.assembly_name // "N/A"')"
export MAIN_CONTENT="Coordinates: $(echo "$DATA" | jq -r '.seq_region_name // "N/A"'):$(echo "$DATA" | jq -r '.start // "N/A"')-$(echo "$DATA" | jq -r '.end // "N/A"')\nTranscripts Mapped: $(echo "$DATA" | jq '.Transcript | length // 0')"
export SEND_ALERT=1
