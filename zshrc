#################################################################
# Z Shell zshrc file                                            #
#                                                               #
# (C) Igor Pozgaj <ipozgaj@fly.srk.fer.hr>                      #
# Last modified: 05.07.2010.                                    #
#                                                               #
# Thanks to:  Marijan Peh <marijan.peh@hi.htnet.hr>             #
#             Bart Schaefer <schaefer@brasslantern.com>         #
#             Mario Jose Medjeral <mario@medjeral.demon.co.uk>  #
#                                                               #
# Note: make your tabstop 8 chars to get nice view of this file #
#################################################################

# set paths
path=($path /bin /usr/bin /usr/local/bin /usr/X11R6/bin $HOME/bin) 
manpath=($manpath /usr/local/man /usr/share/man)
cdpath=($cdpath ~)

# set extra paths for root
if ((EUID==0)); then
	path=($path /sbin /usr/sbin /usr/local/sbin)
fi

# remove duplicate entries from paths
typeset -U path manpath cdpath

# set umask
umask 027

# set limits
unlimit
limit core 0		# no limit for core dumps 
limit maxproc 128	# limit number of processes
limit stack 8192	# 8MB of memory for stack
limit -s

# set key bindings
bindkey -e
bindkey -s "^XS" 'ssh -2 -x -C -c blowfish '	# ssh template on C-x S

case $TERM in
	linux)
		bindkey "^[[2~" yank			# Insert
		bindkey "^[[3~" delete-char		# Delete
		bindkey "^[[5~" up-line-or-history	# Page Up
		bindkey "^[[6~" down-line-or-history	# Page Down
		bindkey "^[OH" beginning-of-line	# Home
		bindkey "^[OF" end-of-line		# End
		bindkey "^[e" expand-cmd-path		# Meta+E
		bindkey "^[[A" up-line-or-search
		bindkey "^[[B" down-line-or-search
		bindkey " " magic-space
		;;
		
	*xterm*|rxvt|(dt|k|a|E)term)
		bindkey "^[[2~" yank			# Insert
		bindkey "^[[3~" delete-char		# Delete
		bindkey "^[[5~" up-line-or-history	# Page Up
		bindkey "^[[6~" down-line-or-history	# Page Down
		bindkey "^[[7~" beginning-of-line	# Home
		bindkey "^[[8~" end-of-line		# End
		bindkey "^[e" expand-cmd-path		# Meta+E
		bindkey "^[[A" up-line-or-search
		bindkey "^[[B" down-line-or-search
		bindkey " " magic-space
		;;
esac

# set shell history options
HISTFILE=$HOME/.zhistory
SAVEHIST=5000
HISTSIZE=2000

# maximum size of directory stack
DIRSTACKSIZE=10

# set mail options
MAIL=/var/mail/$USERNAME
MAILCHECK=60

# report login/logout events of all except ourself, once in every minute
watch=(notme)
LOGCHECK=60
WATCHFMT='%n %a %l from %m at %t.'

# set prompt (red for root, cyan otherwise, display only the hostname and CWD)
if ((EUID==0)); then
	PROMPT=$'%{\e[0;31m%}%n@%m%{\e[0;33m%}%B:%b%{\e[0;31m%}%B%1~%b%{\e[0;33m%}%#%{\e[0m%} '
else
	PROMPT=$'%{\e[0;36m%}%n@%m%{\e[0;33m%}%B:%b%{\e[0;36m%}%B%1~%b%{\e[0;33m%}%#%{\e[0m%} '
fi

# don't ask 'do you wish to see all XX possibilities' before menu selection
LISTPROMPT=''

# spelling prompt
SPROMPT='zsh: correct '%R' to '%r' ? ([Y]es/[N]o/[E]dit/[A]bort) '

# set common aliases
alias ls='ls --color=auto'
alias l='ls'
alias ll='ls -lh'
alias la='ls -a'
alias lla='ls -alh'
alias lsd='ls -ld *(-/DN)'
alias cp='nocorrect cp'
alias mv='nocorrect mv'
alias mkdir='nocorrect mkdir'
alias j='jobs -l'
alias p='ps -fu $USER'
alias h='history'
alias scr='screen -r'
alias u='uptime'
alias quit='exit'
alias vi='vim'
alias w2u='recode ms-ee/cr-lf..l2'
alias u2w='recode l2..ms-ee/cr-lf'

# global aliases
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g S='| sort'
alias -g SR='| sort -r'
alias -g SN='| sort -n'
alias -g SNR='| sort -n -r'
alias -g W='| wc -l'
alias -g N='&>/dev/null'

# display sizes in human readable format
alias du='du -h'
alias df='df -h'

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
	*xterm*|rxvt|(dt|k|E)term)
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
(( ${+USER} )) || export USER=$USERNAME
(( ${+HOSTNAME} )) || export HOSTNAME=$HOST
(( ${+EDITOR} )) || export EDITOR=`which vim`
(( ${+VISUAL} )) || export VISUAL=`which vim`
(( ${+FCEDIT} )) || export FCEDIT=`which vim`
(( ${+PAGER} )) || export PAGER=`which less`
(( ${+LESSCHARSET} )) || export LESSCHARSET='latin1'
(( ${+LESSOPEN} )) || export LESSOPEN='| lesspipe.sh %s'

# set colors for less in xterm
case $TERM in
	*xterm*|rxvt|(dt|k|a|E)term)
		export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
		export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
		export LESS_TERMCAP_me=$'\E[0m'           # end mode
		export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode
		export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
		export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
		export LESS_TERMCAP_ue=$'\E[0m'           # end underline
		;;
esac

# configure colors for less (i.e. for man pages)
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

# turn on advanced completion system
if [[ "$ZSH_VERSION" == (3.1|4)* ]]; then
	autoload -U compinit
	compinit -C
else
	print "Advanced completion system not found; ignoring zstyle settings."
	function zstyle { }
fi

# use menu selection
zmodload -i zsh/complist

# allow incremental word completion
autoload -U incremental-complete-word
zle -N incremental-complete-word
bindkey "^Xi" incremental-complete-word

# allow incremental file expansion
autoload -U insert-files
zle -N insert-files
bindkey "^Xf" insert-files

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
zstyle ':completion::complete:*' use-cache 1
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
hosts=(fly.srk.fer.hr localhost)
zstyle ':completion:*' hosts $hosts

# (user,host) pairs
my_accounts=(ipozgaj@fly.srk.fer.hr ipozgaj@localhost root@localhost)
zstyle ':completion:*:my-accounts' users-hosts $my_accounts

# various shell options
setopt always_to_end		# place cursor to end upon successful completion
setopt auto_cd				# cd to directory if we type it's name only
setopt auto_pushd			# push directories on directory stack when changing directory
setopt correct				# correct misspelled commands
setopt correct_all			# correct misspelled arguments
setopt glob_complete		# set complete globing
setopt extended_glob		# set extended globing
setopt hist_find_no_dups	# do not show duplicates on history-find
setopt hist_reduce_blanks	# remove superfluous blanks from history file
setopt hist_verify			# do not execute history expansion, load it only
setopt inc_append_history	# write entries to history files incrementaly
setopt null_glob			# delete word if no match is found
setopt mail_warning			# warn if mail file was accessed from last login
setopt pushd_ignore_dups	# do not place duplicates on directory stack
setopt nobeep				# prevent beeps
unsetopt null_glob			# prevent expanding of non matched globs to *
