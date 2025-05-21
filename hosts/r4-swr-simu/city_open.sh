#!/bin/bash
systemctl stop ue4_forest.service
systemctl restart ue4_city.service
systemctl restart anafi_bridge_real.service
systemctl restart anafi_bridge_simu.service
systemctl restart anafi_stream_real.service
systemctl restart anafi_stream_simu.service
systemctl restart mediamtx.service
systemctl restart sphinx.service
systemctl restart gst-reencoder-simu.service
systemctl restart gst-reencoder-real.service
