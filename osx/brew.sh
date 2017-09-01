#!/bin/sh
source ../color.sh

# Use proper directories
export HOMEBREW_CACHE=/tmp/Homebrew/Caches
export HOMEBREW_TEMP=/tmp/Homebrew/Temp

mkdir -p $HOMEBREW_CACHE
mkdir -p $HOMEBREW_TEMP

# Use latest Homebrew
log $GREEN "* Updating..."
brew update #&> /dev/null

# Upgrade scripts
log $GREEN "* Upgrading..."
brew upgrade --all #&> /dev/null

# Install
count=`wc -l < brew_list | tr -d ' '`
log $GREEN "* Installing $count packages..."

while read package
do
	log $YELLOW "** $package"
	brew install $package #&> /dev/null
done < brew_list

# Cleanup
log $GREEN "Cleanup..."
brew cleanup #&> /dev/null
