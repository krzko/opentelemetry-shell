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

. "${OTEL_SH_LIB_PATH}/log.sh"
. "${OTEL_SH_LIB_PATH}/net.sh"
. "${OTEL_SH_LIB_PATH}/time.sh"
. "${OTEL_SH_LIB_PATH}/uuid.sh"

. "${OTEL_SH_LIB_PATH}/otel_init.sh"
. "${OTEL_SH_LIB_PATH}/otel_traces_detector.sh"
. "${OTEL_SH_LIB_PATH}/otel_traces_schema.sh"


if [ -z "${OTEL_TRACE_ID-}" ]; then
  export OTEL_TRACE_ID=$(generate_uuid 16)
fi

export PARENT_SPAN_ID=""

#######################################
# Starts a new parent trace bound to the OTEL_TRACE_ID
# GLOBALS:
#   OTEL_TRACE_ID
#   PARENT_SPAN_ID
# ARGUMENTS:
#   name of calling command/function
# OUTPUTS:
#   Write to stdout via ConsoleExporter
#   Curl to OTLP (HTTP) Receiver
# RETURN:
#   0 if curl succeeds, non-zero on error.
#######################################
otel_trace_start_parent_span() {
	local name=$1
	local span_id=$(generate_uuid 8)

	local start_time_unix_nano=$(get_epoch_now)
  local exit_code=0
	"$@" && exit_code=$? || exit_code=$?
  # { local capture=$( { { "$@" && exit_code=$? ; } 1>&3 ; } 2>&1); } 3>&1
  log_debug "Command: ${*} Errorlevel: ${exit_code}"
	local end_time_unix_nano=$(get_epoch_now)

	if [ -n "${custom_resource_attributes-}" ]; then
    log_debug "Appending custom resource attributes"
		for attr in "${custom_resource_attributes[@]}"; do
			otel_trace_add_resourcespan_resource_attrib_string "${attr%%:*}" "${attr#*:}"
		done
	fi

  if [ -n "${detector_resource_attributes-}" ]; then
    log_debug "Appending detector resource attributes"
		for attr in "${detector_resource_attributes[@]}"; do
			otel_trace_add_resourcespan_resource_attrib_string "${attr%%:*}" "${attr#*:}"
		done
	fi

	otel_trace_add_resource_scopespans_span "$name" \
		"$OTEL_TRACE_ID" \
		"$span_id" \
		"$span_id" \
		"$start_time_unix_nano" \
		"$end_time_unix_nano" \
		"$exit_code"

  otel_trace_add_resourcespan_scopespans_spans_attrib_string "command" "$*"
  otel_trace_add_resourcespan_scopespans_spans_attrib_string "errorlevel" "${exit_code}"
  otel_trace_add_resourcespan_scopespans_spans_attrib_string "code.url" "${PWD}/${0##*/}#L${BASH_LINENO[0]}"

  if [ -z "${FUNCNAME-}" ]; then
		otel_trace_add_resourcespan_scopespans_spans_attrib_string "function" "${FUNCNAME[1]}()"
	fi

  if [ -z "${OTEL_LOG_LEVEL-}" ]; then
		log_debug "curling ${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces"
    net_client_post "${otel_trace_resource_spans}" "${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces"
	else
    log_debug "[$( caller )] $*" >&2
    log_debug "BASH_SOURCE: ${BASH_SOURCE[*]}"
    log_debug "BASH_LINENO: ${BASH_LINENO[*]}"
    log_debug "FUNCNAME: ${FUNCNAME[*]}"

		log_debug "traceId: ${OTEL_TRACE_ID}"
		log_debug "spanId: ${span_id}"
		log_debug "parentSpanId: ${PARENT_SPAN_ID}"
    net_client_post "${otel_trace_resource_spans}" "${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces"
	fi

	if [ $exit_code -ne 0 ]; then
		log_fatal "Exiting with Errorlevel: ${exit_code}"
    exit $exit_code
	fi

	PARENT_SPAN_ID=${span_id}
}

#######################################
# Starts a new child trace bound to the OTEL_TRACE_ID and PARENT_SPAN_ID
# GLOBALS:
#   OTEL_TRACE_ID
#   PARENT_SPAN_ID
# ARGUMENTS:
#   name of calling command/function
# OUTPUTS:
#   Write to stdout via ConsoleExporter
#   Curl to OTLP (HTTP) Receiver
# RETURN:
#   0 if curl succeeds, non-zero on error.
#######################################
otel_trace_start_child_span() {
	local name=$1
	local span_id=$(generate_uuid 8)

	local start_time_unix_nano=$(get_epoch_now)
  local exit_code=0
	"$@" && exit_code=$? || exit_code=$?
  # { local capture=$( { { "$@" && exit_code=$? ; } 1>&3 ; } 2>&1); } 3>&1
  log_debug "Command: ${*} Errorlevel: ${exit_code}"
	local end_time_unix_nano=$(get_epoch_now)

	if [ -n "${custom_resource_attributes-}" ]; then
    log_debug "Appending custom resource attributes"
		for attr in "${custom_resource_attributes[@]}"; do
			otel_trace_add_resourcespan_resource_attrib_string "${attr%%:*}" "${attr#*:}"
		done
	fi

  if [ -n "${detector_resource_attributes-}" ]; then
    log_debug "Appending detector resource attributes"
		for attr in "${detector_resource_attributes[@]}"; do
			otel_trace_add_resourcespan_resource_attrib_string "${attr%%:*}" "${attr#*:}"
		done
	fi

	otel_trace_add_resource_scopespans_span "$name" \
		"$OTEL_TRACE_ID" \
		"$span_id" \
		"$PARENT_SPAN_ID" \
		"$start_time_unix_nano" \
		"$end_time_unix_nano" \
		"$exit_code"

  otel_trace_add_resourcespan_scopespans_spans_attrib_string "command" "$*"
  otel_trace_add_resourcespan_scopespans_spans_attrib_string "errorlevel" "${exit_code}"
  otel_trace_add_resourcespan_scopespans_spans_attrib_string "function" "${FUNCNAME[1]}()"

  if [ -z "${FUNCNAME-}" ]; then
		otel_trace_add_resourcespan_scopespans_spans_attrib_string "function" "${FUNCNAME[1]}()"
	fi

  otel_trace_add_resourcespan_scopespans_spans_attrib_string "code.url" "${PWD}/${0##*/}#L${BASH_LINENO[0]}"

  if [ -z "${OTEL_LOG_LEVEL-}" ]; then
    net_client_post "${otel_trace_resource_spans}" "${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces"
	else
    log_debug "[$( caller )] $*" >&2
    log_debug "BASH_SOURCE: ${BASH_SOURCE[*]}"
    log_debug "BASH_LINENO: ${BASH_LINENO[*]}"
    log_debug "FUNCNAME: ${FUNCNAME[*]}"

		log_debug "traceId: ${OTEL_TRACE_ID}"
		log_debug "spanId: ${span_id}"
		log_debug "parentSpanId: ${PARENT_SPAN_ID}"
		log_debug "OTEL_EXPORTER_OTEL_ENDPOINT=${OTEL_EXPORTER_OTEL_ENDPOINT}"
    net_client_post "${otel_trace_resource_spans}" "${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces"
	fi

  if [ "$exit_code" -ne 0 ]; then
		log_fatal "Exiting with Errorlevel: ${exit_code}"
    exit $exit_code
	fi

	PARENT_SPAN_ID=${span_id}
}
