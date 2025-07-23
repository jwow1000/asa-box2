#!/bin/bash

# get the mode argument from command line
MODE=${1:-1}  # Default to 1

# Start in the asa-box2 repo directory
cd /home/asa-admin/asa-box2 || exit 1

# edit the .txt file for init mother.pd
echo "$MODE" > pd/boot-mode.txt

# Start the Pure Data patch
pd -nogui -noadc -alsa -audiooutdev 2 pd/mother.pd &
