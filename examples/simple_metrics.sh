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
source ../library/log.sh
source ../library/otel_metrics.sh

otel_metrics_push_gauge "ko.wal.ski/brain/memory/used_bytes" \
  "Memory usage in bytes." \
  "By" \
  "memory_type" \
  "evictable" \
  $RANDOM
