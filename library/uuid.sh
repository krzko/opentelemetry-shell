#!/usr/bin/env bash

# Copyright 2022 Krzysztof Kowalski

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     https://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
    # local length=$1

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
