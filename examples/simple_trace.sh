#!/usr/bin/env bash

# ${FUNCNAME[0]}

source ../library/log.sh
source ../library/otel_trace.sh

trace_parent foo_parent $OTEL_EXPORTER_OTEL_ENDPOINT

trace_child bar_child $OTEL_EXPORTER_OTEL_ENDPOINT

log_info "TraceId ${UUID_TRACE_ID}"
