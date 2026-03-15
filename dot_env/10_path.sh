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

# Lazy-load SDKMAN - defers ~200-400ms to first use
export SDKMAN_DIR="$HOME/.sdkman"
if [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]]; then
    _lazy_load_sdkman() {
        unset -f sdk java javac gradle mvn kotlin kotlinc groovy groovyc _lazy_load_sdkman
        source "$HOME/.sdkman/bin/sdkman-init.sh"
    }
    sdk()     { _lazy_load_sdkman && sdk "$@"; }
    java()    { _lazy_load_sdkman && java "$@"; }
    javac()   { _lazy_load_sdkman && javac "$@"; }
    gradle()  { _lazy_load_sdkman && gradle "$@"; }
    mvn()     { _lazy_load_sdkman && mvn "$@"; }
    kotlin()  { _lazy_load_sdkman && kotlin "$@"; }
    kotlinc() { _lazy_load_sdkman && kotlinc "$@"; }
    groovy()  { _lazy_load_sdkman && groovy "$@"; }
    groovyc() { _lazy_load_sdkman && groovyc "$@"; }
fi

# Lazy-load NVM - defers ~300-800ms to first use
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
    _lazy_load_nvm() {
        unset -f nvm node npm npx _lazy_load_nvm
        \. "$NVM_DIR/nvm.sh"
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    }
    nvm()  { _lazy_load_nvm && nvm "$@"; }
    node() { _lazy_load_nvm && node "$@"; }
    npm()  { _lazy_load_nvm && npm "$@"; }
    npx()  { _lazy_load_nvm && npx "$@"; }
fi

