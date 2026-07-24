#!/bin/bash

# Name a tmux window from its active pane's Git context or foreground command.

set -euo pipefail

pane="${TMUX_PANE:-}"
path=""
git_only=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --git-only)
            git_only=true
            shift
            ;;
        --pane)
            [[ $# -ge 2 ]] || {
                echo "Error: --pane requires a value" >&2
                exit 1
            }
            pane="$2"
            shift 2
            ;;
        --path)
            [[ $# -ge 2 ]] || {
                echo "Error: --path requires a value" >&2
                exit 1
            }
            path="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Error: unknown option: $1" >&2
            exit 1
            ;;
    esac
done

readonly -a command_args=("$@")
readonly -a window_colors=(
    colour39 colour45 colour75 colour81 colour111
    colour141 colour147 colour149 colour159 colour171
    colour177 colour203 colour209 colour214 colour220
)

[[ -n "$pane" ]] || exit 0
state_format="#{pane_active}"$'\t'"#{pane_current_path}"$'\t'"#{window_name}"$'\t'"#{@window_color}"
pane_state="$(tmux display-message -p -t "$pane" "$state_format")"
IFS=$'\t' read -r pane_active pane_path current_name current_color <<< "$pane_state"
[[ "$pane_active" == "1" ]] || exit 0

if [[ -z "$path" ]]; then
    path="$pane_path"
fi

if [[ ! -d "$path" ]]; then
    echo "Error: pane path does not exist: $path" >&2
    exit 1
fi

name=""
color_key=""
if git_context="$(git -C "$path" rev-parse --show-toplevel --abbrev-ref HEAD 2>/dev/null)"; then
    if ! $git_only && [[ ${#command_args[@]} -gt 0 ]]; then
        exit 0
    fi

    git_root="${git_context%%$'\n'*}"
    git_branch="${git_context#*$'\n'}"
    if [[ "$git_branch" == "HEAD" ]]; then
        git_branch="$(git -C "$path" rev-parse --short HEAD 2>/dev/null)"
    fi
    project_name=""
    if origin_url="$(git -C "$path" remote get-url origin 2>/dev/null)"; then
        origin_url="${origin_url%/}"
        project_name="${origin_url##*/}"
        project_name="${project_name##*:}"
        project_name="${project_name%.git}"
    fi
    [[ -n "$project_name" ]] || project_name="$(basename "$git_root")"
    project_name="${project_name#aviatar-ea-}"
    name="$project_name:$git_branch"
    color_key="$project_name"
elif $git_only; then
    exit 0
elif [[ ${#command_args[@]} -eq 0 ]]; then
    name="$(basename "$path")"
    color_key="$name"
else
    command_name="$(basename "${command_args[0]}")"
    case "$command_name" in
        bash|dash|fish|ksh|sh|zsh)
            name="$(basename "$path")"
            color_key="$name"
            ;;
        ssh)
            ssh_host=""
            skip_next=false
            options_done=false

            for argument in "${command_args[@]:1}"; do
                if $skip_next; then
                    skip_next=false
                    continue
                fi
                if ! $options_done; then
                    case "$argument" in
                        --)
                            options_done=true
                            continue
                            ;;
                        -B|-b|-c|-D|-E|-e|-F|-I|-i|-J|-L|-l|-m|-O|-o|-p|-Q|-R|-S|-W|-w)
                            skip_next=true
                            continue
                            ;;
                        -*)
                            continue
                            ;;
                    esac
                fi
                ssh_host="$argument"
                break
            done

            if [[ -z "$ssh_host" ]]; then
                current_name="$(tmux display-message -p -t "$pane" '#{window_name}')"
                if [[ "$current_name" == ssh:* ]]; then
                    name="$current_name"
                    color_key="${current_name#ssh:}"
                else
                    name="ssh"
                    color_key="$name"
                fi
            else
                ssh_host="${ssh_host#ssh://}"
                ssh_host="${ssh_host#*@}"
                ssh_host="${ssh_host%%:*}"
                name="ssh:$ssh_host"
                color_key="$ssh_host"
            fi
            ;;
        *)
            name="$command_name"
            color_key="$name"
            ;;
    esac
fi

checksum="$(printf '%s' "$color_key" | cksum)"
checksum="${checksum%% *}"
window_color="${window_colors[checksum % ${#window_colors[@]}]}"

if [[ "$current_color" != "$window_color" ]]; then
    tmux set-option -w -t "$pane" @window_color "$window_color"
fi
if [[ "$current_name" != "$name" ]]; then
    tmux rename-window -t "$pane" "$name"
fi
