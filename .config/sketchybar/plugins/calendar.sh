#!/bin/bash

# sketchybar --set $NAME icon="$(date '+%a %d. %b')" label="$(date '+%H:%M')"
sketchybar --set $NAME icon="$(date '+%a %d. %b')" label="CN $(TZ='Asia/Shanghai' date '+%H:%M') | UK $(TZ='Europe/London' date '+%H:%M')"
