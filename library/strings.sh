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

. "${OTEL_SH_LIB_PATH}/log.sh"

#######################################
# Returns a formatted strings and assigns back to variable
# ARGUMENTS:
#   str, the string
#   var, the vveriable to return to
# OUTPUTS:
#   Return to argument var
#######################################
return_spaces_to_dashes() {
    local str="$1"
    local var="$2"

    str=${str// /_}

    eval "$var=\$str"
}
