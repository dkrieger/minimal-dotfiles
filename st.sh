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

chmod go= ~/.wget-hsts
git clone git://git.suckless.org/st
cd st
git checkout tags/0.7
# wget https://st.suckless.org/patches/delkey/st-delkey-0.7.diff
# git apply st-delkey-0.7.diff
wget https://st.suckless.org/patches/solarized/st-no_bold_colors-0.7.diff
git apply st-no_bold_colors-0.7.diff
wget https://st.suckless.org/patches/solarized/st-solarized-dark-0.7.diff
git apply st-solarized-dark-0.7.diff
DISTRO="$(</etc/os-release awk -F'=' '$1~/^NAME$/ {print $2}')"
if [[ "$DISTRO" == "Fedora" ]]; then
	sudo dnf install -y make libX11-devel libXft-devel
elif [[ "$DISTRO" == "Ubuntu" ]]; then
	sudo apt-get install -y x11-xserver-utils libx11-dev libxft-dev
else
	printf "$DISTRO not supported\n" >&2
	exit 1
fi
sudo make clean install
