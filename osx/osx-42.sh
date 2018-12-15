#!/bin/sh

# ---------------------------------------------------------------------------- #
# @name          osx-42.sh
# @description   Configure OS X settings for 42 sessions
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
	tput setaf "$1"
	printf "$2\n"
}

# Log colors
STEP=$YELLOW
CATEGORY=$GREEN

# Script to configure a new session at 42.
# Don't run this script without reading it first!

# Based of these, plus some extra custom configuration:
# - https://github.com/mathiasbynens/dotfiles/blob/master/.osx
# - https://gist.github.com/brandonb927/3195465

# -----------------------------------------------------------------------------
# OSX preferences
# -----------------------------------------------------------------------------
log $CATEGORY "OSX preferences"

log $STEP "* Keyboard and mouse"
# Enable right-click
defaults write com.apple.driver.AppleHIDMouse Button2 -int 2
# Set mouse speed to 3
defaults write -g com.apple.mouse.scaling 3
# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
# Disable text replacement
defaults write NSGlobalDomain NSAutomaticTextReplacementEnabled -bool false
# Disable “natural” scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0
# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
# Disable spell checking
defaults write -g WebContinuousSpellCheckingEnabled -bool false
# Use U.S. international keyboard layout
defaults delete com.apple.HIToolbox AppleEnabledInputSources
defaults write com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID "com.apple.keylayout.USInternational-PC"
defaults write com.apple.HIToolbox AppleDefaultAsciiInputSource -array '<dict><key>InputSourceKind</key><string>KeyboardLayout</string><key>KeyboardLayoutID</key><integer>15000</integer><key>KeyboardLayoutName</key><string>USInternational-PC</string></dict>'
defaults write com.apple.HIToolbox AppleEnabledInputSources -array '<dict><key>InputSourceKind</key><string>KeyboardLayout</string><key>KeyboardLayoutID</key><integer>15000</integer><key>KeyboardLayoutName</key><string>USInternational-PC</string></dict>'
defaults write com.apple.HIToolbox AppleInputSourceHistory -array '<dict><key>InputSourceKind</key><string>KeyboardLayout</string><key>KeyboardLayoutID</key><integer>15000</integer><key>KeyboardLayoutName</key><string>USInternational-PC</string></dict>'
defaults write com.apple.HIToolbox AppleSelectedInputSources -array '<dict><key>InputSourceKind</key><string>KeyboardLayout</string><key>KeyboardLayoutID</key><integer>15000</integer><key>KeyboardLayoutName</key><string>USInternational-PC</string></dict>'
killall SystemUIServer

log $STEP "* User interface"
# Enable Dark mode
defaults write NSGlobalDomain AppleInterfaceStyle Dark
# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
# Increase window resize speed
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
# Expand save panel
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
# Disable Notification Center and remove the menu bar icon
launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

log $STEP "* Spotlight"
# Change indexing order and disable some search results
defaults write com.apple.spotlight orderedItems -array \
	'{"enabled" = 1;"name" = "APPLICATIONS";}' \
	'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
	'{"enabled" = 1;"name" = "DIRECTORIES";}' \
	'{"enabled" = 1;"name" = "PDF";}' \
	'{"enabled" = 1;"name" = "FONTS";}' \
	'{"enabled" = 0;"name" = "DOCUMENTS";}' \
	'{"enabled" = 0;"name" = "MESSAGES";}' \
	'{"enabled" = 0;"name" = "CONTACT";}' \
	'{"enabled" = 0;"name" = "EVENT_TODO";}' \
	'{"enabled" = 0;"name" = "IMAGES";}' \
	'{"enabled" = 0;"name" = "BOOKMARKS";}' \
	'{"enabled" = 0;"name" = "MUSIC";}' \
	'{"enabled" = 0;"name" = "MOVIES";}' \
	'{"enabled" = 0;"name" = "PRESENTATIONS";}' \
	'{"enabled" = 0;"name" = "SPREADSHEETS";}' \
	'{"enabled" = 0;"name" = "SOURCE";}' \
	'{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
	'{"enabled" = 0;"name" = "MENU_OTHER";}' \
	'{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
	'{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
	'{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
	'{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'


