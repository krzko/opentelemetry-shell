#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/log.sh"

log_info "Initialising OpenTelemetry Shell"

export UUID_TRACE_ID
export UUID_PARENT_SPAN_ID

export OS_VERSION=`uname -a`
export HOSTNAME=`hostname`

export TELEMETRY_SDK_NAME="opentelemetry.sh"
export TELEMETRY_SDK_LANG="bash"
export TELEMETRY_SDK_VER="0.0.1"

# OTEL_EXPORTER_OTLP_TRACES_ENDPOINT
# OTEL_EXPORTER_OTLP_METRICS_ENDPOINT
# OTEL_EXPORTER_OTLP_LOGS_ENDPOINT

if [[ -z $OTEL_EXPORTER_OTEL_ENDPOINT ]]; then
  log_error "OTEL_EXPORTER_OTEL_ENDPOINT not set"
  exit 1
fi
