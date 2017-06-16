#!/bin/sh

orphans=$(pacman -Qqdt)
count=$(echo $orphans | wc -l)

if [ $count = "0" ]
then
	echo "=> removing $count orphans"
	pacman -Rs $(pacman -Qqdt) --noconfirm
fi
