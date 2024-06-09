#!/bin/bash

email=(
  icon=$MAIL
  label=?
  padding_right=6
  update_freq=60
  script="$PLUGIN_DIR/email.sh"
)

sketchybar --add event email_update \
           --add item email right   \
           --set email "${email[@]}" \
           --subscribe email email_update