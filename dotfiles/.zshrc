#!/bin/zsh
# -*- mode: sh -*-
# zsh configuration
# (c) 2011 Alexander Lockshyn
# ld100 AT mourk.com
#
# Thanks to:
# Alexander Solovyov

### Global vars
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_TIME=C
export LC_NUMERIC=C

### Paths
### OSX-specific paths
if [ `uname` = "Darwin" ];
then
	[[ -s "/etc/profile" ]] && source "/etc/profile"
	
	export PATH=/usr/local/Cellar/python/2.7/bin:$PATH
	export PATH=/usr/local/bin:$PATH
	export PATH=/usr/local/sbin:$PATH
	export PATH=/usr/local/share/python:$PATH
	export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
fi

### History
# If I type cd and then cd again, only save the last one
setopt HIST_IGNORE_DUPS

# Even if there are commands inbetween commands that are the same, still only save the last one
setopt HIST_IGNORE_ALL_DUPS

# Pretty    Obvious.  Right?
setopt HIST_REDUCE_BLANKS

# If a line starts with a space, don't save it.
setopt HIST_IGNORE_SPACE
setopt HIST_NO_STORE

# When using a hist thing, make a newline show the change before executing it.
setopt HIST_VERIFY

# share history between multiple sessions
setopt SHARE_HISTORY

# Don't overwrite, append!
setopt APPEND_HISTORY

# Write after each command
# setopt INC_APPEND_HISTORY

# Save the time and how long a command ran
setopt EXTENDED_HISTORY

setopt HIST_SAVE_NO_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

### Command line prompt

# Apply theming defaults
# PS1="%n@%m:%~%# "
# PROMPT='%B%F{green}%n@%m%f:%F{blue}%~%f%b%(!.#.$) '
PROMPT='%{$fg[green]%}%n%{$reset_color%}%{$fg_bold[blue]%}@%{$reset_color%}%{$fg[red]%}%m%{$reset_color%} { %{$fg_bold[yellow]%}${PWD/#$HOME/~}%{$reset_color%} } $(prompt_char) '
RPROMPT='%{$fg[magenta]%}$(get_git_prompt_info)%{$reset_color%}'
autoload -U colors && colors

### RVM integration
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

### Show Git Branch vars
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions
export __CURRENT_GIT_BRANCH=
export __CURRENT_GIT_VARS_INVALID=1

### Auto completion (New Style)
autoload -Uz compinit
compinit
zmodload zsh/complist
zstyle ':completion:*' menu yes select
# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' \
	'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
	
# This gives more extensive tab completion
setopt completeinword

### Colors
### OSX-specific color settings
if [ `uname` = "Darwin" ];
then
	export CLICOLOR=1
	export LSCOLORS=gxfxbxdxcxegedabagacad
	export LS_COLORS='di=36;40:ln=35;40:so=31;40:pi=33;40:ex=32;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'

	# Colorize dir completion
	zstyle ':completion:*' list-colors 'exfxcxdxbxegedabagacad'

	# Enable ls colors
	if [ "$DISABLE_LS_COLORS" != "true" ]
	then
	  # Find the option for using colors in ls, depending on the version: Linux or BSD
	  ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=tty' || alias ls='ls -G'
	fi
fi

### Linux-specific color settings
if [ `uname` = "Linux" ];
then
	export LS_COLORS='di=36;40:ln=35;40:so=31;40:pi=33;40:ex=32;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'
	
	# enable color support of ls and also add handy aliases
	if [ -x /usr/bin/dircolors ]; then
		test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
		alias ls='ls --color=auto'
		#alias dir='dir --color=auto'
		#alias vdir='vdir --color=auto'

		alias grep='grep --color=auto'
		alias fgrep='fgrep --color=auto'
		alias egrep='egrep --color=auto'
	fi
	
	# Tmux/Screen mouse fixes
	if [ $TERM = "screen" ]; then
	    export TERM=xterm-color
	fi
	if [ -n "$TMUX" ]; then
	    export COLORTERM=rxvt
	fi

	# some more ls aliases
	alias ll='ls -alF'
	alias la='ls -A'
	alias l='ls -CF'
fi

### Different options
# setopt NO_BEEP

# Type ".." instead of "cd ..", "/usr/include" instead of "cd /usr/include".
setopt AUTO_CD

# allow functions to have local options
setopt LOCAL_OPTIONS

# allow functions to have local traps
setopt LOCAL_TRAPS

# Now we can pipe to multiple outputs!
setopt MULTIOS

