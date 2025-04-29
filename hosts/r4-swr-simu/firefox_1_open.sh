#!/bin/bash
export DISPLAY=:0
xdotool search --class firefox-1 | tail -1 | xargs xdotool windowactivate
