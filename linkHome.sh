#!/bin/bash

WORK_DIR="$(dirname $0)"
LOG_FILE="${0}.log"

function log()
{
    echo "$@"
    #echo "$@" | tee -a "$LOG_FILE"
}

log "Running $0 on $(date)"
find $WORK_DIR/home -type f | while IFS= read -r FILE
do
    FILE_RELATIVE_PATH="$(echo $FILE | sed "s!^${WORK_DIR}/home/!!")"
    
    log "$FILE_RELATIVE_PATH"
    PATH_TO_LINK="${HOME}/${FILE_RELATIVE_PATH}"
    PATH_TO_LINK_DIR="$(dirname ${PATH_TO_LINK})"

    if [ ! -d "$PATH_TO_LINK_DIR" ]; 
        log "Creating directory $PATH_TO_LINK_DIR"
        mkdir -p "$PATH_TO_LINK_DIR"
    fi
    
    if [ -f "$PATH_TO_LINK" ] && then
        log "Backing up existing file $PATH_TO_LINK to $PATH_TO_LINK.orig"
        mv "$PATH_TO_LINK" "${PATH_TO_LINK}.orig"
    fi

    log 
done