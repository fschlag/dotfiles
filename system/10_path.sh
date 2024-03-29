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

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
  export PATH=/opt/homebrew/opt/ruby/bin:$PATH
  export PATH=`gem environment gemdir`/bin:$PATH
fi
