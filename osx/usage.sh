#!/bin/zsh

# ---------------------------------------------------------------------------- #
# @name          usage.sh
# @description   Disk space usage bar
# @author        pbondoer
# @license       WTFPL
# ---------------------------------------------------------------------------- #

# Base colors
BLACK=0
RED=1
GREEN=2
YELLOW=3
BLUE=4
MAGENTA=5
CYAN=6
WHITE=7

log() {
	tput setaf $1
	printf "$2"
}

# https://stackoverflow.com/a/28044986
function progress {
	let _progress=(${1}*100/${2}*100)/100
	let _done=(${_progress}*4)/10
	let _left=40-$_done

	_fill=$(printf "%${_done}s")
	_empty=$(printf "%${_left}s")

	printf "[${_fill// /#}${_empty// /-}] ${_progress}%%"
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

df=`df -k | grep $USER`
total=`echo $df | cut -d ' ' -f2`
used=`echo $df | cut -d ' ' -f3`
let percent=($used/$total)*100

if [[ "$percent" -lt 75 ]]
then
	usage_color=$GREEN
else
	if [[ "$percent" -lt 90 ]]
	then
		usage_color=$YELLOW
	else
		usage_color=$RED
	fi
fi

tput setaf $usage_color
progress $used $total
log $CYAN "\nUsed "
log $usage_color "$(bytefmt used)"
log $CYAN " out of "
log $usage_color "$(bytefmt total)"
log $CYAN "\n"

# vim: ft=zsh
