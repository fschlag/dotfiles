#!/bin/bash
#set -e
#set -o pipefail

find . -type f -name '*.sh' -not -path '*.git*' -print0 | while read -r -d $'\0' file
do
    shellcheck -s bash "$file"
done
