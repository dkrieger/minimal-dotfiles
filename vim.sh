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
	sudo dnf install -y vim-common vim-X11
	<<'EOF' sudo tee -a /usr/local/bin/vim
#!/bin/bash
gvim --servername GVIM -v $@
EOF
elif [[ "$DISTRO" == "Ubuntu" ]]; then
	sudo add-apt-repository ppa:jonathonf/vim
	sudo apt-get update
	sudo apt-get install -y vim
else
	printf "$DISTRO not supported\n" >&2
	exit 1
fi
ln -s "$(pwd)/vimrc" ~/.vimrc

