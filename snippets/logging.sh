#!/bin/bash

current_date=$(date +'%Y-%m-%d %H:%M:%S')

function log_info(){ 
    echo "$current_date: $@"; 
}

function log_err(){ 
    >&2 echo "$current_date: $@"; 
}