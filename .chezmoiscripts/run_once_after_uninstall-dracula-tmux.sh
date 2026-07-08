#!/bin/bash

# ============================================================================
# One-time migration: remove the Dracula tmux plugin.
#
# We dropped the `dracula/tmux` TPM plugin in favour of a native status bar,
# but TPM never deletes a plugin just because its `@plugin` line is gone.
# This runs once per machine (chezmoi run_once_) to clean it up.
# ============================================================================

set -euo pipefail

readonly TMUX_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/tmux"
readonly PLUGIN_DIR="$TMUX_DIR/plugins/tmux"   # the dracula/tmux repo installs here

# Only remove it if it exists AND is actually the Dracula plugin.
if [[ -d "$PLUGIN_DIR" && -f "$PLUGIN_DIR/dracula.tmux" ]]; then
    echo "Removing Dracula tmux plugin at $PLUGIN_DIR"
    rm -rf "$PLUGIN_DIR"

    # Best-effort: reload any running tmux server so the native bar applies now.
    # Safe because the plugin dir is already gone (nothing to re-inject).
    if command -v tmux >/dev/null 2>&1 && tmux list-sessions >/dev/null 2>&1; then
        tmux source-file "$TMUX_DIR/tmux.conf" >/dev/null 2>&1 || true
        echo "Reloaded running tmux config"
    fi
else
    echo "Dracula tmux plugin not present, nothing to do"
fi
