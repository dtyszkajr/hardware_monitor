#! /bin/bash

HOST_NAME=$(uname -n)  # hostname
ES_HOSTS=("10.128.0.21" "10.128.0.22")  # elasticsearch database addresses
ES_INDEX="i_hardware"  # elasticsearch index to index data
ES_TYPE="tp_hardware"  # elasticsearch type to index data
SYS_GROUP="spark"  # host cluster for grouping
SYS_SUBGROUP="worker"  # host subgroup for more grouping

while true; do
    # getting variables
    TIMESTAMP=$(date +%Y-%m-%dT%H:%M:%S)
    CPU_LOAD=$(top -bn1 | grep load | awk '{printf "%.2f", $(NF-2)}')
    CPU_USAGE=$(mpstat -P ALL 1 1 | awk '/Average:/ && $2 ~ /all/ {print $3/100}')
    MEMORY=$(free -m | awk 'NR==2{printf $3 }')
    DISK_READS=$(iostat -dxy 1 1 | tail -n +4 | head -n -1 | awk '{s+=$4} END {print s}')
    DISK_WRITES=$(iostat -dxy 1 1 | tail -n +4 | head -n -1 | awk '{s+=$5} END {print s}')
    DISK_W_KBS=$(iostat -dxy 1 1| tail -n +4 | head -n -1 | awk '{s+=$6} END {print s}')
    DISK_R_KBS=$(iostat -dxy 1 1 | tail -n +4 | head -n -1 | awk '{s+=$7} END {print s}')
    typeset -i RX_BYTES_DELTA=$(cat /tmp/RX_BYTES_DELTA) || tail /dev/null
    typeset -i TX_BYTES_DELTA=$(cat /tmp/TX_BYTES_DELTA) || tail /dev/null
    # sending data
    curl --silent \
        --output /dev/null \
        --max-time 3 \
        -XPOST 'http://'${ES_HOSTS[$RANDOM % ${#ES_HOSTS[@]}]}':9200/'$ES_INDEX'/'$ES_TYPE'/' -d '{
        "group": "'$SYS_GROUP'",
        "subgroup": "'$SYS_SUBGROUP'",
        "hostname": "'$HOST_NAME'",
        "timestamp": "'$TIMESTAMP'",
        "cpu_load": '$CPU_LOAD',
        "cpu_usage": '$CPU_USAGE',
        "ram_load": '$MEMORY',
        "disk_reads": '$DISK_READS',
        "disk_writes": '$DISK_WRITES',
        "disk_r_kbs": '$DISK_R_KBS',
        "disk_w_kbs": '$DISK_W_KBS',
        "net_down_bytes": '$RX_BYTES_DELTA',
        "net_up_bytes": '$TX_BYTES_DELTA'
    }' || tail /dev/null
    # waiting
    sleep 44
done
