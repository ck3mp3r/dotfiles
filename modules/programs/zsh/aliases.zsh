# Networking
alias myip="curl https://ipecho.net/plain; echo"

# Git Utility
gu() {
    for gitdir in $(find . -name .git); do
        pushd "$(dirname "$gitdir")" || continue
        gfa
        git pull origin "$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
        popd || continue
    done
}

# Nix Shell
alias nix-shell-unstable="nix-shell -I nixpkgs=channel:nixpkgs-unstable"

# File System Utilities
alias ls="lsd"
alias lg="lazygit"

# Kubernetes Shortcuts
alias k="kubectl"
alias kx="kubectx"

# Directory Tree Viewing
alias tree="lsd --tree"
alias stree="tree --depth 2"

# ULID Generation and Copy
alias ulid="curl -s -X GET https://ulid.truestamp.com | jq -jr '.[0].ulid' | pbcopy"

# Status and Branch Management
alias gst="git status"
alias gba="git branch --all"
alias gbD="git branch --delete --force"
alias gbr="git branch --remote"           # Show remote branches
alias gbnm="git branch --no-merged"       # Show branches not yet merged
alias gcb="git checkout -b"               # Create a new branch and switch to it
alias gbm="git branch --move"             # Rename the current branch

# Checkout
alias gco="git checkout"
alias gcor="git checkout --recurse-submodules"  # Checkout with submodules

# Diff
alias gdca="git diff --cached"
alias gd="git diff"                       # Show differences in working directory
alias gds="git diff --staged"             # Show differences in staged files
alias gdw="git diff --word-diff"          # Show diff with word-by-word changes

# Fetch and Pull
alias gf="git fetch"                      # Fetch latest changes
alias gfa="git fetch --all --prune --jobs=10"
alias ggpull="git pull origin $(git rev-parse --abbrev-ref HEAD)"

# Push
alias ggpush="git push origin $(git rev-parse --abbrev-ref HEAD)"
alias gpsup="git push --set-upstream origin $(git rev-parse --abbrev-ref HEAD)"
alias gpoat="git push origin --all && git push origin --tags"  # Push all branches and tags

# Logging
alias glola="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --all"
alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'"
alias glg="git log --stat"                    # Show log with file change statistics
alias glgg="git log --graph"                  # Show log graph
alias glgp="git log --stat --patch"           # Show log with detailed patch info
alias glod="git log --graph --oneline --decorate"  # Show concise, decorated log graph

# Work In Progress (WIP)
gwip() {
    git add -A
    deleted_files=$(git ls-files --deleted)
    [[ -n "$deleted_files" ]] && git rm $deleted_files
    git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"
}

# Additional Useful Aliases
alias ga="git add"
alias gaa="git add --all"
alias gsta="git stash push"                  # Stash changes
alias gstaa="git stash apply"                # Apply last stash without removing it
alias gstl="git stash list"                  # List stashes
alias gstp="git stash pop"                   # Apply last stash and remove it
alias gstc="git stash clear"                 # Clear all stashes
alias gcl="git clone --recurse-submodules"   # Clone a repository with submodules
alias gclean="git clean -fd"                 # Remove untracked files
alias gcm="git commit -m"                    # Commit with message
alias gcm!="git commit -m --no-verify"       # Commit with message and skip hooks
alias gcs="git commit --signoff"             # Sign off the commit
alias gcp="git cherry-pick"                  # Cherry-pick a specific commit
alias gundo="git reset --soft HEAD~1"        # Undo the last commit
alias grb="git rebase"                       # Start a rebase
alias grhh="git reset --hard HEAD"           # Hard reset to the current HEAD
alias grbi="git rebase --interactive"        # Start an interactive rebase
