# Shared, persistent zsh history (restores Oh-My-Zsh behaviour).
# SHARE_HISTORY makes every shell append immediately and re-import new
# lines on each prompt, so history is shared live across tmux panes.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt SHARE_HISTORY        # live-share history across concurrent sessions
setopt INC_APPEND_HISTORY   # write commands immediately, not only at exit
setopt EXTENDED_HISTORY     # record command timestamps
setopt HIST_IGNORE_DUPS     # don't store a repeat of the previous command
setopt HIST_IGNORE_SPACE    # ignore commands that start with a space
setopt HIST_VERIFY          # edit a !history expansion before executing it
