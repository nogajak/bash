#!/bin/bash

current_date=$(date +'%Y-%m-%d %H:%M:%S')

# Logging to stdout with actual date
# 
# @param string: Message to log
function log_info(){ 
    echo "$current_date: $@"; 
}

# Logging to stderr with actual date
# 
# @param string: Message to log
function log_err(){ 
    >&2 echo "$current_date: $@"; 
}