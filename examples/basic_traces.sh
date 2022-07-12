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
. ../library/otel_trace.sh

# Functions
curl_httpbin() {
  local status=${1}

  log_info "curl -X GET https://httpbin.org/status/${status} -H  'accept: text/plain'"
  curl -X GET "https://httpbin.org/status/${status}" -H  "accept: text/plain"
}

# Main
otel_trace_start_parent_span curl_httpbin 200

otel_trace_start_child_span curl_httpbin 201

otel_trace_start_child_span curl_httpbin 202

log_info "TraceId: ${TRACE_ID}"
