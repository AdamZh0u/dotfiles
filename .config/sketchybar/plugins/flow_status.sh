#!/bin/bash

STATE_FILE="/tmp/flow_start_time"

case "$SENDER" in
  "flow_start")
    date +%s > "$STATE_FILE"
    sketchybar --set flow_status \
               icon.drawing=on \
               label.drawing=on \
               label="0" \
               label.color=0xffff6b6b \
               update_freq=60
    ;;
  "flow_end")
    rm -f "$STATE_FILE"
    sketchybar --set flow_status \
               icon.drawing=off \
               label.drawing=off \
               update_freq=0
    ;;
  *)
    if [[ -f "$STATE_FILE" ]]; then
      start=$(cat "$STATE_FILE")
      mins=$(( ( $(date +%s) - start ) / 60 ))
      sketchybar --set flow_status label="${mins}"
    fi
    ;;
esac
