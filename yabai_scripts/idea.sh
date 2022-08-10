# if yabai -m query --windows | jq -er "map(select(.id == ${YABAI_WINDOW_ID}).pid)[0] as \$pid | map(select(.pid == \$pid)) | length == 1"; then
#     yabai -m window "${YABAI_WINDOW_ID}" --toggle float
# fi

# if yabai -m query --windows | jq -er "map(select((.id == ${YABAI_WINDOW_ID}) and (.title | contains(\"~/Development\")))) | length == 1" > /dev/null; then
#     yabai -m window "${YABAI_WINDOW_ID}" --toggle float
# fi
