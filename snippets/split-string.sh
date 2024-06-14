#!/bin/bash
# Split string by passed delimiter and return array with defined name
# 
# @param string: The input string to be split
# @param delimiter: The delimiter used for splitting the string
# @param array: The array to store the split elements
function stringToArray(){

    if [ "$#" -ne 3 ]; then
        echo "Usage: stringToArray <string> <delimiter> <array>"
        return 1
    fi

    local string="$1"
    local delimiter="$2"
    local -n array="$3"

    if [ -n "$delimiter" ]; then
        local IFS="$delimiter" read -ra array <<< "$string"
    else
        echo "Delimiter is empty, cannot split the string."
    fi

}