# Status and Branch Management
alias gst = git status
alias gba = git branch --all
alias gbD = git branch --delete --force
alias gbr = git branch --remote # Show remote branches
alias gbnm = git branch --no-merged # Show branches not yet merged
alias gcb = git checkout -b # Create a new branch and switch to it
alias gbm = git branch --move # Rename the current branch

# Checkout
alias gco = git checkout
alias gcor = git checkout --recurse-submodules # Checkout with submodules

# Diff
alias gdca = git diff --cached
alias gd = git diff # Show differences in working directory
alias gds = git diff --staged # Show differences in staged files
alias gdw = git diff --word-diff # Show diff with word-by-word changes

# Fetch and Pull
alias gf = git fetch # Fetch latest changes
alias gfa = git fetch --all --prune --jobs=10
def ggpull [] { git pull origin (git rev-parse --abbrev-ref HEAD) }

# Push
def ggpush [ --force] {
  mut cmd = [git push origin (git rev-parse --abbrev-ref HEAD)]
  if $force {
    $cmd = $cmd ++ [--force]
  }
  run-external ...($cmd)
  ""
}
def gpsup [] { git push --set-upstream origin (git rev-parse --abbrev-ref HEAD) } # Push current branch and set upstream
def gpoat [] { git push origin --all; git push origin --tags } # Push all branches and tags

# Logging
alias glola = git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset" --all
alias glol = git log --graph --pretty="%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset"
alias glg = git log --stat # Show log with file change statistics
alias glgg = git log --graph # Show log graph
alias glgp = git log --stat --patch # Show log with detailed patch info
alias glod = git log --graph --oneline --decorate # Show concise, decorated log graph

# Work In Progress (WIP)
def gwip [ --amend] {
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
  ""
}

# Additional Useful Aliases
alias ga = git add
alias gaa = git add --all
alias gsta = git stash push # Stash changes
alias gstaa = git stash apply # Apply last stash without removing it
alias gstl = git stash list # List stashes
alias gstp = git stash pop # Apply last stash and remove it
alias gstc = git stash clear # Clear all stashes
alias gcl = git clone --recurse-submodules # Clone a repository with submodules
alias gclean = git clean -fd # Remove untracked files
alias gcm = git checkout main # Checkout main branch
alias gcs = git commit --signoff # Sign off the commit
alias gcp = git cherry-pick # Cherry-pick a specific commit
alias gundo = git reset --soft HEAD~1 # Undo the last commit
alias grb = git rebase # Start a rebase
alias grhh = git reset --hard HEAD # Hard reset to the current HEAD
alias grbi = git rebase --interactive # Start an interactive rebase

def gu [] {
  # Helper function to find top-level git repositories
  def find_top_level_git_repos [] {
    let all_repos = glob **/.git 
      | each { path dirname } 
      | sort
      | uniq
    
    mut top_level = []
    for repo in $all_repos {
      let is_nested = $top_level | any {|parent| 
        ($repo | str starts-with $"($parent)/")
      }
      if not $is_nested {
        $top_level = $top_level ++ [$repo]
      }
    }
    $top_level
  }
  
  # Helper function to check if directory is a git repo
  def is_git_repo [] {
    (git rev-parse --git-dir | complete).exit_code == 0
  }
  
  # Helper function to handle uncommitted changes
  def handle_uncommitted_changes [] {
    let status = git status --porcelain
    if ($status | str trim) == "" {
      return false
    }
    
    print "  Stashing uncommitted changes..."
    let stash_result = git stash push -m "gu script auto-stash"
    not ($stash_result | str contains "No local changes to save")
  }
  
  # Helper function to restore stashed changes
  def restore_stashed_changes [] {
    print "  Restoring stashed changes..."
    git stash pop
  }
  
  # Helper function to get current branch
  def get_current_branch [] {
    git rev-parse --abbrev-ref HEAD
  }
  
  # Helper function to get default branch
  def get_default_branch [] {
    # Try to get the default branch from remote
    let remote_default = git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null
      | complete
      | get stdout
      | str replace "refs/remotes/origin/" ""
      | str trim
    
    if $remote_default != "" {
      return $remote_default
    }
    
    # Fallback to common default branch names
    let common_defaults = ["main", "master", "develop"]
    for branch in $common_defaults {
      if (branch_exists_remotely $branch) {
        return $branch
      }
    }
    
    "main"  # Ultimate fallback
  }
  
  # Helper function to check if branch exists remotely
  def branch_exists_remotely [branch: string] {
    git ls-remote --heads origin $branch
      | complete
      | get stdout
      | str trim
      | str length
      | $in > 0
  }
  
  # Helper function to sync a specific branch
  def sync_branch [current: string, default: string] {
    let remote_exists = branch_exists_remotely $current
    
    if $remote_exists {
      print $"  Pulling latest changes for branch '($current)'..."
      if $current == $default {
        git pull --rebase
      } else {
        git pull origin $current --rebase
        # Push current branch to ensure remote is up to date
        git push --set-upstream origin $current
      }
    } else {
      print $"  Branch '($current)' doesn't exist remotely, switching to '($default)'..."
      git switch $default
      git pull --rebase
    }
  }
  
  # Helper function to sync a single repository
  def sync_repository [repo_path: string] {
    print $">> Syncing repository: ($repo_path) <<"
    let original_dir = pwd
    
    try {
      cd $repo_path
      
      # Check if we're in a valid git repository
      if not (is_git_repo) {
        print $"  Warning: ($repo_path) is not a valid git repository"
        cd $original_dir
        print "==============================\n"
        return
      }
      
      # Handle uncommitted changes
      let stash_applied = handle_uncommitted_changes
      
      # Fetch latest changes
      print "  Fetching latest changes..."
      git fetch --all --prune
      
      # Get current branch info
      let current_branch = get_current_branch
      let default_branch = get_default_branch
      
      # Sync based on branch status
      sync_branch $current_branch $default_branch
      
      # Restore stashed changes if any
      if $stash_applied {
        restore_stashed_changes
      }
      
      print $"  ✓ Successfully synced ($repo_path)"
      cd $original_dir
      
    } catch {|error|
      print $"  ✗ Error syncing ($repo_path): ($error.msg)"
      cd $original_dir
    }
    
    print "==============================\n"
  }
  
  # Main logic starts here
  let git_repos = find_top_level_git_repos
  
  if ($git_repos | is-empty) {
    print "No git repositories found."
    return
  }
  
  print $"Found ($git_repos | length) git repositories to sync...\n"
  
  # Process each repository
  for repo in $git_repos {
    sync_repository $repo
  }
  
  print "All repositories synced!"
}
