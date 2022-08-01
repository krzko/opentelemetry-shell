#!/usr/bin/env bash

# Copyright 2022 Krzysztof Kowalski

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     https://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# https://opentelemetry.io/docs/reference/specification/metrics/datamodel/

. "${OTEL_SH_LIB_PATH}/log.sh"
. "${OTEL_SH_LIB_PATH}/net.sh"
. "${OTEL_SH_LIB_PATH}/time.sh"

. "${OTEL_SH_LIB_PATH}/otel_init.sh"
. "${OTEL_SH_LIB_PATH}/otel_metrics_schema.sh"

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

	if [ -n "${custom_resource_attributes-}" ]; then
    log_debug "Appending custom resource attributes"
		for attr in "${custom_resource_attributes[@]}"; do
			otel_metrics_add_resourcemetrics_resource_attrib_string "${attr%%:*}" "${attr#*:}"
		done
	fi

otel_metrics_add_gauge "$name" \
		"$description" \
		"$unit"

  if [[ ${type} == "double" ]]; then
    otel_metrics_add_gauge_datapoint_double "$key" \
      "$value" \
      "$as_value"
  elif [[ ${type} == "int" ]]; then
    otel_metrics_add_gauge_datapoint_int "$key" \
      "$value" \
      "$as_value"
  else
    log_error "'as_value' arg needs to be double|int"
    exit 1
  fi

  if [ -z $"{OTEL_LOG_LEVEL-}" ]; then
    net_client_post "${otel_metrics_resource_metrics}" "${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/metrics"
	else
    log_debug "[$( caller )] $*" >&2
    log_debug "BASH_SOURCE: ${BASH_SOURCE[*]}"
    log_debug "BASH_LINENO: ${BASH_LINENO[*]}"
    log_debug "FUNCNAME: ${FUNCNAME[*]}"

		log_debug "name: ${name}"
		log_debug "key: ${key}"
		log_debug "value: ${value}"
		log_debug "OTEL_EXPORTER_OTEL_ENDPOINT=${OTEL_EXPORTER_OTEL_ENDPOINT}"
    net_client_post "${otel_metrics_resource_metrics}" "${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/metrics"
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

  if [ "$custom_resource_attributes" ]; then
		for attr in "${custom_resource_attributes[@]}"; do
			otel_metrics_add_resourcemetrics_resource_attrib_string "${attr%%:*}" "${attr#*:}"
		done
	fi

otel_metrics_add_gauge "$name" \
		"$description" \
		"$unit"

  if [[ ${type} == "double" ]]; then
    otel_metrics_add_sum_datapoint_double "$key" \
      "$value" \
      "$as_value" \
      "$start_time_unix_nano"
  elif [[ ${type} == "int" ]]; then
    otel_metrics_add_sum_datapoint_int "$key" \
      "$value" \
      "$as_value" \
      "$start_time_unix_nano"
  else
    log_error "'as_value' arg needs to be double|int"
    exit 1
  fi

  if [ -z "${OTEL_LOG_LEVEL-}" ]; then
    net_client_post "${otel_metrics_resource_metrics}" "${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/metrics"
	else
    log_debug "[$( caller )] $*" >&2
    log_debug "BASH_SOURCE: ${BASH_SOURCE[*]}"
    log_debug "BASH_LINENO: ${BASH_LINENO[*]}"
    log_debug "FUNCNAME: ${FUNCNAME[*]}"

		log_debug "name: ${name}"
		log_debug "key: ${key}"
		log_debug "value: ${value}"
    net_client_post "${otel_metrics_resource_metrics}" "${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/metrics"
	fi
}
