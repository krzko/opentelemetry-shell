#!/usr/bin/env bash

source ../library/log.sh
source ../library/otel_trace.sh

function curl_httpbin_200 {
  log_info "curl httpbin 200"
  curl -X GET "https://httpbin.org/status/200" -H  "accept: text/plain"
}

function curl_httpbin_201 {
  log_info "curl httpbin - 201"
  curl -X GET "https://httpbin.org/status/201" -H  "accept: text/plain"
}

trace_parent curl_httpbin_200

trace_child curl_httpbin_201

log_info "TraceId ${TRACE_ID}"
