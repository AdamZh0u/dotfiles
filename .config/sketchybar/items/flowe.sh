sketchybar --add event flow_start \
           --add event flow_end

sketchybar --add item flow_status right \
           --set flow_status \
                 icon="⏱︎" \
                 icon.drawing=off \
                 label.drawing=off \
                 update_freq=0 \
                 script="$PLUGIN_DIR/flow_status.sh" \
           --subscribe flow_status flow_start flow_end
