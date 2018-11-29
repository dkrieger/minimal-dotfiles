#!/bin/bash

[[ -f .bash.sh.didrun ]] || cat "$(pwd)/bashrc-tail" >>"$HOME/.bashrc"
