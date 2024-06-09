#!/bin/bash
# chmod +x /Users/adamzh0u/.config/sketchybar/plugins/email.sh
source "$CONFIG_DIR/colors.sh"

STATUS_LABEL="$(lsappinfo info -only StatusLabel "Mail")"

COUNT="$(echo $STATUS_LABEL | grep -o '"StatusLabel"={ "label"="[0-9]*" }' | grep -o '[0-9]*')"

COLOD=$RED
# echo $COUNT
case "$COUNT" in
  [3-5][0-9]) COLOR=$RED
  ;;
  [1-2][0-9]) COLOR=$ORANGE
  ;;
  [1-9]) COLOR=$YELLOW
  ;;
  0) COLOR=$WHITE
  ;;
  "") COLOR=$GREEN  
    COUNT=0
  ;;
esac

sketchybar --set $NAME label=$COUNT icon.color=$COLOR
