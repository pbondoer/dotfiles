#!/bin/sh
source color.sh

log $CYAN "Performing first time brew setup"

log $GREEN "Removing old install..."
rm -rf $HOME/.brew

log $GREEN "Installing..."
/usr/local/bin/brew update

log $GREEN "Updating..."
$HOME/.brew/bin/brew update

echo 'export PATH=$HOME/.brew/bin:$PATH' >> $HOME/.zshrc
log $YELLOW "Done! Brew installed, added to PATH and exported in .zshrc"
printf "To install packages, use "
tput setaf $RED
printf "brew install package"
log $YELLOW "."
