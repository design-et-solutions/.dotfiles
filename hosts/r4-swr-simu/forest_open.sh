#!/bin/bash
export DISPLAY=:0
systemctl stop ue4_city.service
systemctl restart ue4_forest.service
wmctrl -r "Parrot-Sphinx-App (64-bit Development SF_VULKAN_SM5)" -b add,belo
systemctl restart sphinx.service
/home/me/reload_videos.sh
systemctl restart gst-reencoder-simu.service
ssleep 15
sphinx-cli param -m world sky/sky preset daylight_verycloudy
sphinx-cli param -m world actors tags_name MyTag
sphinx-cli param -m world actors tags_location roof
sphinx-cli param -m world sky/sky environment/sun_intensity 1
sphinx-cli param -m world sky/sky environment/sky_light_intensity 0ystemctl restart gst-reencoder-real.service
