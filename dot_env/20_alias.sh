if command -v lsd > /dev/null; then
    alias ls='lsd'
    alias l='ls --long'
else
    alias l='ls -l'
fi
alias ll='l -a'

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

if command -v bat > /dev/null; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

alias ssh256='TERM=xterm-256color; ssh'

if command -v lazygit > /dev/null; then
    alias gg="lazygit"
fi

if command -v kcat > /dev/null; then
    alias kafkacat="kcat"
fi
