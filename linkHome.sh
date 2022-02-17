#!/bin/bash

WORK_DIR="$(dirname $0)"
LOG_FILE="${0}.log"

function log()
{
    echo "$@" | tee -a "$LOG_FILE"
}

log "Running $0 on $(date)"
find $WORK_DIR/home -type f | while IFS= read -r FILE
do
    FILE_FULL_PATH="$(readlink -f $FILE)"
    FILE_RELATIVE_PATH="$(echo $FILE | sed "s!^${WORK_DIR}/home/!!")"
    
    log "Installing $FILE_RELATIVE_PATH"
    PATH_TO_LINK="${HOME}/${FILE_RELATIVE_PATH}"
    PATH_TO_LINK_DIR="$(dirname ${PATH_TO_LINK})"

    if [ ! -d "$PATH_TO_LINK_DIR" ]; then
        log "Creating directory $PATH_TO_LINK_DIR"
        mkdir -p "$PATH_TO_LINK_DIR"
    fi
    
    if [ "$FILE_FULL_PATH" == "$(readlink -f $PATH_TO_LINK)" ]; then
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
