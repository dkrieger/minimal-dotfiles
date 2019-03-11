#!/bin/bash
[ -d "$HOME/.kubectx" ] && exit 0
git clone https://github.com/ahmetb/kubectx.git "$HOME/.kubectx"

COMPDIR=$(pkg-config --variable=completionsdir bash-completion)
sudo ln -sf "$HOME/.kubectx/completion/kubens.bash" "$COMPDIR/kubens"
sudo ln -sf "$HOME/.kubectx/completion/kubectx.bash" "$COMPDIR/kubectx"
