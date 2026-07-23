#!/bin/bash

# Wrap tmux window tabs onto additional status rows when they exceed the client width.

set -euo pipefail

readonly MAX_ROWS=5
readonly FALLBACK_WIDTH=200
readonly FIELD_SEPARATOR='@@WRAP_FIELD@@'
readonly ROW_SEPARATOR='@@WRAP_ROW@@'
readonly FORMAT_VERSION='v2'

if ! command -v python3 >/dev/null 2>&1; then
    echo "Error: wrap-tabs.sh requires python3" >&2
    exit 1
fi

tab_row_format() {
    local first_row="$1"
    local first_window="$2"
    local last_window="$3"
    local condition
    local prefix
    local separator
    local normal
    local current

    condition="#{&&:#{e|>=:#{window_index},${first_window}},#{e|<=:#{window_index},${last_window}}}"
    separator="#{?#{e|<:#{window_index},${last_window}},#{E:window-status-separator},}"
    normal="#{?${condition},#[range=window|#{window_index}]#[push-default]#{T:window-status-format}#[pop-default]#[norange default]${separator},}"
    current="#{?${condition},#[range=window|#{window_index} list=focus]#[push-default]#{T:window-status-current-format}#[pop-default]#[norange default]${separator},}"

    if [[ "$first_row" == "true" ]]; then
        prefix='#[align=left range=left #{E:status-left-style}]#[push-default]#{T;=/#{status-left-length}:status-left}#[pop-default]#[norange default]'
    else
        prefix='#[align=left]'
    fi

    printf '%s' "${prefix}#[list=on align=left]#[list=left-marker]<#[list=right-marker]>#[list=on]#{W:${normal},${current}}#[nolist]"
}

global_width="$(tmux list-clients -F '#{client_width}' 2>/dev/null | sort -n | head -1 || true)"
[[ "$global_width" =~ ^[0-9]+$ && "$global_width" -gt 0 ]] || global_width="$FALLBACK_WIDTH"

sessions="$(tmux list-sessions -F '#{session_id}' 2>/dev/null || true)"
[[ -n "$sessions" ]] || exit 0

for session in $sessions; do
    width="$(tmux list-clients -t "$session" -F '#{client_width}' 2>/dev/null | sort -n | head -1 || true)"
    [[ "$width" =~ ^[0-9]+$ && "$width" -gt 0 ]] || width="$global_width"

    status_left="$(tmux display-message -p -t "$session" '#{T;=/#{status-left-length}:status-left}')"
    window_separator="$(tmux display-message -p -t "$session" '#{window-status-separator}')"
    windows="$(tmux list-windows -t "$session" \
        -F "#{window_index}${FIELD_SEPARATOR}#{T:window-status-format}${FIELD_SEPARATOR}#{T:window-status-current-format}${ROW_SEPARATOR}")"

    row_output="$(
        printf '%s%s%s%s%s' \
            "$width" "$FIELD_SEPARATOR" "$status_left" "$FIELD_SEPARATOR" \
            "$window_separator$FIELD_SEPARATOR$windows" |
            WRAP_MAX_ROWS="$MAX_ROWS" WRAP_FIELD_SEPARATOR="$FIELD_SEPARATOR" \
                WRAP_ROW_SEPARATOR="$ROW_SEPARATOR" \
                python3 -c '
import os
import re
import sys
import unicodedata

field_separator = os.environ["WRAP_FIELD_SEPARATOR"]
row_separator = os.environ["WRAP_ROW_SEPARATOR"]
max_rows = int(os.environ["WRAP_MAX_ROWS"])


def visible_width(value):
    value = re.sub(r"#\[[^]]*\]", "", value)
    return sum(
        2 if unicodedata.east_asian_width(character) in ("W", "F") else 1
        for character in value
    )


width_text, status_left, payload = sys.stdin.read().split(field_separator, 2)
window_separator, windows = payload.split(field_separator, 1)
width = int(width_text)
items = []

for entry in filter(None, windows.split(row_separator)):
    index, normal, current = entry.split(field_separator, 2)
    items.append((int(index), max(visible_width(normal), visible_width(current))))

rows = []
used = visible_width(status_left)
separator_width = visible_width(window_separator)

for index, tab_width in items:
    if not rows:
        rows.append([index, index])
        used += tab_width
        continue

    required = separator_width + tab_width
    if used + required > width and len(rows) < max_rows:
        rows.append([index, index])
        used = tab_width
    else:
        rows[-1][1] = index
        used += required

for first, last in rows:
    print(first, last)
'
    )"
    rows=()
    while IFS= read -r row; do
        [[ -n "$row" ]] && rows+=("$row")
    done <<< "$row_output"

    [[ ${#rows[@]} -gt 0 ]] || continue

    signature="${FORMAT_VERSION}:${width}:${rows[*]}"
    current_signature="$(tmux show-options -qv -t "$session" @wrap_tabs_signature 2>/dev/null || true)"
    [[ "$signature" == "$current_signature" ]] && continue

    if [[ ${#rows[@]} -eq 1 ]]; then
        tmux set-option -u -t "$session" status 2>/dev/null || true
        tmux set-option -u -t "$session" status-format 2>/dev/null || true
    else
        tmux set-option -u -t "$session" status-format 2>/dev/null || true
        tmux set-option -t "$session" status "${#rows[@]}"

        row_index=0
        for row in "${rows[@]}"; do
            first_window="${row%% *}"
            last_window="${row##* }"
            first_row=false
            [[ "$row_index" -eq 0 ]] && first_row=true
            tmux set-option -t "$session" "status-format[$row_index]" \
                "$(tab_row_format "$first_row" "$first_window" "$last_window")"
            row_index=$((row_index + 1))
        done
    fi

    tmux set-option -t "$session" @wrap_tabs_signature "$signature"
done
