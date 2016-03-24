#!/bin/sh
source color.sh

# Minimal configuration script for 42
# Not as complete as osx-42.sh, but it comes with most basic configurations

STEP=$YELLOW
CATEGORY=$GREEN

log $CYAN "Applying minimal configuration for 42...\n"

log $CATEGORY "Keyboard and mouse"
log $STEP "    Right-click"
defaults write com.apple.driver.AppleHIDMouse Button2 -int 2
log $STEP "    Mouse speed"
defaults write -g com.apple.mouse.scaling 3
log $STEP "    Disable natural scrolling"
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
log $STEP "    Disable smart quotes and dashes"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
log $STEP "    Disable automatic text replacement"
defaults write NSGlobalDomain NSAutomaticTextReplacementEnabled -bool false
log $STEP "    Disable auto-correct and spell check"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g WebContinuousSpellCheckingEnabled -bool false
log $STEP "    Key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 0
log $CATEGORY "System"
log $STEP "    Remove 'Are you sure you want to open this application?'"
defaults write com.apple.LaunchServices LSQuarantine -bool false
log $STEP "    Ask for password when locking session"
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
log $CATEGORY "Finder"
log $STEP "    Use \$HOME as start directory"
defaults write com.apple.finder NewWindowTarget -string "PfHm"
log $STEP "    Show hidden files"
defaults write com.apple.finder AppleShowAllFiles -bool true
log $STEP "    Show filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
log $STEP "    Disable extension change warning"
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

log $CYAN "\nOK! Please relog for changes to take effect."
