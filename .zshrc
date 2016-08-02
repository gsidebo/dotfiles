#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

setopt interactivecomments

export RCFILE='~/.zshrc'
alias rcload="source $RCFILE"
alias rc="vim $RCFILE && source $RCFILE"

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
alias edit='charm'                          # edit:         
alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
alias ~="cd ~"                              # ~:            Go Home
alias path='echo -e ${PATH//:/\\n}'

#   extract:  Extract most know archives with one command
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

# git
alias gs="git status"
alias gss="git status -s"
alias ga='git add'
alias gaa="git add --all"
alias gb='git branch'
alias gcurbranch='git rev-parse --abbrev-ref HEAD'
alias gch='git checkout'
alias gch-='git checkout -'
alias g-=gch-
alias gchmaster='git checkout master && git pull'
alias master=gchmaster
alias gpll='git pull'
alias gpull=gpll
gcmt() {;git commit -am "$(echo $@)";}
alias glastcmtmessage='git log -n 1 --format=format:%s'
grecmt() {
  lastcmtmessage=$(glastcmtmessage)
  git reset --soft HEAD~1 && gaa && gcmt "$lastcmtmessage"
}
alias gcmtundo='git reset --soft HEAD~'
alias gpsh='git push'
gpshu() {
  originmatch=$(git status -s --branch | grep "\.\.\.origin" -Eo)
  if [ -z "$originmatch" ]; then
  	git push --set-upstream origin "$(gcurbranch)"
  else
    gpsh
  fi
}
gdiff() {
  if (( $# < 1 )); then
    git diff HEAD
  else
    if (($# == 1)); then
	  single_digit_match=$(echo "$1" | grep -Eo '^\d$')
	  if [ ! -z "$single_digit_match" ]; then
	    git diff "HEAD~$1"
	  else
	    git diff $@
	  fi
	else
	  git diff $@
	fi
  fi
}
gdiffmaster() {
  git diff origin/master.."$(gcurbranch)" $@
}
gdiffbranches() {
  if (( $# < 2 )); then
    echo "Need two branches as params"
    return
  else
    branch1="$1"; shift
    branch2="$1"; shift
  fi
  git diff "$branch1".."$branch2" $@
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
alias gres=gresfile
gresorigin() {
  curbranch=$(gcurbranch)
  git reset --hard "origin/$curbranch"
}
alias gstash='git stash'
alias gstashp='git stash pop'

# pip
pipreq() {
  if [ -z "$1" ] ; then
    reqfile="requirements.txt"
  else
    reqfile="$1"
  fi
  pip install -r "$reqfile"
}

# vagrant
alias vup="vagrant up"
alias vssh="vagrant ssh"
alias vupssh="vagrant up && vagrant ssh"

# Machine-specific stuff
if [[ -s ".zshkeys" ]]; then
  source ".zshkeys"
fi
if [[ -s ".zshrcme" ]]; then
  source ".zshrcme"
fi