log $STEP "* System"
# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
# Disable Resume system-wide
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false
# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false
# Remove duplicates in the “Open With” menu
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user
# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true
# Set language and text formats
defaults write NSGlobalDomain AppleLanguages -array "en"
defaults write NSGlobalDomain AppleLocale -string "en_GB@currency=EUR"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true
# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0
# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# Disable hot corners
defaults write com.apple.dock wvous-tl-corner -int 0
defaults write com.apple.dock wvous-tr-corner -int 0
defaults write com.apple.dock wvous-bl-corner -int 0
defaults write com.apple.dock wvous-br-corner -int 0
# Use 12-hour time
defaults write NSGlobalDomain AppleICUForce12HourTime -bool true
# Disable AirDrop
defaults write com.apple.NetworkBrowser DisableAirDrop -bool YES
# Turn off WiFi
networksetup -setairportpower en1 off > /dev/null
# Hide all icons except clock and volume
for plist in ~/Library/Preferences/ByHost/com.apple.systemuiserver.*.plist
do
	defaults write $plist dontAutoLoad -array \
		"/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
		"/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
		"/System/Library/CoreServices/Menu Extras/User.menu" \
		"/System/Library/CoreServices/Menu Extras/AirPort.menu" \
		"/System/Library/CoreServices/Menu Extras/TextInput.menu"
done
defaults write com.apple.systemuiserver menuExtras -array \
	"/System/Library/CoreServices/Menu Extras/Volume.menu" \
	"/System/Library/CoreServices/Menu Extras/Clock.menu"
killall SystemUIServer

log $STEP "* Screenshots"
# Save screenshots to a inside ~/screenshots
mkdir -p $HOME/screenshots
defaults write com.apple.screencapture location -string "${HOME}/screenshots"
# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"
# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# -----------------------------------------------------------------------------
# OSX apps
# -----------------------------------------------------------------------------

log $CATEGORY "OSX Applications"

log $STEP "* Finder"
# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true
# Set ~ as the default location for new Finder windows
defaults write com.apple.finder NewWindowTarget -string "PfHm"
# Show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true
# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true
# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true
# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true
# Remove the spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0
# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
# Show item info near icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
# Show item info to the right of the icons on the desktop
/usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist
# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
# Increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
# Increase the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
# Use list view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false
# Empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true
# Show the ~/Library folder
chflags nohidden ~/Library
# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true
# Enable text selection in QuickLook
defaults write com.apple.finder QLEnableTextSelection -bool true

log $STEP "* Dock"
# Set the icon size of Dock items to 64 pixels
defaults write com.apple.dock tilesize -int 64
# Disable icon magnification
defaults write com.apple.dock largesize -float 64
# Change minimize/maximize window effect
defaults write com.apple.dock mineffect -string "scale"
# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true
# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true
# Wipe all (default) app icons from the Dock
defaults write com.apple.dock persistent-apps -array
# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool false
# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1
# Don’t group windows by application in Mission Control
# (i.e. use the old Exposé behavior instead)
defaults write com.apple.dock expose-group-by-app -bool false
# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true
# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true
# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true
# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false
# Set dock to bottom middle of the screen
defaults write com.apple.dock orientation -string "bottom"
defaults write com.apple.dock pinning -string middle

log $STEP "* Terminal"
# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

log $STEP "* Time Machine"
# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

log $STEP "* Activity Monitor"
# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
# Visualize CPU usage in the Activity Monitor Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5
# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0
# Mavericks: Add the "% CPU" column to the Disk and Network tabs
defaults write com.apple.ActivityMonitor "UserColumnsPerTab v4.0" -dict \
    '0' '( Command, CPUUsage, CPUTime, Threads, IdleWakeUps, PID, UID )' \
    '1' '( Command, anonymousMemory, Threads, Ports, PID, UID, ResidentSize )' \
    '2' '( Command, PowerScore, 12HRPower, AppSleep, graphicCard, UID )' \
    '3' '( Command, bytesWritten, bytesRead, Architecture, PID, UID, CPUUsage )' \
    '4' '( Command, txBytes, rxBytes, txPackets, rxPackets, PID, UID, CPUUsage )'
# Mavericks: Sort by CPU usage in Disk and Network tabs
defaults write com.apple.ActivityMonitor UserColumnSortPerTab -dict \
    '0' '{ direction = 0; sort = CPUUsage; }' \
    '1' '{ direction = 0; sort = ResidentSize; }' \
    '2' '{ direction = 0; sort = 12HRPower; }' \
    '3' '{ direction = 0; sort = CPUUsage; }' \
    '4' '{ direction = 0; sort = CPUUsage; }'
# Update every 1 second
defaults write com.apple.ActivityMonitor UpdatePeriod -int 1
# Mavericks: Show Data in the Disk graph (instead of IO)
defaults write com.apple.ActivityMonitor DiskGraphType -int 1
# Mavericks: Show Data in the Network graph (instead of packets)
defaults write com.apple.ActivityMonitor NetworkGraphType -int 1

