#!/bin/bash

cpu_top=(
  label.font="$FONT:Semibold:7"
  label=CPU
  icon.drawing=off
  width=0
  padding_right=0
  y_offset=6
)

cpu_percent=(
  label.font="$FONT:Heavy:12"
  label=CPU
  y_offset=-4
  padding_right=2
  width=36
  icon.drawing=off
  update_freq=4
  mach_helper="$HELPER"
)

cpu_sys=(
  width=0
  graph.color=$RED
  graph.fill_color=$RED
  label.drawing=off
  icon.drawing=off
  background.height=30
  background.drawing=on
  background.color=$TRANSPARENT
)

cpu_user=(
  graph.color=$BLUE
  label.drawing=off
  icon.drawing=off
  background.height=30
  background.drawing=on
  background.color=$TRANSPARENT
)

gpu_top=(
  label.font="$FONT:Semibold:7"
  label=GPU
  icon.drawing=off
  width=0
  padding_left=0
  padding_right=0
  y_offset=6
)

gpu_percent=(
  label.font="$FONT:Heavy:12"
  label=GPU
  y_offset=-4
  padding_left=0
  padding_right=2
  width=36
  icon.drawing=off
  update_freq=4
  script="$PLUGIN_DIR/gpu.sh"
)

gpu_load=(
  width=0
  graph.color=$GREEN
  graph.fill_color=$TRANSPARENT
  label.drawing=off
  icon.drawing=off
  background.height=30
  background.drawing=on
  background.color=$TRANSPARENT
)

# Labels first (CPU% / GPU% stacked pairs), then a single shared graph.
# cpu.sys and gpu.load are width=0 so they overlay onto cpu.user's region,
# producing one graph with three lines: red(fill)=sys, blue=user, green=gpu.
sketchybar --add item cpu.top right              \
           --set cpu.top "${cpu_top[@]}"         \
                                                 \
           --add item cpu.percent right          \
           --set cpu.percent "${cpu_percent[@]}" \
                                                 \
           --add item gpu.top right              \
           --set gpu.top "${gpu_top[@]}"         \
                                                 \
           --add item gpu.percent right          \
           --set gpu.percent "${gpu_percent[@]}" \
                                                 \
           --add graph cpu.sys right 75          \
           --set cpu.sys "${cpu_sys[@]}"         \
                                                 \
           --add graph gpu.load right 75         \
           --set gpu.load "${gpu_load[@]}"       \
                                                 \
           --add graph cpu.user right 75         \
           --set cpu.user "${cpu_user[@]}"
