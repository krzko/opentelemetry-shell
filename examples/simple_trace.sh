#!/usr/bin/env bash

# ${FUNCNAME[0]}
URL=$OTEL_EXPORTER_OTEL_ENDPOINT

source ../library/log.sh
source ../library/otel_trace.sh

function business_logic {
  echo "Doing some stuff.."
}

trace_parent business_logic

trace_child business_logic

log_info "TraceId ${UUID_TRACE_ID}"
