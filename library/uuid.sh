#!/usr/bin/env bash

#######################################
# Generates a UUID based on a desired length
# GLOBALS:
#   RANDOM
# ARGUMENTS:
#   length, the length of the UUID to generate
# OUTPUTS:
#   Write to stdout
#######################################
generate_uuid()
{
    local length=$1

    local N B C='89ab'

    for (( N=0; N < $1; ++N ))
    do
        B=$(( $RANDOM%256 ))

        case $N in
            6)
                printf '4%x' $(( B%$1 ))
                ;;
            8)
                printf '%c%x' ${C:$RANDOM%${#C}:1} $(( B%$1 ))
                ;;
            3 | 5 | 7 | 9)
                # Add dashes '%02x-'
                printf '%02x' $B
                ;;
            *)
                printf '%02x' $B
                ;;
        esac
    done

    echo
}