# Spell check commands!  (Sometimes annoying)
# setopt CORRECT

# This will use named dirs when possible
setopt AUTO_NAME_DIRS

# 10 second wait if you do something that will delete everything.  I wish I'd had this before...
setopt RM_STAR_WAIT

setopt cdablevarS

# pound sign in interactive prompt
# This is useful to remember command in your history without executing them.
setopt interactivecomments 

# Superglobs
setopt extendedglob
unsetopt caseglob

# Setup the prompt with pretty colors
setopt prompt_subst

# only fools wouldn't do this ;-)
export EDITOR="mcedit"

if [[ x$WINDOW != x ]]
then
	SCREEN_NO="%B$WINDOW%b "
else
	SCREEN_NO=""
fi




### Keyboard config
# alias zkbd='zsh /usr/share/zsh/4.3.9/functions/Misc/zkbd'
# autoload zkbd
# [[ ! -d ~/.zkbd ]] && mkdir ~/.zkbd
# [[ ! -f ~/.zkbd/$TERM-$VENDOR-$OSTYPE ]] && zkbd

bindkey "\e[1~" beginning-of-line
bindkey "\e[2~" quoted-insert
bindkey "\e[3~" delete-char
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[7~" beginning-of-line
bindkey "\e[8~" end-of-line
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
bindkey "\eOd" backward-word
bindkey "\eOc" forward-word

### Aliases
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias tmuxinate="tmux attach || tmux new"

### Functions

# Prompt-specific
function prompt_char {
	git branch >/dev/null 2>/dev/null && echo '±' && return
	hg root >/dev/null 2>/dev/null && echo '☿' && return
	echo '○'
}

function virtualenv_info {
	[ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}


# Adility-specific functions
function adility_prod_console() {
	ssh -t deployer@adility.com '/var/data/www/apps/adilityshop/current/script/console production'
}

function adility_demo_console() {
	ssh -t deployer@developer.adilitydemo.com '/var/data/www/apps/adilityshop_apidemo/current/script/console apidemo'
}

# My Utils
function clear_dns_cache() {
	dscacheutil -flushcache
}

function start_pg() {
	pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
}

function stop_pg() {
	pg_ctl -D /usr/local/var/postgres stop -s -m fast
}

function install_goodies() {
	# Tool I use:
	# nmap netdiag htop mc screen tmux vim ne wget sysstat
	# fish zsh ccze pv logrotate rkhunter etckeeper
	if [ `uname` = "Darwin" ];
	then
		echo "Installing OSX goodies..."
		install_osx_goodies
	fi
	
	if [ `uname` = "Linux" ];
	then
		echo "Installing Linux Ubuntu goodies..."
		install_linux_goodies
	fi
}

function install_linux_goodies() {
	alias install_everything = ""
	if [[ -x =apt-get ]]; then
		alias install_everything="	sudo apt-get install nmap netdiag htop mc screen tmux vim ne wget \
		sysstat ccze pv logrotate rkhunter etckeeper"
	else
		echo "Sorry, only debian-based distros are currently supported"
		if [[ -x =yum ]]; then
			alias install_everything = ""
		fi
	fi
	
	install_everything
}

function install_osx_goodies() {
	if [[ -x =brew ]]; then
		brew install wget midnight-commander pv
	else
		echo "Please install Homebrew first"
	fi
}

function update_configs() {
	cd ~/.dotfiles && git pull
	cd $OLDPWD
}


### Git Functions
zsh_git_invalidate_vars() {
	export __CURRENT_GIT_VARS_INVALID=1
}
zsh_git_compute_vars() {
	export __CURRENT_GIT_BRANCH="$(parse_git_branch)"
	export __CURRENT_GIT_VARS_INVALID=
}
parse_git_branch() {
	git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) -- /' 
}

# Alternative git-branch func
gitbranch() {
	git_branch=`git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ $git_branch ]; then
		echo "$git_branch"
	fi
}


chpwd_functions+='zsh_git_chpwd_update_vars'
	zsh_git_chpwd_update_vars() {
		zsh_git_invalidate_vars
	}

preexec_functions+='zsh_git_preexec_update_vars'
	zsh_git_preexec_update_vars() {
		case "$(history $HISTCMD)" in 
			*git*) zsh_git_invalidate_vars ;;
		esac
}

get_git_prompt_info() {
	test -n "$__CURRENT_GIT_VARS_INVALID" && zsh_git_compute_vars
	echo $__CURRENT_GIT_BRANCH
}