log $STEP "* Archive Utility"
# Move archives to trash after extracting
defaults write com.apple.archiveutility "dearchive-move-after" -string "~/.Trash"

log $STEP "* TextEdit"
# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0
# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

log $STEP "* Photos"
# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

log $STEP "* Safari"
# Prevent "Try the new Safari" notification
defaults write com.apple.coreservices.uiagent CSUIHasSafariBeenLaunched -bool YES
defaults write com.apple.coreservices.uiagent CSUIRecommendSafariNextNotificationDate -date 2050-01-01T00:00:00Z
defaults write com.apple.coreservices.uiagent CSUILastOSVersionWhereSafariRecommendationWasMade -float 10.99
# Prevent Safari from asking to be the default browser
defaults write com.apple.Safari DefaultBrowserDateOfLastPrompt -date '2050-01-01T00:00:00Z'
defaults write com.apple.Safari DefaultBrowserPromptingState -int 2
# Show status bar
defaults write com.apple.Safari ShowStatusBar -bool true
# Show tab bar
defaults write com.apple.Safari AlwaysShowTabBar -bool true
# Safari opens with: A new window
defaults write com.apple.Safari AlwaysRestoreSessionAtLaunch -bool false
# New windows open with: Empty Page
defaults write com.apple.Safari NewWindowBehavior -int 1
# New tabs open with: Empty Page
defaults write com.apple.Safari NewTabBehavior -int 1
# Homepage
defaults write com.apple.Safari HomePage -string "about:blank"
# Don't open "safe" files after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
# Open pages in tabs instead of windows: automatically
defaults write com.apple.Safari TabCreationPolicy -int 1
# Don't make new tabs active
defaults write com.apple.Safari OpenNewTabsInFront -bool false
# Command-clicking a link creates tabs
defaults write com.apple.Safari CommandClickMakesTabs -bool true
# Warn About Fraudulent Websites
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true
# Enable JavaScript
defaults write com.apple.Safari WebKitJavaScriptEnabled -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptEnabled -bool true
# Block pop-up windows
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false
# Do not track
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
# Don't even ask about the push notifications
defaults write com.apple.Safari CanPromptForPushNotifications -bool false

# -----------------------------------------------------------------------------
# Custom apps
# -----------------------------------------------------------------------------
log $CATEGORY "Custom application preferences"

log $STEP "* Google Chrome"
# Chrome: Allow installing user scripts via GitHub Gist or Userscripts.org
defaults write com.google.Chrome ExtensionInstallSources -array "https://gist.githubusercontent.com/" "http://userscripts.org/*"
defaults write com.google.Chrome.canary ExtensionInstallSources -array "https://gist.githubusercontent.com/" "http://userscripts.org/*"

log $STEP "* Skype"
# Don't collapse chat view and sidebar
defaults write com.skype.skype AutoCollapseChatView -bool false
defaults write com.skype.skype AutoCollapseSidebar -bool false
# Show debug/webkit menus
defaults write com.skype.skype IncludeDebugMenu -bool true
defaults write com.skype.skype WebKitDeveloperExtras -bool true
# Disable that annoying welcome tour
defaults write com.skype.skype SKDisableWelcomeTour -bool true
defaults write com.skype.skype SKShowWelcomeTour -bool false
# Remove the dialpad when logging in
defaults write com.skype.skype ShowDialpadOnLogin -bool false
defaults write com.skype.skype DialpadOpen -bool false

log $STEP "* iTunes"
# Prevent iTunes from taking control of play button
launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist &> /dev/null

log $STEP "* Spotify"
# Prevent Spotify from sleeping (AppNap disable)
defaults write com.spotify.client NSAppSleepDisabled -bool YES

log $STEP "* iTerm 2"
# Import our predefined profile
defaults import com.googlecode.iterm2 iterm.plist
# Don’t display the annoying prompt when quitting iTerm
defaults write com.googlecode.iterm2 PromptOnQuit -bool false
defaults write com.googlecode.iterm2 PromptOnClose -bool false
# Dim only text, and use a custom amount
defaults write com.googlecode.iterm2 DimOnlyText -bool true
defaults write com.googlecode.iterm2 SplitPaneDimmingAmount 0.32
# Allow clipboard access to terminal apps
defaults write com.googlecode.iterm2 AllowClipboardAccess -bool true
# Opens files in new windows instead of a new tab
defaults write com.googlecode.iterm2 OpenFileInNewWindows -bool true

log $STEP "* XCode"
# Always use tabs for indenting
defaults write com.apple.dt.Xcode DVTTextIndentUsingTabs -bool true
# Show tab bar
defaults write com.apple.dt.Xcode AlwaysShowTabBar -bool true
