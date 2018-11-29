# Minimal Dotfiles

Bootstrap unixy environments to the degree of customization required.

Rather than one big "bootstrap.sh" script, each program has a modular setup
routine, allowing e.g. utility servers to run a more minimal setup than a
workstation.

NOTE: Out of the box, only Ubuntu-based distributions support all bootstrapping
features of these dotfiles.

## Programs / Utilities

- bash
- tmux
- vim
- powerline
- [st](https://st.suckless.org/)
- misc tools
    - tree
    - ack
    - (etc.)

## Usage

- if there is a script with the program name (e.g. "bash.sh", "vim.sh"), run it
  to install it and bootstrap settings
- if there is a dotfile but no shell script for a program, put it in the right
  location however you prefer (symbolic link via `ln -s` recommended)

### bashrc-parts

1. navigate to bashrc-parts/
2. `enable.sh <part1> [<part2> ...]` to enable parts
3. `disable.sh <part1> [<part2> ...]` to disable parts

## TODO

- break vim up into parts
  - ultraminimal (no plugins)
  - minimal (basic plugins)
  - maximal (all the plugins I like)
- enable debian compatibility
- become distro-agnostic
  - ansible eventually
