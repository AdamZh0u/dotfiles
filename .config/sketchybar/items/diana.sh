#!/bin/bash

diana=(
  script="$PLUGIN_DIR/diana.sh"
  icon.font="$FONT:Regular:14.0"
  label.font="$FONT:Regular:12.0"
  padding_right=6
  padding_left=6
  update_freq=5
  updates=on
  click_script="$PLUGIN_DIR/diana_click.sh"
)

sketchybar --add item diana right    \
           --set diana "${diana[@]}" \
           --subscribe diana system_woke
