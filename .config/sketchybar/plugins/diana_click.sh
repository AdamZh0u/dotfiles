#!/bin/bash
# 点状态栏上的 Diana：在跑就打开仪表盘，没跑就把它拉起来。
#
# 「没跑」是常态的一部分——网页上有退出按钮，退完图标还留在栏上，
# 就是为了能从这儿再点回去，不用开终端。

DIANA_DIR="${DIANA_DIR:-$HOME/local/diana}"
DIANA_BIN="$DIANA_DIR/.venv/bin/diana"
DASH_PORT="${DIANA_PORT:-8899}"
DASH_URL="http://127.0.0.1:$DASH_PORT"

[ -x "$DIANA_BIN" ] || exit 0

JSON=$(cd "$DIANA_DIR" && "$DIANA_BIN" --status-json --compact 2>/dev/null)
if command -v jq >/dev/null 2>&1; then
  RUNNING=$(jq -r .running <<<"$JSON" 2>/dev/null)
else
  # 没有 jq 就退回抠字符串。字段名不会变，够用了
  grep -q '"running": *true' <<<"$JSON" && RUNNING=true || RUNNING=false
fi

if [ "$RUNNING" = "true" ]; then
  open "$DASH_URL"
  exit 0
fi

# 监工本体。nohup + & 让它脱离 sketchybar 活下去——
# 不脱离的话，sketchybar 重载配置时会把它一起带走
(cd "$DIANA_DIR" && nohup "$DIANA_BIN" >/dev/null 2>&1 &)

# 仪表盘只在端口空着时起，不然第二个进程会撞端口然后退出
if ! nc -z 127.0.0.1 "$DASH_PORT" >/dev/null 2>&1; then
  (cd "$DIANA_DIR" && nohup "$DIANA_BIN" --dashboard --port "$DASH_PORT" >/dev/null 2>&1 &)
fi

# 先把图标点亮，别让人以为没点中；真实状态由下一次 update_freq 覆盖
sketchybar --set "$NAME" icon.color="${GREY:-0xff898781}" label="启动中…" label.drawing=on
( sleep 4; NAME="$NAME" "${PLUGIN_DIR:-$HOME/.config/sketchybar/plugins}/diana.sh" ) &
