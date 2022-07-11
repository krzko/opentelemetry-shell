#!/usr/bin/env bash
#
# AUTHORS, LICENSE and DOCUMENTATION
#

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/otel_init.sh"
# source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/otel_trace_exporter.sh"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/otel_trace_schema.sh"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/log.sh"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/time.sh"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/uuid.sh"

export TRACE_ID=$(generate_uuid 16)
export PARENT_SPAN_ID=""

#######################################
# Starts a new parent trace bound to the TRACE_ID
# GLOBALS:
#   TRACE_ID
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
	"$@"
	local end_time_unix_nano=$(get_epoch_now)
	local exit_status=$?

	if [ $resource_attributes_arr ]; then
		for attr in "${resource_attributes_arr[@]}"; do
			otel_trace_add_resourcespan_resource_attrib_string "${attr%%:*}" "${attr#*:}"
		done
	fi

	# otel_trace_add_resourcespan_resource_attrib_string "service.namespace" "${name}"
	# otel_trace_add_int_resource_attrib "service.foo" 100

	# log_info "Passing ${name} ${TRACE_ID} ${span_id:0:16} ${parent_span_id} ${start_time_unix_nano} ${end_time_unix_nano} ${exit_status}"
  # "$*"
	otel_trace_add_resource_scopespans_span $name \
		$TRACE_ID \
		${span_id} \
		"" \
		$start_time_unix_nano \
		$end_time_unix_nano \
		$exit_status

	otel_trace_add_resourcespan_scopespans_spans_attrib_string "command" "$*"

  if [ -z ${OTEL_LOG_LEVEL-} ]; then
		log_info "curling ${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces"
		curl -ik -X POST -H 'Content-Type: application/json' -d "${otel_trace_resource_spans}" "${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces" -o /dev/null -s
	else
    log_info "[$( caller )] $*" >&2
    log_info "BASH_SOURCE: ${BASH_SOURCE[*]}"
    log_info "BASH_LINENO: ${BASH_LINENO[*]}"
    log_info "FUNCNAME: ${FUNCNAME[*]}"

		log_info "traceId: ${TRACE_ID}"
		log_info "spanId: ${span_id}"
		log_info "parentSpanId: ${PARENT_SPAN_ID}"
		log_info "OTEL_EXPORTER_OTEL_ENDPOINT=${OTEL_EXPORTER_OTEL_ENDPOINT}"
		log_info "curl -ik -X POST -H 'Content-Type: application/json' -d ${otel_trace_resource_spans} ${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces"
		curl -ik -X POST -H 'Content-Type: application/json' -d "${otel_trace_resource_spans}" "${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces"
	fi

	PARENT_SPAN_ID=${span_id}
}

#######################################
# Starts a new child trace bound to the TRACE_ID and PARENT_SPAN_ID
# GLOBALS:
#   TRACE_ID
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
	"$@"
	local end_time_unix_nano=$(get_epoch_now)
	local exit_status=$?

	# otel_trace_add_resourcespan_resource_attrib_string "service.namespace" "${name}"
	# otel_trace_add_int_resource_attrib "service.foo" 100

	# log_info "Passing ${name} ${TRACE_ID} ${span_id:0:16} ${parent_span_id} ${start_time_unix_nano} ${end_time_unix_nano} ${exit_status}"
	otel_trace_add_resource_scopespans_span $name \
		$TRACE_ID \
		${span_id} \
		$PARENT_SPAN_ID \
		$start_time_unix_nano \
		$end_time_unix_nano \
		$exit_status

  otel_trace_add_resourcespan_scopespans_spans_attrib_string "command" "$*"
  otel_trace_add_resourcespan_scopespans_spans_attrib_string "code.url" "${PWD}/${0##*/}#L${BASH_LINENO[0]}"
  otel_trace_add_resourcespan_scopespans_spans_attrib_string "function" "${FUNCNAME[1]}()"

  if [ -z ${OTEL_LOG_LEVEL-} ]; then
		log_info "curling ${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces"
		curl -ik -X POST -H 'Content-Type: application/json' -d "${otel_trace_resource_spans}" "${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces" -o /dev/null -s
	else
    log_info "[$( caller )] $*" >&2
    log_info "BASH_SOURCE: ${BASH_SOURCE[*]}"
    log_info "BASH_LINENO: ${BASH_LINENO[*]}"
    log_info "FUNCNAME: ${FUNCNAME[*]}"

		log_info "traceId: ${TRACE_ID}"
		log_info "spanId: ${span_id}"
		log_info "parentSpanId: ${PARENT_SPAN_ID}"
		log_info "OTEL_EXPORTER_OTEL_ENDPOINT=${OTEL_EXPORTER_OTEL_ENDPOINT}"
		log_info "curl -ik -X POST -H 'Content-Type: application/json' -d ${otel_trace_resource_spans} ${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces"
		curl -ik -X POST -H 'Content-Type: application/json' -d "${otel_trace_resource_spans}" "${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces"
	fi

	PARENT_SPAN_ID=${span_id}
}
