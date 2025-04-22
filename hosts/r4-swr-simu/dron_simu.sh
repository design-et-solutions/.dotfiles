#!/bin/bash

while true; do
    if ! timeout 2 ffprobe -v error -rtsp_transport tcp rtsp://localhost:8554/vivatech-simu | grep -q "Stream"; then
        echo "Simulation not responding, restarting..."
        sphinx-cli action -m world fwman world_reset_all
    fi
    sleep 20
done
