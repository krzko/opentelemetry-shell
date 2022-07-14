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
. "${OTEL_SH_LIB_PATH}/otel_metrics.sh"

# Gauge of type int, metric
log_info "Pushing metric ko.wal.ski/brain/memory/used_bytes..."
otel_metrics_push_gauge "ko.wal.ski/brain/memory/used_bytes" \
  "Memory usage in bytes." \
  "By" \
  "memory_type" \
  "evictable" \
  $RANDOM \
  int

# Gauge of type double, metric
log_info "Pushing metric ko.wal.ski/person/uptime..."
otel_metrics_push_gauge "ko.wal.ski/person/uptime" \
  "Uptime in seconds." \
  "s" \
  "person_name" \
  "foo" \
  88927.690019019 \
  double

# Check script errorlevel (success) using gauge of type int, metric
log_info "Checking errorlevel..."
if [ $? -eq 0 ]; then
  log_info "Pushing metric ko.wal.ski/${0##*/}/is_failed as 0"
  log_info "${0##*/} ran successfully"
  otel_metrics_push_gauge "ko.wal.ski/${0##*/}/is_failed" \
    "If the script was successful." \
    "By" \
    "hostname" \
    "${hostname}" \
    0 \
    int
else
  log_info "Pushing metric ko.wal.ski/${0##*/}/is_failed as 1"
  log_error "${0##*/} failed"
  otel_metrics_push_gauge "ko.wal.ski/${0##*/}/is_failed" \
    "If the script was successful." \
    "By" \
    "hostname" \
    "${hostname}" \
    1 \
    int
fi
