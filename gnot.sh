#!/bin/bash
# send a gnome desktop notification from bash saying command completed
# (arguments make up command name)
<<'EOF' sudo tee /usr/local/bin/gnot
#!/bin/bash
cmd="$@"
if [[ "$1" == "-m" ]]; then
  msg="$(<<<"$@" sed 's/-m//')"
  notify-send -a 'bash' -i utilities-terminal "Message:" "$msg"
  exit 0
fi
notify(){
  cmd="$1"
  result="$((( $2 > 0 )) && printf 'failed :(' || printf 'succeeded :D')"
  notify-send -a 'bash' -i utilities-terminal "Command $result" "$cmd"
}
eval "$cmd"
notify "$cmd" "$?"
EOF
sudo chmod +x /usr/local/bin/gnot
