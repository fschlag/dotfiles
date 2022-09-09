#!/usr/bin/env bash

WORK_DIR="$(dirname "$0")"
LOG_FILE="${0}.log"

READLINK="readlink"

[[ $(uname -s) == "Darwin" ]] && READLINK="greadlink"

function log()
{
    echo "$@" | tee -a "$LOG_FILE"
}

log "Running $0 on $(date)"
find "${WORK_DIR}/home" -type f | while IFS= read -r FILE
do
    FILE_FULL_PATH="$($READLINK -f "$FILE")"
    FILE_RELATIVE_PATH="$(echo "$FILE" | sed "s!^${WORK_DIR}/home/!!")"

    if grep "$FILE_RELATIVE_PATH" "${WORK_DIR}/$(basename "$0" ".sh")."*".whitelist" > /dev/null 2>&1; then
        if grep "$FILE_RELATIVE_PATH" "${WORK_DIR}/$(basename "$0" ".sh").$(uname -s).whitelist" > /dev/null 2>&1; then
            echo "Found $FILE_RELATIVE_PATH on whitelist for $(uname -s)"
        else
            echo "Did not found $FILE_RELATIVE_PATH on whitelist for $(uname -s). Not installing."
            continue
        fi
    fi
    
    log "Installing $FILE_RELATIVE_PATH"
    PATH_TO_LINK="${HOME}/${FILE_RELATIVE_PATH}"
    PATH_TO_LINK_DIR="$(dirname "${PATH_TO_LINK}")"

    if [ ! -d "$PATH_TO_LINK_DIR" ]; then
        log "Creating directory $PATH_TO_LINK_DIR"
        mkdir -p "$PATH_TO_LINK_DIR"
    fi
    
    if [ "$FILE_FULL_PATH" == "$($READLINK -f "$PATH_TO_LINK")" ]; then
        log "$PATH_TO_LINK already installed"
    else
        if [ -f "$PATH_TO_LINK" ]; then
            log "Backing up existing file $PATH_TO_LINK to $PATH_TO_LINK.orig"
            mv "$PATH_TO_LINK" "${PATH_TO_LINK}.orig"
        fi

        log "Linking $PATH_TO_LINK to $FILE_FULL_PATH"
        ln -s "$FILE_FULL_PATH" "$PATH_TO_LINK"
    fi
done
