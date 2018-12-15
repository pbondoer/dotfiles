OS=`uname`
HOST=`hostname`

# SSH check
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]
then
	SSH=1
fi

# load environment
export ENV=`sh $HOME/.env.sh`
function chpwd {
	prev_env=$ENV

	export ENV=`sh $HOME/.env.sh`

	rcfile=$HOME/.${ENV,,}rc
	if [ $ENV != $prev_env ] && [ -f $rcfile ]
	then
		source $rcfile
	fi

}

# locale
export LC_ALL=en_US.utf-8 
export LANG="$LC_ALL"

# misc options
unsetopt AUTO_CD

# allow colors
autoload -U colors && colors

# allow hooks
autoload -Uz add-zsh-hook

# vcs prompt (options must be set to empty to disable)
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats ' (%b)'

add-zsh-hook -Uz precmd vcs_info

# history
HISTFILE=$HOME/.bash_history
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

if [ $OS = "Linux" ]
then
	compdef _pacman yay=pacman
fi

zstyle ':completion:*' completer _complete _ignored _approximate
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path $HOME/.cache/zsh

# delete key
bindkey "^[[3~" delete-char

# variables
if [ $OS = "Linux" ]
then
	export XDG_CONFIG_HOME=$HOME/.config
	# android
	export ANDROID_HOME=/opt/android-sdk
	export PATH="$ANDROID_HOME/tools:$PATH"
elif [ $OS = "Darwin" ]; then
	# brew
	export PATH="$HOME/.brew/bin:$PATH"
fi

# rust
export PATH="$HOME/.cargo/bin:$PATH"
# global bin
export PATH="$HOME/bin:$PATH"

export USER="pbondoer"
export EDITOR="nvim"
export GPG_TTY=$(tty)
export CLICOLOR=1

# prompt
P_EXIT='%(?..%F{red} [%?]%f)'
P_ENV='%F{blue} [${ENV}]%f'
P_TIME='%F{blue}%B%D{%L:%M %p}%b%f'
P_SSH=''
if [ "$SSH" = "1" ]
then
	P_SSH=' > %F{cyan}ssh%f'
fi
P_USER='%F{red}%B%n%b%f'
P_HOST='%F{green}%B%U%m%u%b%f'
P_DIR='%F{magenta}%S%c%s%f'
P_GIT='%F{yellow}%B${vcs_info_msg_0_}%b%f'

export PROMPT="$P_EXIT$P_ENV $P_TIME$P_SSH > ${P_USER} $P_HOST > $P_DIR$P_GIT %# "

export NVM_DIR="$HOME/.nvm"

# window titles
if [ $OS = "Linux" ]
then
	function xterm_precmd() {
		print -Pn "\e]0;$TERM - [%n@%M]%# [%$HOME]\a"
	}
	function xterm_preexec() {
		print -Pn "\e]0;$TERM - [%n@%M]%# [%$HOME] ($1)\a"
	}

	case $TERM in
		*xterm*|rxvt*|(dt|k|E)term)
			add-zsh-hook -Uz precmd xterm_precmd
			add-zsh-hook -Uz preexec xterm_preexec
			;;
	esac
fi

# fortune
fortune $HOME/fortune
echo ""

# use proper terminal when on SSH
if [ "$SSH" = "1" ]
then
	export TERM=xterm
fi

# show usage bar
if [ -f $HOME/.usage.sh ]
then
	sh $HOME/.usage.sh
	echo ""
fi

# reminders
if [ -f $HOME/.reminders ]
then
	reminder_lines=`wc -l < $HOME/.reminders | tr -d ' \t\n\r\f'`
	tput setaf 8
	echo "--- You have [$reminder_lines] reminders"
	tput setaf 7
	while read line; do
		echo "*" $line
	done < $HOME/.reminders
	echo ""
fi

# aliases
alias dc="docker-compose"
alias fig="docker-compose"
alias vim="nvim"
alias size="du -ch -d 1 2>/dev/null | sort -h"

if [ $OS = "Linux" ]
then
	alias make="make -j 8"
	alias ff="firefox-developer-edition"
	alias firefox-developer="firefox-developer-edition"
	alias feh="feh -d" # Draw filename at the top of the feh window
	alias ls="ls --color"
	alias grep="grep --color"
elif [ $OS = "Darwin" ]
then
	alias sort="gsort"
	alias make="gmake -j 8"
	alias gpg="gpg2"
	alias love="$HOME/bin/love.app/Contents/MacOS/love"
fi

# use the syntax highlight script
if [ $OS = "Linux" ]
then
	# yay -S zsh-syntax-highlighting
	source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [ $OS = "Darwin" ]
then
	# brew install zsh-syntax-highlighting
	source /Users/$USER/.brew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# NVM
if [ $OS = "Linux" ]
then
	source /usr/share/nvm/init-nvm.sh
fi

# <3 from lemon
