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
# A net client with a POST method
# ARGUMENTS:
#  data, the data payload
#  url, the url to POST to
#######################################
net_client_post() {
  local data=$1
  local url=$2
  local response=""

  # local fail=$3 # --fail
  # local connect_timeout=$4 # --connect-timeout 3
  # local retry=$5 # --retry 0

  if [[ "$OTEL_EXPORTER_OTEL_ENDPOINT" = https* ]]; then
    log_debug "curl -ik -X POST -H 'Content-Type: application/json' -d ${data} ${url}"
    set +e
    response=$(curl --fail -ik -X POST -H 'Content-Type: application/json' -d "${data}" "${url}" -o /dev/null -s -w "%{http_code}")
    if [ $? -eq 0 ]; then
      log_info "POST ${response} ${url}"
    else
      log_error "The requested URL returned an error: ${url}"
    fi
  elif [[ "$OTEL_EXPORTER_OTEL_ENDPOINT" = http* ]]; then
    log_debug "curl -X POST -H 'Content-Type: application/json' -d ${data} ${url}"
    set +e
    response=$(curl --fail -X POST -H 'Content-Type: application/json' -d "${data}" "${url}" -o /dev/null -s -w "%{http_code}")
    if [ $? -eq 0 ]; then
      log_info "POST ${response} ${url}"
    else
      log_error "The requested URL returned an error: ${url}"
    fi
  else
    log_fatal "OTEL_EXPORTER_OTEL_ENDPOINT needs to include a http:// or https:// prefix"
    exit 1
  fi
}
