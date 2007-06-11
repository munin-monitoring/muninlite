config_load() {
  echo "graph_title Load average
graph_args --base 1000 -l 0
graph_vlabel load
graph_scale no
graph_category system
load.label load
load.warning 10
load.critical 120
graph_info The load average of the machine describes how many processes are in the run-queue (scheduled to run \"immediately\").
load.info Average load for the five minutes."
}
fetch_load() {
  echo "load.value" $(cut -f2 -d\  /proc/loadavg)
}
