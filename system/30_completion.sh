# FZF
SHELL_NAME="$(basename $SHELL)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Angular 
if command -v ng > /dev/null; then
    source <(ng completion script)
fi

COMPLETION_SCRIPTS=( kubectl oc k9s helm datree argocd)

for SCRIPT in "${COMPLETION_SCRIPTS[@]}"
do
    if command -v ${SCRIPT} > /dev/null; then
        source <(${SCRIPT} completion ${SHELL_NAME})
    fi
done

