# zshrc
# (C) Igor Pozgaj <ipozgaj@gmail.com>

# set paths
path=($path /bin /usr/bin /usr/local/bin $HOME/bin)
manpath=($manpath /usr/local/man /usr/share/man)
cdpath=($cdpath ~)
fpath=($fpath ~/.zfunc)

# set extra paths for root
if ((EUID==0)); then
	path=($path /sbin /usr/sbin /usr/local/sbin)
fi

# remove duplicate entries from paths
typeset -Ug path manpath cdpath fpath

# set umask
umask 022

# set limits
unlimit			# user hard limits
limit core 0		# no core dumps
limit maxproc 2048	# limit number of processes
limit stack 8192	# limit stack size
limit -s		# use limits for this and child shells

# set emacs key bindings
bindkey -e

# common key bindings
bindkey "^[[2~" yank			# Insert
bindkey "^[[3~" delete-char		# Delete
bindkey "^[[5~" up-line-or-history	# Page Up
bindkey "^[[6~" down-line-or-history	# Page Down
bindkey "^[[7~" beginning-of-line	# Home
bindkey "^[[8~" end-of-line		# End
bindkey "^[[A" up-line-or-search	# back-history-search on up arrow
bindkey "^[[B" down-line-or-search	# fwd-history-search on down arrow
bindkey "^[e" expand-cmd-path		# expand command name on C-e
bindkey " " magic-space			# history expansion on space

# edit current command line
autoload -U edit-command-line
zle -N edit-command-line
bindkey "^Xe" edit-command-line

# incremental word completion
autoload -U incremental-complete-word
zle -N incremental-complete-word
bindkey "^Xi" incremental-complete-word

# incremental file expansion
autoload -U insert-files
zle -N insert-files
bindkey "^Xf" insert-files

# magically expand multiple dots to ../ syntax (e.g. ... -> ../..)
rationalise-dot() { if [[ $LBUFFER = *.. ]]; then LBUFFER+=/.. else LBUFFER+=.  fi }
zle -N rationalise-dot
bindkey . rationalise-dot

# set backward-kill-word to stop on everything other than alphanumerics
autoload -U select-word-style
select-word-style bash

# set shell history options
HISTFILE=$HOME/.zhistory
SAVEHIST=100000				# history file size
HISTSIZE=50000				# internal history list size

# size of directory stack
DIRSTACKSIZE=20

# set mail options
MAIL=/var/mail/$USERNAME
MAILCHECK=60

# report login/logout events of all except ourself, once in every minute
watch=(notme)
LOGCHECK=60
WATCHFMT='%n %a %l from %m at %t.'

# set prompt (red for root, cyan otherwise, format: user@machine:cwd)
autoload -U colors && colors
if ((EUID==0)); then
    PROMPT="%{$fg[red]%}%n@%m%{$fg_bold[yellow]%}:%{$fg_bold[red]%}%1~%{$reset_color%}%{$fg[yellow]%}%#%{$reset_color%} "
else
    PROMPT="%{$fg[cyan]%}%n@%m%{$fg_bold[yellow]%}:%{$fg_bold[cyan]%}%1~%{$reset_color%}%{$fg[yellow]%}%#%{$reset_color%} "
fi

# don't ask 'do you wish to see all XX possibilities' before menu selection
LISTPROMPT=''

# spelling prompt
SPROMPT='zsh: correct '%R' to '%r' ? ([Y]es/[N]o/[E]dit/[A]bort) '

# command aliases
alias ls='ls -F --color=auto'
alias l='ls'
alias ll='ls -lh'
alias la='ls -a'
alias lla='ls -alh'
alias lsd='ls -ld *(-/DN)'
alias j='jobs -l'
alias p='ps -fu $USER'
alias h='history'
alias quit='exit'
alias vi='vim'
alias grep='grep --color'
alias egrep='egrep --color'
alias fgrep='fgrep --color'

# global aliases
alias -g ND='*(/om[1])'         # newest directory in CWD
alias -g NF='*(.om[1])'         # newest file in CWD

