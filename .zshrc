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
export MAIL="$USER@student.42.fr"
export PROMPT=' %B%n%b@%U%m%u:%S%c%s%{$fg[yellow]%}${vcs_info_msg_0_} %{$reset_color%}%# '
export RPROMPT='%t'
export PATH="$HOME/.brew/bin:$PATH"
export EDITOR="vim"

# brew: use proper caches dir
mkdir -p ~/Library/Caches/Homebrew
export HOMEBREW_CACHE=~/Library/Caches/Homebrew

# fortune
fortune ~/fortune
#gshuf -n 1 .quotes | sed 's/\\n/\'$'\n/g'
#cat .quotes | perl -MList::Util=shuffle -e 'print shuffle(<STDIN>);' | tail -1 | sed 's/\\n/\'$'\n/g'
echo ""
# reminders
if [ -f ~/.reminders ]
then
	reminder_lines=`wc -l < ~/.reminders | tr -d ' \t\n\r\f'`
	echo "[$reminder_lines] You have reminders"
	while read line; do
		echo "*" $line
	done < ~/.reminders
	echo ""
fi

# gpg alias
alias gpg=gpg2
# size alias
alias size="du -ch -d 1"
# <3 from lemon
