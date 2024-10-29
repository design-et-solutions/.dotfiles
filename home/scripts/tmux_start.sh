#!/usr/bin/env bash
if tmux has-session 2>/dev/null; then
  tmux attach-session
else
  tmux new-session
fi
