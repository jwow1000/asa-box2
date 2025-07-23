#!/bin/bash

# Stop Pure Data patch
ps aux | grep '[p]d.*pd/mother.pd' | awk '{print $2}' | xargs -r kill
