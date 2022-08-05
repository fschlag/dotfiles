if yabai -m query --windows | jq -er "map(select(.id == ${YABAI_WINDOW_ID}).pid)[0] as \$pid | map(select(.pid == \$pid)) | length == 1"; then
    yabai -m window "${YABAI_WINDOW_ID}" --toggle float
fi
