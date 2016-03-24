#!/bin/sh

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

TITLE=$MAGENTA
STEP=$CYAN

log $RED "\n/!\\ WARNING - DANGER ZONE /!\\ "
log $RED "This will erase some configurations and should only be used to
initialize a new session at 42. Please only run this script *after* reading
absolutely everything.\n"

read -p "Continue (y/n)? " -n 1 -r
echo "\n" # add some padding

if ! [[ $REPLY =~ ^[Yy]$ ]]
then
	log $STEP "Aborted by user."
	exit 0
fi

log $TITLE "Configuring session for $USER..."
log $TITLE "This might take a little while.\n"

log $STEP "Configuration files"
cp .zshrc ~
source .zshrc > /dev/null
touch ~/.hushlogin
touch ~/.reminders
rm ~/sgoinfre &> /dev/null
ln -shf /sgoinfre/goinfre/Perso/$USER ~/sgoinfre

log $STEP "fortune"
cp -r fortune ~
strfile ~/fortune/* > /dev/null

log $STEP "OSX"
sh osx-42.sh

log $STEP "Homebrew"
rm -rf ~/.brew
sh brew.sh

log $STEP "vim"
mkdir -p $HOME/.vim/backup
mkdir -p $HOME/.vim/swap
mkdir -p $HOME/.vim/undo
cp .vimrc ~
# vim-plug
mkdir -p ~/.vim/plugged
mkdir -p ~/.vim/autoload
curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim &> /dev/null
# header
mkdir -p ~/.vim/plugin
curl -fLo ~/.vim/plugin/42header.vim https://raw.github.com/pbondoer/vim-42header/master/42header.vim &> /dev/null

log $STEP "Git"
git config --global push.default simple
git config --global user.email $MAIL

log $STEP "Backup"
cp backup.sh ~
cp .backup ~

log $GREEN "\nYour session is now configured, please relog for full effect.
Thanks for all the fish ><>!"
