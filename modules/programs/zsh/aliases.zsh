# Networking
alias myip='curl https://ipecho.net/plain; echo'

# Git Utility
alias gu='find . -name .git -exec sh -c '\''pushd "$(dirname "{}")" >/dev/null && gfa && git pull origin "$(git rev-parse --abbrev-ref HEAD)" && popd >/dev/null'\'' \;'

# Nix Shell
alias nix-shell-unstable='nix-shell -I nixpkgs=channel:nixpkgs-unstable'

# File System Utilities
alias ls='lsd'
alias lg='lazygit'

# Kubernetes Shortcuts
alias k='kubectl'
alias kx='kubectx'

# Directory Tree Viewing
alias tree='lsd --tree'
alias stree='tree --depth 2'

# ULID Generation and Copy
alias ulid='curl -s -X GET https://ulid.truestamp.com | jq -jr \''.[0].ulid'\'' | pbcopy'

# Status and Branch Management
alias gst='git status'
alias gba='git branch --all'
alias gbD='git branch --delete --force'
alias gbr='git branch --remote'
alias gbnm='git branch --no-merged'
alias gcb='git checkout -b'
alias gbm='git branch --move'

# Checkout
alias gco='git checkout'
alias gcor='git checkout --recurse-submodules'

# Diff
alias gdca='git diff --cached'
alias gd='git diff'
alias gds='git diff --staged'
alias gdw='git diff --word-diff'

# Fetch and Pull
alias gf='git fetch'
alias gfa='git fetch --all --prune --jobs=10'
alias ggpull='git pull origin $(git rev-parse --abbrev-ref HEAD)'

# Push
alias ggpush='git push origin $(git rev-parse --abbrev-ref HEAD)'
alias gpsup='git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)'
alias gpoat='git push origin --all && git push origin --tags'

# Logging
alias glola='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'\'' --all'
alias glol='git log --graph --pretty='\''%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'\'''
alias glg='git log --stat'
alias glgg='git log --graph'
alias glgp='git log --stat --patch'
alias glod='git log --graph --oneline --decorate'

# WIP Alias
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'

# Additional Useful Aliases
alias ga='git add'
alias gaa='git add --all'
alias gsta='git stash push'
alias gstaa='git stash apply'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gstc='git stash clear'
alias gcl='git clone --recurse-submodules'
alias gclean='git clean -fd'
alias gcm='git commit -m'
alias gcm!='git commit -m --no-verify'
alias gcs='git commit --signoff'
alias gcp='git cherry-pick'
alias gundo='git reset --soft HEAD~1'
alias grb='git rebase'
alias grhh='git reset --hard HEAD'
alias grbi='git rebase --interactive'
