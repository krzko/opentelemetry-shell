#!/usr/bin/env bash
#
# AUTHORS, LICENSE and DOCUMENTATION
#

resource_attributes_arr=(
  "environment:dev"
  "team:ops"
  "support:#ops-support"
)

service_version="0.0.1-dev"

source ../library/log.sh
source ../library/otel_trace.sh
source ../library/uuid.sh

curl_httpbin_200() {
  log_info "curl -X GET https://httpbin.org/status/200 -H  'accept: text/plain'"
  curl -X GET "https://httpbin.org/status/200" -H  "accept: text/plain"
}

curl_httpbin_201() {
  log_info "curl -X GET https://httpbin.org/status/201 -H  'accept: text/plain'"
  curl -X GET "https://httpbin.org/status/201" -H  "accept: text/plain"
}

otel_trace_start_parent_span curl_httpbin_200

otel_trace_start_child_span curl_httpbin_201

log_info "TraceId ${TRACE_ID}"
log_info "ParentSpanId: ${PARENT_SPAN_ID}"
