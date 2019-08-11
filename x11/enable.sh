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

enabled_dir="/etc/X11/xorg.conf.d"
mkdir -p "$enabled_dir"
for part in "$@"
do
	if [[ "$part" == *"/"* ]]; then
		printf "skipping $part (must reside in same dir as script and be referenced by filename only)\n" >&2
		continue
	fi

	ln -f -s "$(pwd)/$part" "$enabled_dir/$part" \
		&& printf "$part enabled\n"
done
