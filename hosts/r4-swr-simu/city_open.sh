#!/bin/bash
export DISPLAY=:0
systemctl stop ue4_forest.service
systemctl restart ue4_city.service
wmctrl -r "Parrot-Sphinx-App (64-bit Development SF_VULKAN_SM5)" -b add,belo
systemctl restart sphinx.service
/home/me/reload_videos.sh
systemctl restart gst-reencoder-simu.service
systemctl restart gst-reencoder-real.service
