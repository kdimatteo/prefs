#
# Aliases
# ---------------------------------------------------------

#launch sublime and load this directory
alias subl="/Applications/Sublime\ Text\ 2.app/Contents/SharedSupport/bin/subl"

alias q="subl -n -a ."

#serve this directory on port 8080
alias serve_this="python -m SimpleHTTPServer"

#what is my IP address
alias myip="ifconfig | grep 'inet' | grep -v '127.0.0.1' | cut -d\   -f2"

#load packages
alias nom="npm install && bower install"
alias nombom="npm cache clear && bower cache clean && rm -rf node_modules bower_components && npm install && bower install"

# Lap warmer
alias warm='nice -n 20 ruby -e "loop {}" &'

# general shortcuts
alias :='cd ..'
alias ::='cd ../..'
alias :::='cd ../../..'

# listing files - I usually end up using 'l' since its quick and easy
alias l='ls -alhG'
alias lt='l -t | less'

#copy the working directory into the clipboard
alias cwd='pwd | pbcopy'

#apache shortcuts
alias restart_apache="sudo /usr/sbin/apachectl restart"


# The essential git commands.
alias gs='git status' #I use this obsessively, I feel blind without it
alias g='git'
alias gb='git checkout -b'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gd='git diff | $EDITOR'
alias ga='git add'
alias gl='git log'

# history options
export HISTCONTROL=erasedups # don't store duplicate lines
export HISTSIZE=100000 #remember 100k unique lines

# append to the history file, don't overwrite it
shopt -s histappend
  
#automatically fixes your 'cd folder' spelling mistakes
shopt -s cdspell


#
# Functions
# ---------------------------------------------------------

# All-in-one git ad/commit/push
function git-commit() {
        git add .
        git commit -m $1
        git push origin -u master
}

# thanks Ben Altman
function prompt_git() {
  local BRANCH=$(git branch 2>/dev/null | awk '/^\*/ { print($2) }')
  local STATUS=$(git status 2>/dev/null | awk 'BEGIN {r=""} /^# Changes to be committed:$/ {r=r "*"}\
    /^# Changed but not updated:$/ {r=r "C"} /^# Untracked files:$/ {r=r "U"} END {print(r)}')

  local OUT=$BRANCH
  if [ "$STATUS" ]; then
    OUT=$OUT$3:$2$STATUS
  fi
  if [ "$OUT" ]; then
    OUT=$4[$2$OUT$4]$1
  fi

  echo $OUT
}

function prompt_svn() {
  svn info . 2>/dev/null | awk "/Revision:/ {r=\$2} /Last Changed Rev:/ {c=\$4; printf(\"$4[$2%d$3:$2%d$4]$1\",c,r)}"
}

function prompt_init() {
  # ANSI CODES (SEPARATE MULTIPLE VALUES WITH ;)
  #
  # 0   reset
  # 1   bold
  # 4   underline
  # 7   inverse
  #
  # FG  BG  COLOR
  # 30  40  black
  # 31  41  red
  # 32  42  green
  # 33  43  yellow
  # 34  44  blue
  # 35  45  magenta
  # 36  46  cyan
  # 37  47  white

  local TEXT_COLOR
  local SIGIL_COLOR
  local BRACKET_COLOR

  if [ "$SSH_TTY" ]; then             # connected via ssh
    TEXT_COLOR='32'
    SIGIL_COLOR='37'
  elif [ "$USER" == "root" ]; then    # logged in as root
    TEXT_COLOR='31'
    SIGIL_COLOR='37'
  else                                # connected locally
    TEXT_COLOR='36'
    SIGIL_COLOR='37'
  fi

  BRACKET_COLOR=$SIGIL_COLOR

  local C1='\[\e[0m\]'
  local C2='\[\e[0;'$TEXT_COLOR'm\]'
  local C3='\[\e[0;'$SIGIL_COLOR'm\]'
  local C4='\[\e[0;'$BRACKET_COLOR'm\]'

export PS1="\n\
\$(prompt_svn '$C1' '$C2' '$C3' '$C4')\
\$(prompt_git '$C1' '$C2' '$C3' '$C4')\
$C4[$C2\u$C3@$C2\h$C3:$C2\w$C4]$C1\n\
$C4[$C2\$(date +%H)$C3:$C2\$(date +%M)$C3:$C2\$(date +%S)$C4]$C1\
 \\$ "
}
prompt_init
