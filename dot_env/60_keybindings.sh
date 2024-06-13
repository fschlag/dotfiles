# kitty option-key + arrows
if [[ $TERM = "xterm-kitty" ]]
then
    bindkey "\e[1;3D" backward-word # ⌥←
    bindkey "\e[1;3C" forward-word # ⌥→
fi
