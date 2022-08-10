#!/usr/bin/env bash

export PATH=/usr/local/bin:/opt/homebrew/bin:$PATH
source ~/bin/i_fa.sh
OUTPUT=""
while read display
do
    
    if [ "x$OUTPUT" != "x" ]; then
        OUTPUT="${OUTPUT}- "
    else
        OUTPUT="🖥 "
    fi
    for space in $(echo $display | xargs echo)
    do
        if yabai -m query --spaces --space "$space" | jq -e 'select(."is-visible" == true)' > /dev/null; then
            OUTPUT="${OUTPUT}[${space}] "
        else
            OUTPUT="${OUTPUT}${space} "
        fi
    done
done < <(yabai -m query --displays | jq -c 'sort_by(.frame.x) | .[] | select(.spaces | length > 1) | .spaces | @sh')

echo -e "$OUTPUT"
