#!/bin/bash

source "$CONFIG_DIR/colors.sh"

# GPU utilization via IOAccelerator (no sudo required, works on Apple Silicon)
UTIL=$(ioreg -r -d 1 -w 0 -c IOAccelerator 2>/dev/null \
       | grep -Eo '"Device Utilization %"=[0-9]+' \
       | head -1 \
       | grep -Eo '[0-9]+')

# Fallback if the key is not present
[ -z "$UTIL" ] && UTIL=0

# Color thresholds mirror the CPU module
if   [ "$UTIL" -ge 70 ]; then COLOR=$RED
elif [ "$UTIL" -ge 30 ]; then COLOR=$ORANGE
elif [ "$UTIL" -ge 10 ]; then COLOR=$YELLOW
else                          COLOR=$LABEL_COLOR
fi

# Graph wants a value in [0,1]
LOAD=$(awk -v u="$UTIL" 'BEGIN { printf "%.2f", u/100 }')

sketchybar --set gpu.percent label="${UTIL}%" label.color="$COLOR" \
           --push gpu.load "$LOAD"
