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

if [[ -f "$(pwd)/.bash.sh.didrun" ]]; then
	printf "bash already provisioned. remove .bash.sh.didrun and bashrc-tail section from ~/.bashrc to re-provision (e.g. if repo changed)\n"
else
	cat "$(pwd)/bashrc-tail" >>"$HOME/.bashrc"
	touch "$(pwd)/.bash.sh.didrun"
fi
