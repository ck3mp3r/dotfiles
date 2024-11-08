# Basic Git Commands
alias g = git
alias gst = git status
alias ga = git add
alias gaa = git add -A
alias gap = git add -p
alias gc = git commit -m
alias gca = git commit --amend
alias gcam = git commit -am
alias gdca = git diff --cached  # Shows differences of staged changes
alias gco = git checkout
alias gcb = git checkout -b
alias gcm = git checkout main

# Git Branch Management
alias gb = git branch
alias gba = git branch -a
alias gbd = git branch -d
alias gbD = git branch -D
alias gbr = git branch --remote
alias gbl = git branch --list
alias gbo = git branch --set-upstream-to=origin/

# Git Merging & Rebasing
alias gm = git merge
alias gma = git merge --abort
alias gmt = git mergetool
alias grb = git rebase
alias grbi = git rebase -i
alias grbc = git rebase --continue
alias grba = git rebase --abort

# Git Pull & Push
alias gp = git push
alias gpf = git push --force
alias gpl = git pull
alias gpo = git push origin
alias gpu = git push -u origin HEAD

# Git Diff
alias gd = git diff
alias gds = git diff --staged
alias gdt = git difftool

# Git Log & History
alias gl = git log --oneline --graph --decorate
alias glp = git log --pretty=format:"%h %ad | %s%d [%an]" --graph --date=short
alias glol = git log --graph --pretty='%C(yellow)%h%C(reset) - %s %C(green)(%cr) %C(bold blue)<%an>%C(reset)' --abbrev-commit
alias glola = git log --graph --pretty='%C(yellow)%h%C(reset) - %s %C(green)(%cr) %C(bold blue)<%an>%C(reset)' --abbrev-commit --all

# Git Remote Management
alias gr = git remote
alias gra = git remote add
alias grv = git remote -v
alias grm = git remote rm
alias grs = git remote show

# Git Stash Management
alias gss = git stash save
alias gsp = git stash pop
alias gsa = git stash apply
alias gsl = git stash list
alias gsr = git stash drop
alias gsts = git stash show -p

# Git Clean-Up & Ignored Files
alias gclean = git clean -fd
alias gignored = git status --ignored

# Branch Tracking and Syncing
alias gbup = git branch --set-upstream-to=origin/$(git rev-parse --abbrev-ref HEAD)
# alias gsync = git fetch origin and git rebase origin/$(git rev-parse --abbrev-ref HEAD)

# Git Reset
alias grs = git reset
alias grsh = git reset --hard
alias grss = git reset --soft

# Additional Helpful Commands
alias gcp = git cherry-pick
alias gt = git tag
alias gtl = git tag -l
alias gtv = git tag -v
alias gpo = git push origin
alias gpom = git push origin main
alias gplom = git pull origin main
alias gwc = git whatchanged -p --abbrev-commit --pretty=medium
