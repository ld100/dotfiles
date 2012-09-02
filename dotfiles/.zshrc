#!/bin/zsh
# -*- mode: sh -*-
# zsh configuration
# (c) 2011 Alexander Lockshyn
# ld100 AT mourk.com
#
# Thanks to:
# Alexander Solovyov

### Global vars
[[ -s "/etc/profile" ]] && source "/etc/profile"

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_TIME=C
export LC_NUMERIC=C

### Paths
### OSX-specific paths
if [ `uname` = "Darwin" ];
then
	export PATH=/usr/local/Cellar/python/2.7/bin:$PATH
	export PATH=/usr/local/bin:$PATH
	export PATH=/usr/local/sbin:$PATH
	export PATH=/usr/local/share/python:$PATH
	export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
fi


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

#### Auto completion
autoload -U compinit compinit zmodload zsh/complist zstyle ':completion:*' menu yes select

### Colors
### OSX-specific color settings
if [ `uname` = "Darwin" ];
then
	export CLICOLOR=1
	export LSCOLORS=gxfxbxdxcxegedabagacad
	export LS_COLORS='di=36;40:ln=35;40:so=31;40:pi=33;40:ex=32;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'

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
	# set variable identifying the chroot you work in (used in the prompt below)
	if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
	    debian_chroot=$(cat /etc/debian_chroot)
	fi

	# set a fancy prompt (non-color, unless we know we "want" color)
	case "$TERM" in
	    xterm-color) color_prompt=yes;;
	esac
	
	# uncomment for a colored prompt, if the terminal has the capability; turned
	# off by default to not distract the user: the focus in a terminal window
	# should be on the output of commands, not on the prompt
	force_color_prompt=yes

	if [ -n "$force_color_prompt" ]; then
	    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		# We have color support; assume it's compliant with Ecma-48
		# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
		# a case would tend to support setf rather than setaf.)
		color_prompt=yes
	    else
		color_prompt=
	    fi
	fi
	
	if [ "$color_prompt" = yes ]; then
	    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
	else
	    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
	fi
	unset color_prompt force_color_prompt

	# If this is an xterm set the title to user@host:dir
	case "$TERM" in
	xterm*|rxvt*)
	    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
	    ;;
	*)
	    ;;
	esac

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
fi

#setopt no_beep
setopt auto_cd
setopt multios
setopt cdablevarS

if [[ x$WINDOW != x ]]
then
    SCREEN_NO="%B$WINDOW%b "
else
    SCREEN_NO=""
fi

# Setup the prompt with pretty colors
setopt prompt_subst


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
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

### Completions


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
