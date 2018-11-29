#!/bin/bash
sudo apt-get update
sudo apt-get install -y python3 python3-pip fonts-powerline
pip3 install powerline-status powerline-gitstatus
mkdir -p ~/.config/powerline/colorschemes
mkdir -p ~/.config/powerline/themes/shell
ln -f -s "$(pwd)/powerline/colorschemes/default.json" ~/.config/powerline/colorschemes/default.json
ln -f -s "$(pwd)/powerline/colorschemes/solarized.json" ~/.config/powerline/colorschemes/solarized.json
ln -f -s "$(pwd)/powerline/config.json" ~/.config/powerline/config.json
ln -f -s "$(pwd)/powerline/themes/shell/doug_default_leftonly.json" ~/.config/powerline/themes/shell/doug_default_leftonly.json
