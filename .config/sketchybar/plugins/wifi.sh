#!/bin/bash

update() {
  source "$CONFIG_DIR/icons.sh"
  # INFO="$(/System/Library/PrivateFrameworks/Apple80211.framework/Resources/airport -I | awk -F ' SSID: '  '/ SSID: / {print $2}')"
  INFO="$(networksetup -getairportnetwork en0 | awk -F': ' '{print $2}')"
  LABEL="$INFO ($(ipconfig getifaddr en0))"
  ICON="$([ -n "$INFO" ] && echo "$WIFI_CONNECTED" || echo "$WIFI_DISCONNECTED")"

  sketchybar --set $NAME icon="$ICON" label="$LABEL"
}

click() {
  CURRENT_WIDTH="$(sketchybar --query $NAME | jq -r .label.width)"

  WIDTH=0
  if [ "$CURRENT_WIDTH" -eq "0" ]; then
    WIDTH=dynamic
  fi

  sketchybar --animate sin 20 --set $NAME label.width="$WIDTH"
}

case "$SENDER" in
  "wifi_change") update
  ;;
  "mouse.clicked") click
  ;;
esac
