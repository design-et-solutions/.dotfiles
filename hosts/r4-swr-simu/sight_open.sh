#!/bin/bash
export DISPLAY=:0
xdotool search --name Form | tail -1 | xargs -r xdotool windowactivate
