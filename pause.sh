#!/bin/sh
mkdir -p "$HOME/bin"
mkdir -p  buildpause
pushd buildpause
printf 'int main(){ pause(); }\n' > pause.c
make pause
mv pause "$HOME/bin/pause"
popd
rm -rf buildpause
