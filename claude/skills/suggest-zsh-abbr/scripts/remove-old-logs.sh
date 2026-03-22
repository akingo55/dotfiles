#!/bin/bash -e

# Remove command usage logs older than 90 days
find ~/.cache/shell -name 'command-usage-*.log' -mtime +90 -delete
