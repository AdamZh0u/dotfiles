#!/bin/sh
# 两块屏一起切桌面。
#   按一次：每块屏都切到自己的最后一个桌面（显示器 1 -> 2，显示器 2 -> 5）
#   已经在最后：再按一次，每块屏都切到自己的第一个桌面（1 -> 1，2 -> 3）
# 无状态，只看当前位置。
#
# 注意 jq 里必须写 .["has-focus"]，写成 .has-focus 会被当成减法。

all=$(yabai -m query --spaces)
cur=$(printf '%s' "$all" | jq -r '.[] | select(.["has-focus"]) | .index')
[ -z "$cur" ] && exit 0

# 当前聚焦的桌面是否已经是它所在那块屏的最后一个
at_last=$(printf '%s' "$all" | jq -r --argjson c "$cur" '
    group_by(.display)[] | select(any(.[]; .index == $c)) | max_by(.index).index == $c')

if [ "$at_last" = true ]; then
    pick=min_by
else
    pick=max_by
fi

# 每块屏各取一个目标桌面，依次切过去（显示器序号小的先切，焦点留在最后一块屏）
printf '%s' "$all" | jq -r "group_by(.display)[] | ${pick}(.index).index" |
    while read -r space; do
        yabai -m space --focus "$space"
    done
