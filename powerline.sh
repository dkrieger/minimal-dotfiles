#!/bin/bash

#### BEGIN GUARD ####
# https://stackoverflow.com/a/1638397
# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")
if [[ $SCRIPTPATH != "$(pwd)" ]]; then
	printf "ERROR: script must be run from the directory it resides in\n" >&2
	exit 1
fi
#### END GUARD ####

DISTRO="$(</etc/os-release awk -F'=' '$1~/^NAME$/ {print $2}')"
if [[ "$DISTRO" == "Fedora" ]]; then
	dnf check-update
	sudo dnf install -y python3 python3-pip powerline-fonts
elif [[ "$DISTRO" == "Ubuntu" ]]; then
	sudo apt-get update
	sudo apt-get install -y python3 python3-pip fonts-powerline
else
	printf "$DISTRO not supported\n" >&2
	exit 1
fi
pip3 install --user powerline-status powerline-gitstatus
pip3 install --user git+https://github.com/dkrieger/powerline-kubernetes.git
mkdir -p ~/.config/powerline/colorschemes
mkdir -p ~/.config/powerline/themes/shell
ln -f -s "$(pwd)/powerline/colorschemes/default.json" ~/.config/powerline/colorschemes/default.json
ln -f -s "$(pwd)/powerline/colorschemes/solarized.json" ~/.config/powerline/colorschemes/solarized.json
ln -f -s "$(pwd)/powerline/config.json" ~/.config/powerline/config.json
ln -f -s "$(pwd)/powerline/themes/shell/doug_default_leftonly.json" ~/.config/powerline/themes/shell/doug_default_leftonly.json
