# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
if ps -p$$ -ocmd= | grep "zsh"; then
    [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
fi
