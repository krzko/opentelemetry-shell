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

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/log.sh"

#######################################
# Gets the Unix epoch timesyamp in nanoseconds
# GLOBALS:
#   EPOCHREALTIME
# OUTPUTS:
#   Write to stdout
#######################################
get_epoch_now() {
  local epoch=""

  if hash gdate 2>/dev/null; then
    if [ -z ${OTEL_LOG_LEVEL-} ]; then
      log_debug "Using gdate..."
    fi
    epoch="$(gdate +%s.%N)"
  elif [ ${EPOCHREALTIME} ]; then
    if [ -z ${OTEL_LOG_LEVEL-} ]; then
      log_debug 'Using $EPOCHREALTIME...'
    fi
    epoch=$EPOCHREALTIME
  else
    if [ -z ${OTEL_LOG_LEVEL-} ]; then
      log_debug "Using date..."
    fi
    epoch=$(date +%s%N)
  fi

  echo "${epoch//.}"
}
