# Hardware Metrics Collector

### Installing/Configuring

* configure your elasticsearch cluster and create the index using es_index_config.json (PUT localhost:9200/i_hardware) ;
* configure ES_HOSTS variable in hardware_monitor.sh to point to your es cluster;
* install sysstat (sudo apt-get install systat -y)
* for each instance/cluster, configure SYS_GROUP and SYS_SUBGROUP variables in hardware_monitor.sh
* add to /etc/rc.local (before exit 0):
```bash
bash /home/ubuntu/network_monitor.sh >> /dev/null 2>&1 & echo $! > /tmp/NETWORK_MONITOR.pid
bash /home/ubuntu/hardware_monitor.sh >> /dev/null 2>&1 & echo $! > /tmp/HARDWARE_MONITOR.pid
```
* make sure /tmp folder has free access (sudo chmod a+rw -R /tmp);
* reset instances or execute (changing file locations):
```bash
nohup bash /home/ubuntu/network_monitor.sh >> /dev/null 2>&1 & echo $! > /tmp/NETWORK_MONITOR.pid
nohup bash /home/ubuntu/hardware_monitor.sh >> /dev/null 2>&1 & echo $! > /tmp/HARDWARE_MONITOR.pid
```
* if you need to kill the process to update or whatelse
```bash
kill -9 `cat /tmp/NETWORK_MONITOR.pid`
kill -9 `cat /tmp/HARDWARE_MONITOR.pid`
```

### Seeing Metrics

* We use Grafana;

### TODO
* Analyse need for weekly indexes to easily delete old data (and maybe performance?);
