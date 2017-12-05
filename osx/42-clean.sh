#!/bin/sh
source color.sh

TITLE=$MAGENTA
STEP=$CYAN
SUCCESS=$GREEN
SIZE=$YELLOW

total=0

log() {
	tput setaf $1
	printf "$2"
}

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

item() {
	size=`du -sck ${@:1} 2>/dev/null | tail -n1 | cut -d $'\t' -f1 | tr -d ' '`
	total=$((total + size))
	rm -rf ${@:1} 2>/dev/null
	log $SIZE "$(bytefmt $size)\n"
}

log $TITLE "Cleaning up junk files...\n\n"

log $STEP "42 Library backups ... "
item "$HOME/Library/*.42_cache*" "$HOME/*.42_cache*"

log $STEP "NPM cache ... "
item "$HOME/.npm"

log $STEP "OS X Trash ... "
item "$HOME/.Trash/*"

log $STEP "~/.cache ... "
item "$HOME/.cache"

log $STEP "Brew ... "
item `brew cleanup -n 2> /dev/null | cut -d ' ' -f3 | tr -d ' ' | grep -v operation` `brew --cache`

log $SUCCESS "\nDone! Removed $(bytefmt $total)\n"
