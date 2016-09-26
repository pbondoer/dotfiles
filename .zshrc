OS=`uname`
if [ $OS = "Linux" ] ; then
fi

# Completion
zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''

autoload -Uz compinit
compinit
compdef _gnu_generic cat
compdef _git git

if [ $OS = "Linux" ] ; then
	compdef _pacman yaourt=pacman
fi

# History file
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
unsetopt autocd

# Vi keybinding
bindkey -v

# fix locale
export LC_ALL=en_US.utf-8 
export LANG="$LC_ALL"

# allow colors
autoload -U colors && colors
# allow substitution (needed for git)
setopt PROMPT_SUBST

# git prompt (options must be set to empty to disable)
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
precmd() {
	vcs_info
}
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats " (%b)"

# fix del key
bindkey "^[[3~" delete-char

# variables
if [ $OS = "Linux" ] ; then
	export MAIL="pierre@bondoer.fr"
	export USER="lemon"
else
	export MAIL="pbondoer@student.42.fr"
	export USER="pbondoer"
fi

export PROMPT=' %B%n%b@%U%m%u:%S%c%s%{$fg[yellow]%}${vcs_info_msg_0_} %{$reset_color%}%# '
export RPROMPT='%t'
export EDITOR="vim"

# fortune
fortune ~/fortune
echo ""

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

# window titles
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

# quick way to paste stuff
sprunge() {
	cat $1 | curl -F 'sprunge=<-' http://sprunge.us
}

# alias gpg=gpg2
alias size="du -ch -d 1 | sort -h"
alias ff="firefox-developer"
# <3 from lemon
