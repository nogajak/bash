#!/bin/bash

########## LOAD SNIPPETS ##########

PATH=$PATH:./../snippets
source logging.sh

########## HELPERS ##########

function getHelp(){
    cat <<helpText
    Purpose:
        This script is designed to insert key:value into redis or SCAN redis data for specific character.

    Options: 
        Required:
            scan 
            insert

    Usage 
        ${0} [required]
helpText
}

function insert() {
    # Počet klíčů, které chceme vytvořit
    num_keys=1000

    # Funkce pro generování náhodného řetězce
    generate_random_string() {
        length=$1
        # Generování náhodného řetězce dané délky
        tr -dc A-Za-z0-9 </dev/urandom | head -c $length
    }

    # Vytváření klíčů a jejich ukládání do Redis
    for ((i=1; i<=num_keys; i++)); do
        key="key_$(generate_random_string 8)"
        value="value_$(generate_random_string 16)"
        
        # Uložení klíče a hodnoty do Redis
        log_info "Saving $value into $key" 
        redis-cli SET "$key" "$value"
    done

    echo "Inserted $num_keys random key:value pairs into Redis."
}

function scan() {
    # Iterujeme přes všechny klíče pomocí SCAN
    cursor=0
    while true; do
        # Získáme batch klíčů pomocí SCAN
        result=$(redis-cli SCAN $cursor)
        
        # Rozdělíme výsledek na cursor a klíče
        cursor=$(echo "$result" | head -n 1)
        keys=$(echo "$result" | tail -n +2)

        # Pro každý klíč získáme jeho hodnotu a zkontrolujeme obsah
        for key in $keys; do
            value=$(redis-cli GET "$key")
            
            log_info "Checking value $value for key $key"
            # Zkontrolujeme, zda hodnota obsahuje neplatný znak '�'
            if [[ $value == *'�'* ]]; then
                log_info "Key: $key contains invalid character"
                exit 0
            fi
        done

        # Pokud je cursor 0, procházení je hotové
        if [ "$cursor" == "0" ]; then
            break
        fi
    done
}


########## MAIN ##########

# Main
if (( $# == 0 )); then

    getHelp

else

    case $1 in
        insert)
            insert
            ;;
        scan)
            scan
            ;;
        *)
            getHelp
            exit 1
            ;;
    esac

fi