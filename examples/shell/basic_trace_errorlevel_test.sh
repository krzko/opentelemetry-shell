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
export OTEL_SH_LIB_PATH="../../library"

# Import functions
. "${OTEL_SH_LIB_PATH}/otel_traces.sh"

# Functions
good() {
  local sec=$1

  log_info "Sleeping for ${sec} sec..."
  sleep $sec
}

bad() {
  local sec=$1

  log_info "Sleeping for ${sec} sec..."
  sleeeeeep $sec
}

# Main
otel_trace_start_parent_span good 1

otel_trace_start_child_span bad 2

log_info "TraceId: ${OTEL_TRACE_ID}"
