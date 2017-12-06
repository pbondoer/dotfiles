#!/bin/sh
source color.sh

TITLE=$MAGENTA
STEP=$CYAN
SUCCESS=$GREEN
DANGER=$RED
SIZE=$YELLOW

log() {
	tput setaf $1
	printf "$2"
}

filelist=()
total=0

# bash options, to be undone at exit
shopt -u | grep -q nullglob && change_null=true && shopt -s nullglob
shopt -u | grep -q dotglob && change_dot=true && shopt -s dotglob

undoopts() {
	[ $change_null ] && shopt -u nullglob; unset change_null
	[ $change_dot ] && shopt -u dotglob; unset change_dot
}

trap undoopts INT TERM EXIT

# https://unix.stackexchange.com/a/259254
bytefmt() {
	b=${1:-0}; d=''; s=0; S=(bytes {K,M,G,T,E,P,Y,Z}B)
	b=$((b * 1024))
	while ((b > 1024)); do
		d="$(printf ".%02d" $((b % 1024 * 100 / 1024)))"
		b=$((b / 1024))
		let s++
	done
	echo "$b$d ${S[$s]}"
}

# Items
item() {
	size=`du -I . -sck ${@:1} 2>/dev/null | tail -n1 | cut -d $'\t' -f1 | tr -d ' '`
	total=$((total + size))
	filelist=("${filelist[@]}" "${@:1}")
	log $SIZE "$(bytefmt $size)\n"
	for file in ${@:1}
	do
		log $WHITE " -> "
		log $SIZE "$file\n"
	done
}

log $TITLE "Finding junk files...\n\n"

log $STEP "42 Library backups ... "
item $HOME/Library/*.42_cache_bak_* $HOME/*.42_cache_bak_*

log $STEP "NPM cache ... "
item $HOME/.npm/*

log $STEP "OS X Trash ... "
item $HOME/.Trash/*

log $STEP "~/.cache ... "
item $HOME/.cache/*

log $STEP "Brew ... "
item `brew cleanup -n 2> /dev/null | cut -d ' ' -f3 | tr -d ' ' | grep -v operation` `brew --cache`/*

log $WHITE "\n"

if [[ -z "${filelist[@]}" ]]
then
	log $SUCCESS "Done! No files to delete.\n"
	exit 0
fi

log $DANGER "/!\\ WARNING - DANGER ZONE /!\\ \n"
log $DANGER "This will erase ${#filelist[@]} files listed above.\n"

log $WHITE "\n"
read -p "Continue (y/n)? " -n 1 -r
echo "\n" # add some padding

if ! [[ $REPLY =~ ^[Yy]$ ]]
then
	log $STEP "Aborted by user.\n"
	exit 0
fi

log $STEP "Removing...\n"
rm -rf ${filelist[@]}

log $SUCCESS "\nDone! Removed "
log $SIZE "${#filelist[@]} files"
log $SUCCESS " and freed "
log $SIZE "$(bytefmt $total)"
log $SUCCESS ".\n"
