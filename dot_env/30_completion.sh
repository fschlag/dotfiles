# FZF
SHELL_NAME="$(basename $SHELL)"

if command -v fzf > /dev/null; then
    FZF_VER="$(fzf --version | cut -d' ' -f1)"
    if [ -d "/opt/homebrew/Cellar/fzf/${FZF_VER}/shell/" ]; then
        source "/opt/homebrew/Cellar/fzf/${FZF_VER}/shell/completion.zsh"
        source "/opt/homebrew/Cellar/fzf/${FZF_VER}/shell/key-bindings.zsh"
    fi
fi

# Angular 
if command -v ng > /dev/null; then
    source <(ng completion script)
fi

COMPLETION_SCRIPTS=( kubectl oc k9s helm datree argocd podman flux)

for SCRIPT in "${COMPLETION_SCRIPTS[@]}"
do
    if command -v ${SCRIPT} > /dev/null; then
        source <(${SCRIPT} completion ${SHELL_NAME})
    fi
done

