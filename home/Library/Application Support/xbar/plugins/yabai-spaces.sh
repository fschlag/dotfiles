#!/usr/bin/env bash

export PATH=/usr/local/bin:/opt/homebrew/bin:$PATH

OUTPUT=""
MINIMUM_NUMBER_OF_SCREENS_ON_DISPLAY_TO_SHOW=1

while read -r display
do
    
    if [[ $OUTPUT ]]; then
        OUTPUT="${OUTPUT}- "
    else
        OUTPUT="🖥 "
    fi
    for space in $(echo "$display" | xargs echo)
    do
        if yabai -m query --spaces --space "$space" | jq -e 'select(."is-visible" == true)' > /dev/null; then
            OUTPUT="${OUTPUT}[${space}] "
        else
            OUTPUT="${OUTPUT}${space} "
        fi
    done
done < <(yabai -m query --displays | jq -c "sort_by(.frame.x) | .[] | select(.spaces | length > $MINIMUM_NUMBER_OF_SCREENS_ON_DISPLAY_TO_SHOW) | .spaces | @sh")

echo -e "$OUTPUT"
