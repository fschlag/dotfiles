# FZF
SHELL_NAME="$(basename $SHELL)"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Angular 
if command -v ng > /dev/null; then
    source <(ng completion script)
fi

# Podman
if command -v podman > /dev/null; then
    source <(podman completion ${SHELL_NAME})
fi

# kubectl
if command -v kubectl > /dev/null; then
    source <(kubectl completion ${SHELL_NAME})
fi

# OpenShift CLI
if command -v oc > /dev/null; then
    source <(oc completion ${SHELL_NAME})
fi

# k9s
if command -v k9s > /dev/null; then
    source <(k9s completion ${SHELL_NAME})
fi

# helm
if command -v helm > /dev/null; then
    source <(helm completion ${SHELL_NAME})
fi
