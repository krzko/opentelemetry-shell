#!/usr/bin/env bash
#
# AUTHORS, LICENSE and DOCUMENTATION
#

# Add resource attributes
# Use resource_attributes_arr specifically, opioninated
resource_attributes_arr=(
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
otel_metrics_push_sum "ko.wal.ski/script/usage_time" \
  "Script usuage time in seconds." \
  "s" \
  "time" \
  "latency" \
  "${RANDOM}.616987465" \
  double \
  "$(date +%s)000000000"
