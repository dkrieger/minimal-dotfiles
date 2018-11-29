#!/bin/bash
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
sudo apt-get install -y x11-xserver-utils libx11-dev libxft-dev
sudo make clean install
