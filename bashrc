set -o notify

shopt -s cdspell
shopt -s checkhash
shopt -s checkwinsize
shopt -s cmdhist
shopt -s extglob
shopt -s histappend histreedit histverify
shopt -s no_empty_cmd_completion

export HISTTIMEFORMAT="%H:%M > "
export HISTIGNORE="&:bg:fg"
export HISTCONTROL=ignoredups
export PS1="\u@\h:\W\$ "

export PAGER=`which less`
export LESSCHARSET='latin1'

alias ls="ls --color"
alias la="ls -a"
alias ll="ls -lh"
alias lla="ls -lha"
alias quit="exit"
