# Machine-unspecific settings

setclobber() { setopt clobber }
setnoclobber() { setopt noclobber }

setopt interactivecomments
setnoclobber
# Unset option to change dir if command doesn't exist, but dir of the same name does exist
# Unsetting b/c this can cause problems with console_scripts entry points in python setup.py
unsetopt AUTO_CD

export RCFILE="$HOME/.zshrc"
alias rcload="source $RCFILE"
alias rc=rcload
alias rcedit="vim $RCFILE && source $RCFILE"

# Some pip installs require a C compiler to be aliased to "CC"
export CC=gcc

alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ll='ls -FGlAhp'                       # Preferred 'ls' implementation
alias less='less -FSRXc'                    # Preferred 'less' implementation
cdls() { builtin cd "$@"; ll; }             # List directory contents upon 'cd'
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias .3='cd ../../../'                     # Go back 3 directory levels
alias .4='cd ../../../../'                  # Go back 4 directory levels
alias .5='cd ../../../../../'               # Go back 5 directory levels
alias .6='cd ../../../../../../'            # Go back 6 directory levels
alias ~="cd ~"                              # ~:            Go Home
alias path='echo -e ${PATH//:/\\n}'
pwdtail() { echo ${PWD##*/} }
epoch() { date +%s; }
alias cdev="cd $DEVPATH"

#   extract:  Extract most known archives with one command
#   ---------------------------------------------------------
extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)     echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

alias qfind="find . -name "                 # qfind:    Quickly search for file
ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory
ffs () { /usr/bin/find . -name "$@"'*' ; }  # ffs:      Find file whose name starts with a given string
ffe () { /usr/bin/find . -name '*'"$@" ; }  # ffe:      Find file whose name ends with a given string

alias urldecode='python -c "import sys; import urllib.parse; print(urllib.parse.unquote(sys.argv[1]))"'
alias linebreaktobackslashn='awk ''{printf "%s\\n", $0}'''
alias uuidgensimple='uuidgen | tr "[:upper:]" "[:lower:]" | sed ''s/\-//g'''
alias utcnow='python -c "import datetime; print(datetime.datetime.now(tz=datetime.timezone.utc).isoformat())"'

### git
export PREFERRED_REMOTE_CONFIG='preferred.remote'
export GIT_DEFAULT_MAIN_BRANCH="master"
alias gs="git status"
alias gss="git status -s"
alias ga='git add'
alias gaa="git add --all"
alias gb='git branch'
alias gcurbranch='git rev-parse --abbrev-ref HEAD'
gbranchremote() { 
  local branch=''
  if [ ! -z $1 ]; then
    branch="$1"
  else
    branch=$(gcurbranch)
  fi
  git config "branch.$branch.remote" 
}
alias gch='git checkout'
alias gch-='git checkout -'
alias g-=gch-
alias gcp='git cherry-pick'
gcustomconfiginit() {
  local section=$(cat .git/config | grep "[custom]")
  if [ -z $section ]; then
    echo "[custom]" >> .git/config
  fi
}
gmainbranch() {
  gcustomconfiginit
  local mainbranch=$(git config --local --get custom.mainbranch)
  if [ -z $mainbranch ]; then
    echo $GIT_DEFAULT_MAIN_BRANCH
  else
    echo $mainbranch
  fi
}
alias gsetmainbranch="git config --local --add custom.mainbranch"
gchmaster() {
  local mainbranch=$(gmainbranch)
  git checkout $mainbranch && git pull
}
alias gchmain=gchmaster
alias master=gchmaster
gchfile() {
  local filebranch=''
  local filepath=''
  if (( $# < 2 )); then
    local mainbranch=$(gmainbranch)
    local remote=$(gbranchremote)
    filebranch="$remote/$mainbranch"
	  filepath="$1"
  else
  	filebranch="$1"
	  filepath="$2"
  fi
  git checkout "$filebranch" "$filepath"
}
alias gpll='git pull'
alias gpull=gpll
alias gfetch='git fetch'
alias gunstageall='git reset'
gcmt() {;git commit -am "$(echo $@)";}
alias glastcmtmessage='git log -n 1 --format=format:%s'
grecmt() {
  if [ ! -z "$1" ]; then
  	cmtmessage="$@"
  else
  	cmtmessage=$(glastcmtmessage)
  fi
  git reset --soft HEAD~1 && gaa && gcmt "$cmtmessage"
}
alias gcmtundo='git reset --soft HEAD~'
alias grecmtpsh='grecmt && gpsh -f'
alias gpshunsafe='git push'
gpsh() {
  local mainbranch=$(gmainbranch)
  [[ $(gcurbranch) == $mainbranch ]] && echo "Currently on $mainbranch. Use 'gpshunsafe' if you want to push anyway." || git push $@
}

gbranchremotewithname() {
  if [ -z $1 ]; then
    echo "Need to provide a branch name to determine the remote"
    return 1
  fi
  ### git branch -vv example output (space btwn branch name and 10-char hash is a tab)
  ###   with remote: "  mybranch 10a997fced [origin/mybranch] Commit msg"
  ###   without remote: "* mybranch 89207183cb Commit msg"
  git branch -vv | grep -E "^\*?\s+$1\s+" | perl -nle '/^\*?\s+([^\s]+)[\s\w]+\[([^\s]+)\]/; print "$2" if $2;'
}
gbranchremote() { 
  local remotewithname=$(gbranchremotewithname $1)
  if [ ! -z "$remotewithname" ]; then
    echo $remotewithname | cut -d/ -f1
  else
    echo ""
  fi
}
gmasterremote() {
  git config "branch.$(gmainbranch).remote"
}
gcurbranchremotewithname() {
  git for-each-ref --format='%(upstream:short)' $(git symbolic-ref -q HEAD)
  ### ALTERNATE ###
  ### git status -sb --> "## mybranch...origin/mybranch" if upstream exists
  ### git status -sb --> "## mybranch" if upstream does not exist
  # git status -sb | perl -nle '/\.{3}(.*)$/; print "$1";'
}
gcurbranchremote() {
  local remotewithname=$(gcurbranchremotewithname)
  if [ ! -z "$remotewithname" ]; then
    echo $remotewithname | cut -d/ -f1
  else
    echo ""
  fi
}
gpshu() {
  local curbranchremote=$(gcurbranchremote)
  if [ -z "$curbranchremote" ]; then
    local remote=""
    if [ -z "$1" ]; then
      local preferredremote=$(git config "$PREFERRED_REMOTE_CONFIG")
      if [ ! -z "$preferredremote" ]; then
        remote=$preferredremote
        echo "Using preferred remote set in .git/config: '$remote'"
      else
        remote=$(gmasterremote)
        if [ -z "$remote" ]; then
          echo "No remote provided, and no remote set for master"
          return 1
        fi
        echo "Using master branch remote: '$remote'"
      fi
    else
      remote=$1
    fi
    git push --set-upstream "$remote" "$(gcurbranch)"
  else
    gpsh
  fi
}
alias gdiff='git diff'
gdiffnames() {
  local mainbranch=$(gmainbranch)
  local branchcomparedto=${1:-$mainbranch}
  git diff --name-only $branchcomparedto..$(gcurbranch)
}
alias gdiffhead='git diff HEAD'
gdiffn() {
  single_digit_match=$(echo "$1" | grep -Eo '^\d$')
  if [ ! -z "$single_digit_match" ]; then
    git diff "HEAD~$1"
  else
    echo "Need to provide a number indicating the number of commits from HEAD you want to diff"
  fi
}
alias gdiff1='gdiffn 1'
gdiffmaster() {
  local mainbranch=$(gmainbranch)
  git diff origin/$mainbranch.."$(gcurbranch)" $@
}
alias gdiffmain=gdiffmaster
gdiffbranches() {
  if (( $# < 1 )); then
    echo "Need one or two branches as params"
    return
  elif (( $# < 2 )); then
    branch1="$1"; shift
    branch2=$(gcurbranch)
  else
    branch1="$1"; shift
    branch2="$1"; shift
  fi
  git diff "$branch1".."$branch2" $@
}
gdiffbranchfile () {
  local mainbranch=$(gmainbranch)
  if [ ! -z "$2" ]; then
    branch="$1"; shift
  else
    branch=$mainbranch
  fi
  git diff "$branch" "$1"
}
alias gdif=gdiff
alias glog='git log'
gnbcur() {
  if [ ! -z "$1" ]; then
    git checkout -b $1
  else
    echo "Specify branch name"
  fi
}
alias gresall='git checkout .'
alias gresfile='git checkout --'
alias greshard='git reset --hard'
### git reset HEAD $1 && git checkout -- $1
alias gres=gresfile
gresremote() {
  git fetch && git reset --hard $(gcurbranchremotewithname)
}
gstash() {
  if [ -z "$1" ]; then
    git stash
  else
    git stash save "$@"
  fi
}
alias gstashp='git stash pop'
alias gstashshow='git stash show'
gstashdiff() {
  local stashindex="0"
  if [ ! -z "$1" ]; then
    stashindex="$1"
  fi
  git stash show -p stash@\{$stashindex\}
}
gbranchfile () {
  local mainbranch=$(gmainbranch)
  if [ ! -z "$2" ]; then
    branch="$1"; shift
  else
    branch=$mainbranch
  fi
  if [ -z "$1" ]; then
    echo "Need to specify file path"
  else
    file="$1"
  fi
  git show "$branch:$file"
}
gchkeepfile() {
  if (( $# < 2 )); then
    echo "Need 'ours/theirs' and file as params"; return
  else
    use="--$1"
	echo "Using '$1' for $2 (branch: $(gcurbranch))"
  fi
  git checkout "$use" "$2"
}
gchours() {
  if [ -z "$1" ]; then
    echo "Need file as param"; return
  fi
  gchkeepfile "ours" "$1"
}
gchtheirs() {
  if [ -z "$1" ]; then
    echo "Need file as param"; return
  fi
  gchkeepfile "theirs" "$1"
}
gbranchdelete() {
  if [ -z "$1" ]; then
    echo "Need branch name as param"; return
  elif [[ "$1" == "$(gcurbranch)" ]]; then
    echo "Please check out a different branch before deleting this one"; return
  fi
  local message="Are you sure that you want to delete this branch ($1)?"
  local branchremote=$(gbranchremotewithname $1)
  if [ ! -z $branchremote ]; then
    message="$message\n* THIS WILL ALSO DELETE THE REMOTE BRANCH THAT THIS LOCAL BRANCH IS TRACKING *"
  fi
  echo -e "$message"
  read -q "REPLY?Enter [yY] to confirm: "
  echo
  case "$REPLY" in
    y|Y ) echo "Deleting branch...";;
    * ) echo "NOT DELETING" && return;;
  esac
  git branch -D $1
  if [ ! -z $branchremote ]; then
    git push origin ":$1"
  fi
}
gbranchrename() {
  local branchfrom
  local branchto
  local mainbranch=$(gmainbranch)
  if (( $# < 1 )); then
    echo "Need one or two branches as params"
    return
  elif (( $# < 2 )); then
    branchfrom=$(gcurbranch)
    branchto="$1"; shift
  else
    branchfrom="$1"; shift
    branchto="$1"; shift
  fi
  if [[ "$branchfrom" == $mainbranch ]]; then
    echo "Attempting to rename the $mainbranch branch. You probably don't want that. Exiting..."
    return
  fi
  local branchremote=$(gbranchremote $branchfrom)
  echo "Renaming branch $branchfrom to $branchto..."
  git branch -m $branchfrom $branchto
  if [ ! -z $branchremote ]; then
    echo "Also renaming the remote branch (remote = $branchremote)..."
    git push $branchremote :$branchfrom
    git push --set-upstream $branchremote $branchto
  fi
}

### pip
pipreq() {
  if [ -z "$1" ] ; then
    reqfile="requirements.txt"
  else
    reqfile="$1"
  fi
  pip install -r "$reqfile"
}

### virtualenv
venv() {
  cwd=$(pwdtail)
  if [ -d "$WORKON_HOME/$cwd" ]; then
    workon "$cwd"
  else
    echo "'$cwd' is not an existing virtualenv"
  fi
}
alias venvoff='deactivate'
venvcreate() {
  cwd=$(echo "${PWD##*/}")
  if [ -d "$WORKON_HOME/$cwd" ]; then
    echo "'$cwd' virtualenv already exists"
  else
    mkvirtualenv "$cwd" $@
    workon "$cwd"
  fi
}
venvdelete() {
  venvoff
  cwd=$(echo "${PWD##*/}")
  if [ -d "$WORKON_HOME/$cwd" ]; then
    rm -rf "$WORKON_HOME/$cwd"
  fi
}
venvcurrent() {
  echo "$VIRTUAL_ENV"
}

### pyenv-virtualenv
pvenv() { pyenv activate $(pwdtail) }
pvenvoff() { pyenv deactivate $(pwdtail) }
pvenvcreate() {
  pyenv virtualenv $1 $(pwdtail) && pvenv
}
pvenvdelete() { 
  pyenv uninstall $(pwdtail) 
}

### Random util commands
encodeforurl() {
  if [ $# -eq 2 ]; then
    python -c "import urllib.parse, sys; print(urllib.parse.urlencode({sys.argv[1]: sys.argv[2]}))" $1 $2
  elif [ $# -eq 1 ]; then
    python -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" $1
  else
    echo "Need 1 or 2 params"
    return
  fi
}
echohighlight() {
  echo -e "\033[1;92m$@\e[0m"
}
alias coercedoublequote="sed $'s/\'/\\\"/g'"
alias djangokey='python -c "import secrets; print(secrets.token_urlsafe())"'

# Machine-specific stuff
if [[ -s "$DEVPATH/dotfiles/.rcsettings" ]]; then
  source "$DEVPATH/dotfiles/.rcsettings"
  if [[ ! -z "$MYZSHRC" ]]; then
    source "$MYZSHRC"
  fi
fi
alias rcmachineedit="vim $MYZSHRC && source $MYZSHRC"
