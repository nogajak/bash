#!/bin/bash

########## LOAD SNIPPETS ##########

PATH=$PATH:./../snippets
source logging.sh

########## HELPERS ##########

function getHelp(){
    cat <<helpText
    Purpose:
        This script is designed to check if RabbitMQ node is running or not for keepalived VIP switch.

    Description:
        Script connect on the IP defined as first argument and on port defined in the second argument using nc tool.

    Options: 
        Required:
            -h   Host of the RabbitMQ node
            -p   Port of the RabbitMQ node

        Optional:

    Usage 
        ${0} [-avalue] [-a value]
helpText
}

########## VARS ##########

waitTimeout="5"
idleTimeout="5"

########## FUNC ##########

# Check of required parameters
function paramCheck(){

    if [[ -z "$host" ]]; then
        log_err "Error: Host (-h) is required"
        getHelp
        exit 1
    fi
    
    if [[ -z "$port" ]]; then
        log_err "Error: Port (-p) is required"
        getHelp
        exit 1
    fi

}

# Main function
function main(){
    if nc -zv -w $waitTimeout -i $idleTimeout $host $port &>/dev/null; then
    # curl http://127.0.0.1:15692/metrics &> /dev/null
        exit 0
    else
        exit 1
    fi
}

########## MAIN ##########

# Main
if (( $# == 0 )); then

    getHelp

else

    # Check if the first argument starts with a dash
    if [[ $1 != -* ]]; then
        log_err "Error: Arguments must start with a dash '-'"
        getHelp
        exit 1
    fi

    while getopts h:p: arguments; do
        case $arguments in
            h)
                host="$OPTARG"
                ;;
            p)
                port="$OPTARG"
                ;;
            *)
                getHelp
                exit 1
                ;;
        esac
    done

    paramCheck
    main

fi