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

sudo add-apt-repository ppa:jonathonf/vim
sudo apt-get update
sudo apt-get install -y vim
ln -s "$(pwd)/vimrc" ~/.vimrc
