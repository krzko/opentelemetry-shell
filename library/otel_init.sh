#!/usr/bin/env bash
#
# AUTHORS, LICENSE and DOCUMENTATION
#
set -eu -o pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/log.sh"

log_info "Initialising OpenTelemetry Shell"

export os_version=$(uname -a)
export hostname=$(hostname)

export telemetry_sdk_name="opentelemetry.sh"
export telemetry_sdk_lang="bash"
export telemetry_sdk_ver="0.0.1"

# OTEL_EXPORTER_OTLP_TRACES_ENDPOINT
# OTEL_EXPORTER_OTLP_METRICS_ENDPOINT
# OTEL_EXPORTER_OTLP_LOGS_ENDPOINT

if [ -z ${OTEL_EXPORTER_OTEL_ENDPOINT-} ]; then
  log_error "OTEL_EXPORTER_OTEL_ENDPOINT not exported"
  exit 1
fi
