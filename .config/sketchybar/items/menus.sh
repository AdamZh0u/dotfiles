#!/bin/bash

# 依赖：需要 $CONFIG_DIR/helpers/menus/bin/menus 可执行文件
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"

# 一些设置，需要根据你的实际情况调整
FONT_STYLE_HEAVY="Heavy"        # 例如 "SF Pro:Heavy:16.0"
FONT_STYLE_SEMIBOLD="Semibold"  # 例如 "SF Pro:Semibold:16.0"
PADDINGS=5                      # 内外边距
BACKGROUND_COLOR="0xff1d2021"   # 对应 colors.bg1

# 1. 添加辅助 item
sketchybar --add item menu_watcher left                     \
           --set menu_watcher drawing=off updates=off

sketchybar --add item space_menu_swap left                  \
           --set space_menu_swap drawing=off updates=on

# 注册自定义事件
sketchybar --add event swap_menus_and_spaces

# 2. 预创建菜单 item (menu.1 .. menu.15)
MAX_ITEMS=15
for i in $(seq 1 $MAX_ITEMS); do
  STYLE="$FONT_STYLE_SEMIBOLD"
  [ "$i" -eq 1 ] && STYLE="$FONT_STYLE_HEAVY"

  sketchybar --add item "menu.$i" left                      \
             --set "menu.$i"                                \
                 padding_left="$PADDINGS"                   \
                 padding_right="$PADDINGS"                  \
                 drawing=off                                \
                 icon.drawing=off                           \
                 label.font="$STYLE"                        \
                 label.padding_left=6                       \
                 label.padding_right=6                      \
                 click_script="$CONFIG_DIR/helpers/menus/bin/menus -s $i"
done

# 3. 创建 bracket 并为 menu.* 设置背景
sketchybar --add bracket menu_bracket '/menu\\..*/'         \
           --set menu_bracket background.color="$BACKGROUND_COLOR"

# 4. 菜单与其它元素的占位分隔
sketchybar --add item menu.padding left                     \
           --set menu.padding drawing=off width=5

# 5. 更新菜单的函数（通过事件触发时执行）
update_menus() {
  # 获取当前应用菜单
  MENUS=$("$CONFIG_DIR/helpers/menus/bin/menus" -l)
  # 隐藏所有菜单
  sketchybar --set '/menu\\..*/' drawing=off
  # 显示分隔
  sketchybar --set menu.padding drawing=on

  local id=1
  while IFS= read -r line; do
    if [ "$id" -lt "$MAX_ITEMS" ]; then
      sketchybar --set "menu.$id" label="$line" drawing=on
      id=$((id + 1))
    else
      break
    fi
  done <<< "$MENUS"
}

# 6. 订阅事件
# 前台应用切换时更新菜单
sketchybar --subscribe menu_watcher front_app_switched      \
           --set menu_watcher script="'$0' update"

# 处理 swap_menus_and_spaces 事件
# 我们需要一个脚本来判断状态并切换，因此绑定到 space_menu_swap
sketchybar --subscribe space_menu_swap swap_menus_and_spaces \
           --set space_menu_swap script="'$0' swap"

# 7. 事件处理分支（通过脚本参数区分）
if [ "$1" = "update" ]; then
  update_menus
elif [ "$1" = "swap" ]; then
  # 检查当前 menu.1 是否可见
  DRAWING=$(sketchybar --query menu.1 | jq -r '.geometry.drawing')
  if [ "$DRAWING" = "on" ]; then
    # 切换到 spaces 模式
    sketchybar --set menu_watcher updates=off
    sketchybar --set '/menu\\..*/' drawing=off
    sketchybar --set menu.padding drawing=off
    sketchybar --set '/space\\..*/' drawing=on
    sketchybar --set front_app drawing=on
  else
    # 切换到菜单模式
    sketchybar --set menu_watcher updates=on
    sketchybar --set '/space\\..*/' drawing=off
    sketchybar --set front_app drawing=off
    update_menus
  fi
fi
