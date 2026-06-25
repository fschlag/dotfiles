git_current_branch() {
  local ref
  ref=$(git symbolic-ref --quiet HEAD 2>/dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return
    ref=$(git rev-parse --short HEAD 2>/dev/null) || return
  fi
  echo ${ref#refs/heads/}
}

alias gst='git status'
alias gss='git status -s'
alias ga='git add'
alias gaa='git add --all'
alias gc='git commit -v'
alias gcmsg='git commit -m'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gb='git branch'
alias gd='git diff'
alias gdca='git diff --cached'
alias gp='git push'
alias gpf='git push --force-with-lease --force-if-includes'
alias gl='git pull'
alias gf='git fetch'
alias glog='git log --oneline --decorate --graph'
alias gcl='git clone'
alias grhh='git reset --hard'
alias gsta='git stash'
alias gstp='git stash pop'

alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'
alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'
alias gwipe='git reset --hard && git clean --force -df'

alias gca!='git commit --verbose --all --amend'
alias gcan!='git commit --verbose --all --no-edit --amend'
alias gcans!='git commit --verbose --all --signoff --no-edit --amend'
alias gcann!='git commit --verbose --all --date=now --no-edit --amend'
alias gc!='git commit --verbose --amend'
alias gcn!='git commit --verbose --no-edit --amend'

alias gpr='git pull --rebase'
alias gprv='git pull --rebase -v'
alias gpra='git pull --rebase --autostash'
alias gprav='git pull --rebase --autostash -v'

alias gpsupf='git push --set-upstream origin $(git_current_branch) --force-with-lease --force-if-includes'
alias gpsup='git push --set-upstream origin $(git_current_branch)'

