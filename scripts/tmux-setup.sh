#!/bin/bash

session_name=$1

tmux new-session -d -s "$session_name"

current_dir=$(pwd)

tmux rename-window -t "$session_name":1 "run"

# tmux new-window -t "$session_name":1 -n "run" -c "$current_dir"

tmux new-window -t "$session_name":2 -n "nvim" -c "$current_dir"
tmux send-keys -t "$session_name":2 "nvim ." C-m

tmux new-window -t "$session_name":3 -n "term2" -c "$current_dir"

tmux select-window -t "$session_name":1

tmux attach-session -t "$session_name"

