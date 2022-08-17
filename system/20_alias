if command -v exa > /dev/null; then
    alias ls='exa'
    alias l='ls --long --icons --group'
else
    alias l='ls -l'
fi
alias ll='l -a'
alias mux="tmuxinator"

case "$(uname -s)" in
	Linux*)
		alias copy2clipboard="xclip -selection c"
		;;
	Darwin*)
		alias copy2clipboard="pbcopy"
		;;
	*)
	;;
esac

if command -v kitty > /dev/null; then
    alias icat='kitty +kitten icat'
fi

if command -v bat > /dev/null; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

alias ssh='TERM=xterm-256color; ssh'

if command -v lazygit > /dev/null; then
    alias gg="lazygit"
fi

if command -v kcat > /dev/null; then
    alias kafkacat="kcat"
fi
