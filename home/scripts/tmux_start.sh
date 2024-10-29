#!/bin/bash
if tmux has-session 2>/dev/null; then
  exec tmux attach-session
else
  exec tmux new-session
fi
