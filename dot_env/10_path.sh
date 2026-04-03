# Gradle wrapper
export PATH=$PATH:$HOME/.gradle/wrapper/util

# $HOME/bin
export PATH=$PATH:$HOME/bin

# $HOME/.local/bin
export PATH=$PATH:$HOME/.local/bin

# Add gnubin (mac homebrew) to PATH
if [ -d "/usr/local/opt/grep/libexec/gnubin" ]; then
    export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"
fi

if [ -d "/opt/homebrew/bin" ]; then
    export PATH="/opt/homebrew/bin:$PATH"
fi
# need to be one of the last files to read

# SDKMAN - add current candidate bins to PATH and set HOME vars, lazy-load only `sdk`
export SDKMAN_DIR="$HOME/.sdkman"
if [[ -d "$SDKMAN_DIR/candidates" ]]; then
    for _sdk_candidate in "$SDKMAN_DIR/candidates/"*/current(N); do
        [[ -d "$_sdk_candidate/bin" ]] && PATH="$_sdk_candidate/bin:$PATH"
        # Export JAVA_HOME, GROOVY_HOME, etc.
        _sdk_name="${_sdk_candidate%/current}"
        _sdk_name="${_sdk_name##*/}"
        export "${_sdk_name:u}_HOME=$_sdk_candidate"
    done
    unset _sdk_candidate _sdk_name
    export SDKMAN_CANDIDATES_DIR="$SDKMAN_DIR/candidates"

    if [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]]; then
        sdk() {
            unset -f sdk
            source "$SDKMAN_DIR/bin/sdkman-init.sh"
            sdk "$@"
        }
    fi
fi

# NVM - add default node to PATH, lazy-load only `nvm`
export NVM_DIR="$HOME/.nvm"
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    # Resolve default version: follow alias chain without subprocesses
    _nvm_ver=""
    [[ -f "$NVM_DIR/alias/default" ]] && _nvm_ver=$(<"$NVM_DIR/alias/default")
    # Resolve lts/* → lts/name → version
    if [[ "$_nvm_ver" == lts/* ]]; then
        _lts_name="${_nvm_ver#lts/}"
        [[ -f "$NVM_DIR/alias/lts/$_lts_name" ]] && _nvm_ver=$(<"$NVM_DIR/alias/lts/$_lts_name")
        # Handle chained lts alias (lts/* → lts/krypton → v24.x)
        if [[ "$_nvm_ver" == lts/* ]]; then
            _lts_name="${_nvm_ver#lts/}"
            [[ -f "$NVM_DIR/alias/lts/$_lts_name" ]] && _nvm_ver=$(<"$NVM_DIR/alias/lts/$_lts_name")
        fi
    fi
    # Find matching installed version dir and prepend to PATH
    if [[ -n "$_nvm_ver" ]]; then
        for _nvm_node_dir in "$NVM_DIR/versions/node/${_nvm_ver}"*(N); do
            if [[ -d "$_nvm_node_dir/bin" ]]; then
                PATH="$_nvm_node_dir/bin:$PATH"
                break
            fi
        done
    fi
    unset _nvm_ver _lts_name _nvm_node_dir

    nvm() {
        unset -f nvm
        \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
        nvm "$@"
    }
fi

