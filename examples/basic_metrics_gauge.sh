#!/usr/bin/env bash
#
# AUTHORS, LICENSE and DOCUMENTATION
#

# Add resource attributes
# Use custom_resource_attributes specifically, opioninated
custom_resource_attributes=(
  "environment:dev"
  "team:ops"
  "support:#ops-support"
)

# Service variables
service_version="0.0.1-dev"

# Import functions
. ../library/log.sh
. ../library/otel_metrics.sh

# Gauge of type int, metric
otel_metrics_push_gauge "ko.wal.ski/brain/memory/used_bytes" \
  "Memory usage in bytes." \
  "By" \
  "memory_type" \
  "evictable" \
  $RANDOM \
  int

# Gauge of type double, metric
otel_metrics_push_gauge "ko.wal.ski/person/uptime" \
  "Uptime in seconds." \
  "s" \
  "person_name" \
  "${USER}" \
  88927.690019019 \
  double

# Check script errorlevel (success) using gauge of type int, metric
if [ $? -eq 0 ]; then
  log_info "${0##*/} ran successfully"
  otel_metrics_push_gauge "ko.wal.ski/${0##*/}/is_failed" \
    "If the script was successful." \
    "By" \
    "hostname" \
    "${hostname}" \
    0 \
    int
else
  log_error "${0##*/} failed"
  otel_metrics_push_gauge "ko.wal.ski/${0##*/}/is_failed" \
    "If the script was successful." \
    "By" \
    "hostname" \
    "${hostname}" \
    1 \
    int
fi
