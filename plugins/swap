config_swap() {
  echo "graph_title Swap in/out"
  echo "graph_args -l 0 --base 1000"
  echo "graph_vlabel pages per \${graph_period} in (-) / out (+)"
  echo "graph_category system"
  echo "swap_in.label swap"
  echo "swap_in.type DERIVE"
  echo "swap_in.max 100000"
  echo "swap_in.min 0"
  echo "swap_in.graph no"
  echo "swap_out.label swap"
  echo "swap_out.type DERIVE"
  echo "swap_out.max 100000"
  echo "swap_out.min 0"
  echo "swap_out.negative swap_in"
}
fetch_swap() {
  if [ -f /proc/vmstat ]; then
    SINFO=$(cat /proc/vmstat)
    echo "swap_in.value" $(echo "$SINFO" | grep "^pswpin" | cut -d\  -f2)
    echo "swap_out.value" $(echo "$SINFO" | grep "^pswpout" | cut -d\  -f2)
  else
    SINFO=$(grep "^swap" /proc/stat)
    echo "swap_in.value" $(echo "$SINFO" | cut -d\  -f2)
    echo "swap_out.value" $(echo "$SINFO" | cut -d\  -f3)
  fi
}
