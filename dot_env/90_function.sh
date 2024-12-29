#!/usr/bin/env zsh
pidByPort()
{
   echo `ss -tnlp  | grep "${1}" | grep -Po "pid=\K\d+"`
}

cdbg()
{
    FOUND=1
    CURRENT_DIR="$PWD"
    while [ ! -f "${CURRENT_DIR}/build.gradle" ]; do
        CURRENT_DIR="${CURRENT_DIR}/.."
        if [ ! -d "$CURRENT_DIR" ]; then
            echo "No build.gradle found in hierachy"
            FOUND=0
            break
        fi
    done
    [ "$FOUND" -eq 1 ] && cd "$CURRENT_DIR"
}

gidi()
{
    git diff --relative --name-only --diff-filter=d | fzf --preview 'git diff {-1} | diff-so-fancy'
}

wttr()
{
    curl "https://wttr.in/${1:-Paderborn}?m&lang=de"
}
