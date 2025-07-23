#!/bin/bash

# Stop Pure Data patch
pkill -f "pd.*main.pd"

# Stop Flask service
sudo systemctl stop asabox-web.service

# Wait briefly to let processes terminate cleanly
sleep 2

# Shutdown the Pi safely
sudo shutdown -h now
