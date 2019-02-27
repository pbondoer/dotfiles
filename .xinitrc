#!/bin/sh
export LANG="en_US.UTF-8"

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps
if [ -f $sysresources ]; then
	xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
	xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
	xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
	xmodmap "$usermodmap"
fi

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# Set keyboard map
setxkbmap -model pc105 -layout us -variant intl
xset r rate 250 35

# Set background
export WALLPAPER=~/photo/magosleep.jpg
if [ -f $WALLPAPER ]; then
	hsetroot -fill $WALLPAPER
else
	hsetroot -solid "#000000FF"
fi

# optirun and primusrun optimization
export VGL_READBACK=pbo
export vblank_mode=0 # disable vsync

# Run desktop environment
# exec compton --config ~/.config/compton.conf --blur-kern 7x7box &
eval "$(ssh-agent)" &
exec dunst &
exec spectrwm
