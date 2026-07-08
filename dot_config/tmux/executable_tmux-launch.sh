#!/bin/bash

# ============================================================================
# tmux launcher for new terminal windows.
#   - no sessions running  -> start a fresh session
#   - sessions exist        -> fzf menu to pick "+ new session" or attach to one
# ============================================================================

set -euo pipefail

readonly NEW_LABEL='+ new session'

# Already inside tmux (nested) - nothing to launch.
[[ -n "${TMUX:-}" ]] && exit 0

# No tmux at all - fall back to a plain shell.
if ! command -v tmux >/dev/null 2>&1; then
    exec "${SHELL:-/bin/zsh}"
fi

sessions="$(tmux list-sessions -F '#{session_name}' 2>/dev/null || true)"

# Nothing running yet -> just start a session.
if [[ -z "$sessions" ]]; then
    exec tmux new-session
fi

# Without fzf, keep it simple: attach to the most recent session.
if ! command -v fzf >/dev/null 2>&1; then
    exec tmux attach
fi

choice="$(printf '%s\n%s\n' "$NEW_LABEL" "$sessions" \
    | fzf --reverse --height=40% --prompt='tmux ❯ ' \
          --header='Enter: attach · Esc: new session')" || true

if [[ -z "$choice" || "$choice" == "$NEW_LABEL" ]]; then
    exec tmux new-session
else
    exec tmux attach -t "$choice"
fi