# extra safety for root
if ((EUID==0)); then
	alias rm='rm -i'
	alias cp='cp -i'
	alias mv='mv -i'
fi

# csh compatibility
setenv() {
	typeset -x "${1}${1:+=}${(@)argv[2,$#]}"
}

# recompile new zshrc file
function src() {
	autoload -U zrecompile
	[ -f ~/.zshrc ] && zrecompile -p ~/.zshrc
	[ -f ~/.zcompdump ] && zrecompile -p ~/.zcompdump
	[ -f ~/.zshrc.zwc.old ] && rm -f ~/.zshrc.zwc.old
	[ -f ~/.zcompdump.zwc.old ] && rm -f ~/.zcompdump.zwc.old
	source ~/.zshrc
}

# auto logout after 30 idle minutes, unless on X
TMOUT=1800
case $TERM in
	*xterm*|screen|rxvt|(dt|k|E|a)term)
		unset TMOUT
		;;
esac

# display title on X *term (user@host: cmd)
case $TERM in
	*xterm*|rxvt|(dt|k|E|a)term)
		precmd() {
			print -rn $'\e]0;'"${USER}@${HOST}"$'\a'
		}
		preexec() {
			print -rn $'\e]0;'"${USER}@${HOST}: ${(V)1}"$'\a'
		}
		;;
esac

# export some common variables
(( ${+TERM} )) || export TERM='vt100'
(( ${+PAGER} )) || export PAGER=`which less`
(( ${+EDITOR} )) || export EDITOR=`which vim`

# color support for less
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking-mode
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold-mode
export LESS_TERMCAP_me=$'\E[0m'           # end (blinking/bold)-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
export LESS_TERMCAP_ue=$'\E[0m'           # end underline

# customize ls colors
export LS_COLORS='di=01;34'

# setup completion
autoload -U compinit && compinit
zmodload -i zsh/complist

# set completion options
zstyle ':completion:*' completer _complete _list _oldlist _expand _ignored _match _correct _approximate _prefix
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format $'%{\e[0;31m%}%d%{\e[0m%}'
zstyle ':completion:*:messages' format $'%{\e[0;31m%}%d%{\e[0m%}'
zstyle ':completion:*:warnings' format $'%{\e[0;31m%}No matches for: %d%{\e[0m%}'
zstyle ':completion:*:corrections' format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' file-sort name
zstyle ':completion:*' menu select=long
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
zstyle ':completion:*:expand:*' tag-order all-expansions
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zcompcache/$HOST
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'

# generic completions for programs which understand GNU long options(--help)
compdef _gnu_generic make df du

# common usernames
users=(ipozgaj root)
zstyle ':completion:*' users $users

# common hostnames
hosts=(localhost)
zstyle ':completion:*' hosts $hosts

# (user,host) pairs
my_accounts=(ipozgaj@localhost root@localhost)
zstyle ':completion:*:my-accounts' users-hosts $my_accounts

# various shell options
setopt always_to_end		# when completing from middle, move to end
setopt auto_cd			# chdir to directory if we type its name only
setopt auto_pushd		# put directory on dir stack after chdir
setopt correct			# correct misspelled commands
setopt extended_glob		# set extended globing
setopt extended_history         # save timestamps and elapsed time in history file
setopt glob_complete		# do not expand globs to list of matched files, use completion
setopt hist_expire_dups_first   # when trimming history, remove oldest duplicates first
setopt hist_find_no_dups	# do not show duplicates on history-find
setopt hist_ignore_all_dups     # ignore duplicates in history file
setopt hist_ignore_space        # do not save commands starting with space
setopt hist_reduce_blanks	# remove superfluous blanks from history file
setopt hist_verify		# do not execute history expansion, load it only
setopt inc_append_history	# write entries to history files incrementaly
setopt interactive_comments     # allow comments in interractive shells
setopt mail_warning		# warn if mail file was accessed from last login
setopt no_beep			# prevent beeps
setopt no_null_glob		# prevent expanding of non matched globs to *
setopt pushd_ignore_dups	# do not place duplicates on directory stack
