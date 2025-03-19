#!/usr/bin/env fish

set host $hostname
set shutdown '󰤆 Shutdown'
set reboot '󰃨 Reboot'
set suspend '󰤄 Suspend'
set yes '󰄬 Yes'
set no '󰅖 No'

function rofi_cmd
	rofi -dmenu \
		-p "$host" \
		-theme $HOME/.config/rofi/theme/menu_power/$THEME.rasi
end

function confirm_cmd
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 250px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?' \
		-theme $HOME/.config/rofi/theme/menu_power/$THEME.rasi
end

function confirm_exit
	echo -e "$yes\n$no" | confirm_cmd
end

function run_rofi
	echo -e "$suspend\n$reboot\n$shutdown" | rofi_cmd
end

function run_cmd
	set selected "$(confirm_exit)"
	if test "$selected" = "$yes"
        if test $argv[1] = "--shutdown"
			poweroff
        else if test $argv[1] = "--reboot"
			reboot
        else if test $argv[1] = "--suspend"
			hyprlock
        end
	else
		exit 0
    end
end

set chosen $(run_rofi)
switch $chosen
case $shutdown
    run_cmd --shutdown
case $reboot
    run_cmd --reboot
case $suspend
    run_cmd --suspend
end
