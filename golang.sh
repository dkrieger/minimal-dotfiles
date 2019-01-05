#!/bin/bash
if [[ -f .golang.sh.didrun ]]; then
  printf "golang already set up. make sure $HOME/go/bin is in "'$PATH'"\n"
  exit 0
fi
mkdir -p build
cd build \
  && wget "https://dl.google.com/go/go1.11.2.linux-amd64.tar.gz" \
  && sudo tar -C /usr/local -xzf "go1.11.2.linux-amd64.tar.gz" \
  && printf 'export PATH="$PATH:/usr/local/go/bin"'"\n" >> "$HOME/.profile" \
  && cd .. \
  && touch .golang.sh.didrun
