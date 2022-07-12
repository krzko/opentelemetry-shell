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

# Sum of type double, metric
otel_metrics_push_sum "ko.wal.ski/script/usage_time" \
  "Script usuage time in seconds." \
  "s" \
  "time" \
  "latency" \
  "${RANDOM}.616987465" \
  double \
  "$(date +%s)000000000"

# Check script errorlevel (success) using gauge of type int, metric
if [ $? -eq 0 ]; then
  log_info "${0##*/} ran successfully"
  otel_metrics_push_gauge "ko.wal.ski/script/is_failed" \
    "If the script was successful." \
    "By" \
    "script_name" \
    "${0##*/}" \
    0 \
    int
else
  log_error "${0##*/} failed"
  otel_metrics_push_gauge "ko.wal.ski/script/is_failed" \
    "If the script was successful." \
    "By" \
    "script_name" \
    "${0##*/}" \
    1 \
    int
fi
