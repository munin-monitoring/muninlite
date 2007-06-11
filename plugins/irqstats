config_irqstats() {
  echo "graph_title Individual interrupts
graph_args --base 1000 -l 0;
graph_vlabel interrupts / \${graph_period}
graph_category system"
  CPUS=$(grep 'CPU[0-9]' /proc/interrupts | wc -w)
  IINFO=$(sed -e 's/ \{1,\}/ /g' -e 's/^ //' /proc/interrupts  | grep '.:')
  for ID in $(echo "$IINFO" | cut -d: -f1)
  do
    IDL=$(echo "$IINFO" | grep "^$ID:")
    INFO=$(eval "echo \"$IDL\" | cut -d\  -f$((3+$CPUS))-")
    if [ "$INFO" = "" ]; then
      echo "i$ID.label $ID"
    else
      echo "i$ID.label $INFO"
      echo "i$ID.info Interrupt $ID, for device(s): $INFO"
    fi
    echo "i$ID.type DERIVE"
    echo "i$ID.min 0"
  done
}
fetch_irqstats() {
  CPUS=$(grep 'CPU[0-9]' /proc/interrupts | wc -w)
  IINFO=$(sed -e 's/ \{1,\}/ /g' -e 's/^ //' /proc/interrupts  | grep '.:')
  for ID in $(echo "$IINFO" | cut -d: -f1)
  do
    IDL=$(echo "$IINFO" | grep "^$ID:")
    VALS=$(eval "echo \"$IDL\" | cut -d\  -f2-$((1+$CPUS))")
    VALUE=0
    for VAL in $VALS;
    do
      VALUE=$(($VALUE + $VAL))
    done
    echo "i$ID.value $VALUE"
  done
}
