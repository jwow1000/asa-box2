#!/bin/bash

# Start in bridge script directory (Python lifx bridge)
cd /home/asa-admin/asa-box2 || exit 1

# Start the Pure Data patch
pd -nogui -noadc -alsa -audiooutdev 2 pd/mother.pd &
