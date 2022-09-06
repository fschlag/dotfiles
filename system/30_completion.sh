# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Angular 
if command -v ng > /dev/null; then
    source <(ng completion script)
fi

# Podman
if command -v podman > /dev/null; then
    source <(podman completion $(basename $SHELL))
fi

# kubectl
if command -v kubectl > /dev/null; then
    source <(kubectl completion zsh)
fi

# OpenShift CLI
if command -v oc > /dev/null; then
    source <(oc completion zsh)
fi

# k9s
if command -v k9s > /dev/null; then
    source <(k9s completion zsh)
fi
