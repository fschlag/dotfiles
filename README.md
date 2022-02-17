# System files

The following need to be added to `.bashrc`, `.zshrc` etc. to load everything in the 'system' folder:

```sh
for DOTFILE in `find ${HOME}/.dotfiles/system | sort`
do
  [ -f "$DOTFILE" ] && source "$DOTFILE"
done
```

# home files

Files that are located in the relative to home (`~`) are symlinked with `linkHome.sh`

# Disclaimer
Use at your own risk. The files were created for **my** setup, feel free to use them, but they might not work as expected on your system.
