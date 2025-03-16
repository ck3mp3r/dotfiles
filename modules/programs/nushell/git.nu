# Status and Branch Management
alias gst = git status
alias gba = git branch --all
alias gbD = git branch --delete --force
alias gbr = git branch --remote           # Show remote branches
alias gbnm = git branch --no-merged       # Show branches not yet merged
alias gcb = git checkout -b               # Create a new branch and switch to it
alias gbm = git branch --move             # Rename the current branch

# Checkout
alias gco = git checkout
alias gcor = git checkout --recurse-submodules  # Checkout with submodules

# Diff
alias gdca = git diff --cached
alias gd = git diff                       # Show differences in working directory
alias gds = git diff --staged             # Show differences in staged files
alias gdw = git diff --word-diff          # Show diff with word-by-word changes

# Fetch and Pull
alias gf = git fetch                      # Fetch latest changes
alias gfa = git fetch --all --prune --jobs=10
def ggpull [] { git pull origin (git rev-parse --abbrev-ref HEAD) }

# Push
def ggpush [--force] {
  mut cmd = [git push origin (git rev-parse --abbrev-ref HEAD)]
  if $force {
    $cmd = $cmd ++ [--force]
  }
  run-external ...($cmd)
}
def gpsup [] { git push --set-upstream origin (git rev-parse --abbrev-ref HEAD) }  # Push current branch and set upstream
def gpoat [] { git push origin --all ; git push origin --tags }       # Push all branches and tags

# Logging
alias glola = git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all
alias glol = git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"
alias glg = git log --stat                    # Show log with file change statistics
alias glgg = git log --graph                  # Show log graph
alias glgp = git log --stat --patch           # Show log with detailed patch info
alias glod = git log --graph --oneline --decorate  # Show concise, decorated log graph

# Work In Progress (WIP)
def gwip [--amend] {
  git add -A
  let deleted_files = (git ls-files --deleted)
  if $deleted_files != "" {
      git rm $deleted_files
  }
  mut cmd = [git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"]
  if $amend {
    $cmd = $cmd ++ [--amend]
  }
  run-external ...($cmd)
}

# Additional Useful Aliases
alias ga = git add
alias gaa = git add --all
alias gsta = git stash push                  # Stash changes
alias gstaa = git stash apply                # Apply last stash without removing it
alias gstl = git stash list                  # List stashes
alias gstp = git stash pop                   # Apply last stash and remove it
alias gstc = git stash clear                 # Clear all stashes
alias gcl = git clone --recurse-submodules   # Clone a repository with submodules
alias gclean = git clean -fd                 # Remove untracked files
alias gcm = git checkout main                # Checkout main branch
alias gcs = git commit --signoff             # Sign off the commit
alias gcp = git cherry-pick                  # Cherry-pick a specific commit
alias gundo = git reset --soft HEAD~1        # Undo the last commit
alias grb = git rebase                       # Start a rebase
alias grhh = git reset --hard HEAD           # Hard reset to the current HEAD
alias grbi = git rebase --interactive        # Start an interactive rebase

def gu [] {
    glob -F **/.git | each { |gitdir|
        let repo_dir = ($gitdir | path dirname)
        print $">> Starting sync for ($repo_dir) <<"
        cd $repo_dir
        git fetch --all
        git pull --rebase
        git push
        cd -
        print "\n=============================="
    }
}
