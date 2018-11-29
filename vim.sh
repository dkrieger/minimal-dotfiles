#!/bin/bash
sudo add-apt-repository ppa:jonathonf/vim
sudo apt-get update
sudo apt-get install -y vim
ln -s "$(pwd)/vimrc" ~/.vimrc
