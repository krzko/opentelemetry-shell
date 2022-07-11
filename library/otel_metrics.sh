#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/otel_init.sh"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/otel_metrics_schema.sh"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/log.sh"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/time.sh"

function otel_metrics_push_gauge {
	local name=$1
	local description=$2
  local unit=$3
	local key=$4
	local value=$5
	local as_int_value=$6

  local time_unix_namo=$(get_epoch_now)

  if [ $resource_attributes_arr ]; then
		for attr in "${resource_attributes_arr[@]}"; do
			otel_metrics_add_resourcemetrics_resource_attrib_string "${attr%%:*}" "${attr#*:}"
		done
	fi

  otel_metrics_add_gauge $name \
		$description \
		$unit

  otel_metrics_add_gauge_datapoint $key \
    $value \
    $as_int_value

  if [ -z ${OTEL_LOG_LEVEL-} ]; then
		log_info "curling ${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces"
		curl -ik -X POST -H 'Content-Type: application/json' -d "${otel_metrics_resource_metrics}" "${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/metrics" -o /dev/null -s
	else
    log_info "[$( caller )] $*" >&2
    log_info "BASH_SOURCE: ${BASH_SOURCE[*]}"
    log_info "BASH_LINENO: ${BASH_LINENO[*]}"
    log_info "FUNCNAME: ${FUNCNAME[*]}"

		log_info "name: ${name}"
		log_info "key: ${key}"
		log_info "value: ${value}"
		log_info "OTEL_EXPORTER_OTEL_ENDPOINT=${OTEL_EXPORTER_OTEL_ENDPOINT}"
		log_info "curl -ik -X POST -H 'Content-Type: application/json' -d ${otel_metrics_resource_metrics} ${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/metrics"
		curl -ik -X POST -H 'Content-Type: application/json' -d "${otel_metrics_resource_metrics}" "${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/metrics"
	fi
}
