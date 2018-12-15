#!/bin/sh

# ---------------------------------------------------------------------------- #
# @name          42-setup.sh
# @description   Set up a new session from this repository
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

# Log message colors
TITLE=$MAGENTA
STEP=$CYAN

BASE=..

log $RED "\n/!\\ WARNING - DANGER ZONE /!\\ "
log $RED "This will erase some configurations and should only be used to
initialize a new session at 42. Please only run this script *after* reading
absolutely everything.\n\nPlease close all applications before continuing as you
will be logged out at the end of this script.\n"

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
# zsh
cp $BASE/color.sh $HOME
cp $BASE/.zshrc $HOME
cp $BASE/osx/usage.sh $HOME/.usage.sh
touch $HOME/.hushlogin
# sgoinfre
rm $HOME/sgoinfre &> /dev/null
ln -shf /sgoinfre/goinfre/Perso/$USER $HOME/sgoinfre

log $STEP "fortune"
cp -r $BASE/fortune $HOME
strfile $HOME/fortune/* > /dev/null

log $STEP "Homebrew"
rm -rf $HOME/.brew
sh $BASE/osx/brew-init.sh
sh $BASE/osx/brew.sh

log $STEP "vim"
mkdir -p $HOME/.vim/backup
mkdir -p $HOME/.vim/swap
mkdir -p $HOME/.vim/undo
cp $BASE/.vimrc $HOME
# vim-plug
mkdir -p $HOME/.vim/plugged
mkdir -p $HOME/.vim/autoload
curl -fLo $HOME/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim &> /dev/null
# header
mkdir -p $HOME/.vim/plugin
curl -fLo $HOME/.vim/plugin/42header.vim https://raw.github.com/pbondoer/vim-42header/master/42header.vim &> /dev/null
# neovim symlinks
mkdir -p $HOME/.config
ln -s $HOME/.vim $HOME/.config/nvim
ln -s $HOME/.vimrc $HOME/.config/nvim/init.vim

log $STEP "Git"
git config --global push.default simple
git config --global user.email $MAIL
git config --global commit.gpgsign true

log $STEP "Backup"
cp $BASE/backup.sh $HOME
cp $BASE/.backup $HOME

log $STEP "OSX"
sh $BASE/osx/osx-42.sh

log $GREEN "\nYour session is now configured, you will now be logged out.\n
Thanks for all the fish ><>!"
sleep 3
osascript -e 'tell application "loginwindow" to  «event aevtrlgo»'
killall iTerm > /dev/null
killall Terminal > /dev/null
