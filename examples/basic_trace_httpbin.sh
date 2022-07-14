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

# Add resource attributes
# Use custom_resource_attributes specifically, opioninated
custom_resource_attributes=(
  "environment:dev"
  "team:ops"
  "support:#ops-support"
)

# Service variables
service_version="0.0.1-dev"

# Export library path
export OTEL_SH_LIB_PATH="../library"

# Import functions
. "${OTEL_SH_LIB_PATH}/log.sh"
. "${OTEL_SH_LIB_PATH}/otel_traces.sh"

# Functions
curl_httpbin() {
  local status=$1

  log_info "curl -X GET https://httpbin.org/status/${status} -H  'accept: text/plain'"
  curl -X GET "https://httpbin.org/status/${status}" -H  "accept: text/plain"
}

# Main
otel_trace_start_parent_span curl_httpbin 200

otel_trace_start_child_span curl_httpbin 201

otel_trace_start_child_span curl_httpbin 203

log_info "TraceId: ${TRACE_ID}"
