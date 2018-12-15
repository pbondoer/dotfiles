#!/bin/sh

# ---------------------------------------------------------------------------- #
# @name          brew-init.sh
# @description   Initialize brew
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
	printf "$2\n"
}

tput setaf $YELLOW
printf "Add export to ~/.zshrc (y/n)? "
tput setaf $WHITE
read -n 1 -r
echo "\n" # add some padding

add_export="yes"
if ! [[ $REPLY =~ ^[Yy]$ ]]
then
	add_export="no"
fi

log $CYAN "Performing first time brew setup"

log $GREEN "* Removing old install..."
# rm -rf $HOME/.brew

log $GREEN "* Installing..."
# /usr/local/bin/brew update

log $GREEN "* Updating..."
# $HOME/.brew/bin/brew update

printf "\n"

log $YELLOW "Done! Brew installed and updated"

if [ "$add_export" = "yes" ]
then
	# echo 'export PATH=$HOME/.brew/bin:$PATH' >> $HOME/.zshrc
	log $YELLOW " -> Added to PATH and exported in .zshrc"
fi

printf "\nTo install packages, use "
tput setaf $RED
printf "brew install package"
log $YELLOW "."
