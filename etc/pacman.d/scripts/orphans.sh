#!/bin/sh

pacman -Rs $(pacman -Qqdt) --noconfirm 2> /dev/null
exit 0
