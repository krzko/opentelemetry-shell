#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/log.sh"

log_info "Initialising OpenTelemtery Shell"

if [[ -z $OTEL_EXPORTER_OTEL_ENDPOINT ]]; then
  log_error "OTEL_EXPORTER_OTEL_ENDPOINT not set"
  exit 1
fi
