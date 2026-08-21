TOTAL=$(grep -v "^#" logs/app.log | wc -l)
ONLINE=$(grep -v "^#" logs/app.log | grep -i "online" | wc -l)
TOP=$(grep -v "^#" logs/app.log | awk -F',' '{print $6}' | tr -d '"' | sort | uniq -c | sort -nr | head -n 3)
export PIPELINE_NAME="Threat Intelligence Feed"
export METRIC_1_NAME="Total Malicious URLs"; export METRIC_1_VAL="$TOTAL"
export METRIC_2_NAME="Active Threats"; export METRIC_2_VAL="$ONLINE"
export METRIC_3_NAME="Data Source"; export METRIC_3_VAL="Abuse.ch URLhaus"
export MAIN_CONTENT="Top Malware Tags:\n$TOP"
export SEND_ALERT=1
