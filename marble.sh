if [[ -f .marble.sh.didrun ]]; then
	printf "marble mouse scroll functionality already provisioned. remove .marble.sh.didrun and appropriate line from ~/.xinitrc to re-provision (e.g. if repo changed)\n"
else
	printf "gsettings set org.gnome.desktop.peripherals.trackball scroll-wheel-emulation-button 8\n" >>~/.xinitrc
fi
