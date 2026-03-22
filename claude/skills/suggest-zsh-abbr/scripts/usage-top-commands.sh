#!/bin/bash -e

# This script analyzes the command usage logs and displays commands executed 2 or more times.
shopt -s nullglob
log_files=(~/.cache/shell/command-usage-*.log)

if [ ${#log_files[@]} -eq 0 ]; then
  echo "No command usage logs found."
  exit 0
fi

awk -F'\t' '{print $2}' "${log_files[@]}" | sort | uniq -c | awk '$1 >= 2' | sort -nr | head -100
