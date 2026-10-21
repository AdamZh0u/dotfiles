#!/bin/bash
# Diana —— 专注监工的状态。读 `diana --status-json`（约 60ms，只读快照，不碰 Agent）。
#
# 规则（快照多久算过期、任务名截多长、没有块时显示什么）都在 Python 那边，
# 这里不重复实现，免得两处不一致。

source "${CONFIG_DIR:-$HOME/.config/sketchybar}/colors.sh"

DIANA_DIR="${DIANA_DIR:-$HOME/local/diana}"
DIANA_BIN="$DIANA_DIR/.venv/bin/diana"
[ -x "$DIANA_BIN" ] || { sketchybar --set "$NAME" drawing=off; exit 0; }

JSON=$(cd "$DIANA_DIR" && "$DIANA_BIN" --status-json --compact 2>/dev/null) || {
  sketchybar --set "$NAME" drawing=off; exit 0
}

if command -v jq >/dev/null 2>&1; then
  STATE=$(jq -r .state <<<"$JSON")
  LABEL=$(jq -r .label <<<"$JSON")
  RUNNING=$(jq -r .running <<<"$JSON")
else
  STATE="idle"; RUNNING="true"
  LABEL=$(cd "$DIANA_DIR" && "$DIANA_BIN" --status 2>/dev/null)
fi

# Agent 没跑：不收起来，画一个灰月亮——它在睡觉，点一下就能叫醒。
# （收起来的话，退出之后状态栏上就没有能点的东西了，只能回终端）
if [ "$RUNNING" != "true" ]; then
  sketchybar --set "$NAME" drawing=on \
    icon="􀆹" icon.color="${GREY:-0xff898781}" \
    label.drawing=off
  exit 0
fi

# 三种基本形态：月亮=睡着了，圆圈=醒着但没活干，太阳=正在任务上。
# 跑偏和看不到状态另给形状，那两种要一眼认出来，不能跟太阳混在一起。
# 用 colors.sh 里的配色，跟状态栏其它 item 保持一致
case "$STATE" in
  on)      ICON="􀆮"; COLOR="$GREEN"  ;;   # 在任务上：太阳
  off)     ICON="􀇾"; COLOR="$ORANGE" ;;   # 跑偏了
  afk)     ICON="􀸙"; COLOR="$GREY"   ;;   # 离开了
  aw_down) ICON="􀏮"; COLOR="$RED"    ;;   # 看不到状态
  *)       ICON="􀀀"; COLOR="$GREY"   ;;   # 待命：空心圆
esac

# 标签只留剩余时间——状态栏放不下任务名，图标已经说清了在不在状态。
# 完整任务名点开仪表盘看。
sketchybar --set "$NAME" drawing=on \
  icon="$ICON" icon.color="${COLOR:-0xff898781}" \
  label="$LABEL" label.color="${COLOR:-0xff898781}" \
  label.drawing=$([ -n "$LABEL" ] && echo on || echo off)
