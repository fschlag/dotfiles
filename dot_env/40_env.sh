# For git signing etc.
export GPG_TTY=$(tty)

export EDITOR="vim"

export BAT_THEME="Dracula"

# Set the default kube context if present
DEFAULT_KUBE_CONTEXTS="$HOME/.kube/config"
if test -f "${DEFAULT_KUBE_CONTEXTS}"; then
  export KUBECONFIG="$DEFAULT_KUBE_CONTEXTS"
fi

# Additional contexts should be in ~/.kube/custom-contexts/
CUSTOM_KUBE_CONTEXTS="$HOME/.kube/custom-contexts"
[[ -d "${CUSTOM_KUBE_CONTEXTS}" ]] || mkdir -p "${CUSTOM_KUBE_CONTEXTS}"

for contextFile in "${CUSTOM_KUBE_CONTEXTS}"/*.yml(N); do
    export KUBECONFIG="$contextFile:$KUBECONFIG"
done

# Go - use default GOPATH instead of spawning subprocess
if command -v go > /dev/null; then
    export GOPATH="${GOPATH:-$HOME/go}"
fi

# diff-so-fancy: gitconfig is managed by chezmoi/gitconfig directly
# No need to run `git config --global` on every shell startup
