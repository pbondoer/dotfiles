OS=`uname`

# locale
export LC_ALL=en_US.utf-8 
export LANG="$LC_ALL"

# misc options
unsetopt AUTO_CD

# allow colors
autoload -U colors && colors

# vcs prompt (options must be set to empty to disable)
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats ' (%b)'

precmd() {
	vcs_info
}

# history
HISTFILE=~/.bash_history
HISTSIZE=5000
SAVEHIST=9001
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history
setopt extended_glob

# autocomplete
autoload -Uz compinit
compinit

compdef _gnu_generic cat
compdef _gnu_generic gcc
compdef _gnu_generic gdb
compdef _git git
setopt complete_in_word

if [ $OS = "Linux" ] ; then
	compdef _pacman yaourt=pacman
fi

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''

# delete key
bindkey "^[[3~" delete-char

# variables
if [ $OS = "Linux" ] ; then
	export MAIL="pierre@bondoer.fr"
else
	export MAIL="$USER@student.42.fr"
	export PATH="$HOME/bin:$HOME/.brew/bin:$PATH"
fi

export USER="pbondoer"
export EDITOR="nvim"
export GPG_TTY=$(tty)
export CLICOLOR=1
export XDG_CONFIG_HOME=$HOME/.config
export MAVEN_OPTS="-Xmx2048m -XX:MaxPermSize=196m"

# prompt
P_TIME='%F{blue}%B%D{%L:%M %p}%b%f'
P_USER='%F{red}%B%n%b%f'
P_HOST='%F{green}%B%U%m%u%b%f'
P_DIR='%F{magenta}%S%c%s%f'
P_GIT='%F{yellow}%B${vcs_info_msg_0_}%b%f'
P_EXIT='%(?..%F{red} [%?]%f)'

export PROMPT="$P_EXIT $P_TIME > ${P_USER} $P_HOST > $P_DIR$P_GIT %# "

# fortune
fortune ~/fortune
echo ""

# window titles
if [ $OS = "Linux" ] ; then
	case $TERM in
		*xterm*|rxvt|rxvt-unicode|rxvt-256color|(dt|k|E)term)
			precmd () { print -Pn "\e]0;$TERM - [%n@%M]%# [%~]\a" } 
			preexec () { print -Pn "\e]0;$TERM - [%n@%M]%# [%~] ($1)\a" }
			;;
		screen)
			precmd () { 
				print -Pn "\e]83;title \"$1\"\a" 
				print -Pn "\e]0;$TERM - [%n@%M]%# [%~]\a" 
			}
			preexec () { 
				print -Pn "\e]83;title \"$1\"\a" 
				print -Pn "\e]0;$TERM - [%n@%M]%# [%~] ($1)\a" 
			}
			;; 
	esac
fi

# reminders
if [ -f ~/.reminders ]
then
	reminder_lines=`wc -l < ~/.reminders | tr -d ' \t\n\r\f'`
	echo "--- You have [$reminder_lines] reminders"
	while read line; do
		echo "*" $line
	done < ~/.reminders
	echo ""
fi

# aliases
if [ $OS = "Linux" ] ; then
	alias size="du -ch -d 1 2>/dev/null | sort -h"
	alias make="make -j 8"
	alias ff="firefox-developer"
	alias ls="ls --color"
else
	alias size="du -ch -d 1 2>/dev/null | gsort -h"
	alias make="gmake -j 8"
	alias gpg="gpg2"
	alias love="$HOME/bin/love.app/Contents/MacOS/love"
fi

alias vim="nvim"
alias project="xrandr --output HDMI-1 --auto"

# <3 from lemon
