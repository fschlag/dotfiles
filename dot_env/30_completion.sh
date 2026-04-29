# Determine shell type once
_SHELL_NAME="${ZSH_VERSION:+zsh}"
_SHELL_NAME="${_SHELL_NAME:-bash}"

# FZF
if command -v fzf > /dev/null; then
    if [[ -n "$ZSH_VERSION" ]] && fzf --zsh &>/dev/null; then
        # fzf 0.48+ has built-in zsh integration
        source <(fzf --zsh)
    elif [[ -n "$BASH_VERSION" ]] && fzf --bash &>/dev/null; then
        # fzf 0.48+ has built-in bash integration
        eval "$(fzf --bash)"
    elif [ -d "/opt/homebrew/Cellar/fzf" ]; then
        # Fallback: source from homebrew without version detection
        if [[ -n "$ZSH_VERSION" ]]; then
            _fzf_dirs=(/opt/homebrew/Cellar/fzf/*/shell(N[1]))
            if [[ -n "$_fzf_dirs" ]]; then
                [[ -f "${_fzf_dirs}/completion.zsh" ]] && source "${_fzf_dirs}/completion.zsh"
                [[ -f "${_fzf_dirs}/key-bindings.zsh" ]] && source "${_fzf_dirs}/key-bindings.zsh"
            fi
            unset _fzf_dirs
        fi
    fi
fi

# Cached completions - regenerates only when binary changes
_cache_completion() {
    local cmd=$1 subcmd=${2:-completion} shell_name=${3:-$_SHELL_NAME}
    local cache_dir="${HOME}/.zsh_completion_cache"
    local cache_file="${cache_dir}/_${cmd}_${shell_name}"
    local cmd_path
    cmd_path=$(command -v "$cmd" 2>/dev/null) || return 1

    if [[ ! -f "$cache_file" || "$cmd_path" -nt "$cache_file" ]]; then
        mkdir -p "$cache_dir"
        "$cmd" "$subcmd" "$shell_name" > "$cache_file" 2>/dev/null || return 1
    fi
    source "$cache_file"
}

# Angular - lazy-load (ng is slow)
if [[ -n "$ZSH_VERSION" ]] && command -v ng > /dev/null; then
    _lazy_ng_completion() {
        unset -f _lazy_ng_completion
        source <(ng completion script)
    }
    compdef '_lazy_ng_completion && _ng_completion' ng 2>/dev/null
fi

COMPLETION_SCRIPTS=( kubectl oc k9s helm datree argocd podman flux yq gcx )

for SCRIPT in "${COMPLETION_SCRIPTS[@]}"; do
    _cache_completion "${SCRIPT}"
done
unset SCRIPT _SHELL_NAME
