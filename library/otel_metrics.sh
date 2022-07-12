#!/usr/bin/env bash
#
# AUTHORS, LICENSE and DOCUMENTATION
#

# https://opentelemetry.io/docs/reference/specification/metrics/datamodel/

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/otel_init.sh"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/otel_metrics_schema.sh"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/log.sh"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/time.sh"

#######################################
# Adds a span object into .resourceSpans[].scopeSpans[].spans array
# ARGUMENTS:
#  name of calling command/function
#  traceId, the top level Trace Id
#  spanId, the current Span Id
#  parentSpanId, the Id to asscociate the current span to
#  startTimeUnixNano, starting epoc time of the span
#  endTimeUnixNano, ending epoch time of the span
#######################################
function otel_metrics_push_gauge {
	local name=$1
	local description=$2
  local unit=$3
	local key=$4
	local value=$5
	local as_value=$6
  local type=$7

  local time_unix_namo=$(get_epoch_now)

  if [ $resource_attributes_arr ]; then
		for attr in "${resource_attributes_arr[@]}"; do
			otel_metrics_add_resourcemetrics_resource_attrib_string "${attr%%:*}" "${attr#*:}"
		done
	fi

otel_metrics_add_gauge $name \
		$description \
		$unit

  if [[ ${type} == "double" ]]; then
    otel_metrics_add_gauge_datapoint_double $key \
      $value \
      $as_value
  elif [[ ${type} == "int" ]]; then
    otel_metrics_add_gauge_datapoint_int $key \
      $value \
      $as_value
  else
    log_error "'as_value' arg needs to be double|int"
    exit 1
  fi

  if [ -z ${OTEL_LOG_LEVEL-} ]; then
		log_info "curling ${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/metrics"
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

#######################################
# Adds a span object into .resourceSpans[].scopeSpans[].spans array
# ARGUMENTS:
#  name of calling command/function
#  traceId, the top level Trace Id
#  spanId, the current Span Id
#  parentSpanId, the Id to asscociate the current span to
#  startTimeUnixNano, starting epoc time of the span
#  endTimeUnixNano, ending epoch time of the span
#######################################
function otel_metrics_push_sum {
	local name=$1
	local description=$2
  local unit=$3
	local key=$4
	local value=$5
	local as_value=$6
  local type=$7
  local start_time_unix_nano=$8

  local time_unix_namo=$(get_epoch_now)

  if [ $resource_attributes_arr ]; then
		for attr in "${resource_attributes_arr[@]}"; do
			otel_metrics_add_resourcemetrics_resource_attrib_string "${attr%%:*}" "${attr#*:}"
		done
	fi

otel_metrics_add_gauge $name \
		$description \
		$unit

  if [[ ${type} == "double" ]]; then
    otel_metrics_add_sum_datapoint_double $key \
      $value \
      $as_value \
      $start_time_unix_nano
  elif [[ ${type} == "int" ]]; then
    otel_metrics_add_sum_datapoint_int $key \
      $value \
      $as_value \
      $start_time_unix_nano
  else
    log_error "'as_value' arg needs to be double|int"
    exit 1
  fi

  if [ -z ${OTEL_LOG_LEVEL-} ]; then
		log_info "curling ${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/metrics"
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
