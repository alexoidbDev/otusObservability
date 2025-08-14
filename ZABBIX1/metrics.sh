#!/bin/bash

cat << EOF
{ "data":  [
  { "{#METRICNAME}" : "metric1" },
  { "{#METRICNAME}" : "metric2" },
  { "{#METRICNAME}" : "metric3" }
]}
EOF

agenthost=`hostname -f`
zserver="192.168.250.21"
zport="10051"
mfile=/usr/local/zabbix/metrics.txt
: > $mfile
for metric_name in "metric1" "metric2" "metric3"; do
   metric_value="$(( (SRANDOM % 100)+1 ))"
   echo $agenthost otus_important_metrics[$metric_name] $metric_value >> $mfile
done

zabbix_sender -vv -z $zserver -p $zport -i $mfile >> /usr/local/zabbix/zsender.log 2>&1