#!/usr/bin/env bash

# ${FUNCNAME[0]}

source ../library/log.sh
source ../library/otel_metrics.sh

send_count_metric send_count_metric $OTEL_EXPORTER_OTEL_ENDPOINT
