#!/usr/bin/env bash
#
# AUTHORS, LICENSE and DOCUMENTATION
#
export TRACE_ID=$(uuidgen | tr -d '-' | tr '[:upper:]' '[:lower:]')
export PARENT_SPAN_ID=""

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/otel_init.sh"
# source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/otel_trace_exporter.sh"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/otel_trace_schema.sh"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/log.sh"

#######################################
# Print a given string
# GLOBALS:
#   A_STRING_PREFIX
# ARGUMENTS:
#   String to print
# OUTPUTS:
#   Write String to stdout
# RETURN:
#   0 if print succeeds, non-zero on error.
#######################################
otel_trace_start_parent_span() {
	local name=$1
	local span_id=$(uuidgen | tr -d '-' | tr '[:upper:]' '[:lower:]')

	local start_time_unix_nano=$(date +%s)
	"$@"
	local end_time_unix_nano=$(date +%s)
	local exit_status=$?

	if [ $resource_attributes_arr ]; then
		for attr in "${resource_attributes_arr[@]}"; do
			otel_trace_add_string_resource_attrib "${attr%%:*}" "${attr#*:}"
		done
	fi

	# otel_trace_add_string_resource_attrib "service.namespace" "${name}"
	# otel_trace_add_int_resource_attrib "service.foo" 100

	# log_info "Passing ${name} ${TRACE_ID} ${span_id:0:16} ${parent_span_id} ${start_time_unix_nano} ${end_time_unix_nano} ${exit_status}"
	otel_trace_add_resource_scopespans_span $name \
		$TRACE_ID \
		${span_id:0:16} \
		"" \
		$start_time_unix_nano \
		$end_time_unix_nano \
		$exit_status

	if [[ $OTEL_LOG_LEVEL == "debug" ]]; then
		log_info "traceId: ${TRACE_ID}"
		log_info "spanId: ${span_id:0:16}"
		log_info "parentSpanId: ${PARENT_SPAN_ID}"
		log_info "OTEL_EXPORTER_OTEL_ENDPOINT=${OTEL_EXPORTER_OTEL_ENDPOINT}"
		log_info "curl -ik -X POST -H 'Content-Type: application/json' -d ${otel_trace_resource_spans} ${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces"
		# curl -ik -X POST -H 'Content-Type: application/json' -d "${json}" "${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces" 
	else
		log_info "curling ${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces"
		# curl -ik -X POST -H 'Content-Type: application/json' -d "${json}" "${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces" -o /dev/null -s
	fi

	PARENT_SPAN_ID=${span_id:0:16}
}

#######################################
# Print a given string
# GLOBALS:
#   A_STRING_PREFIX
# ARGUMENTS:
#   String to print
# OUTPUTS:
#   Write String to stdout
# RETURN:
#   0 if print succeeds, non-zero on error.
#######################################
otel_trace_start_child_span() {
	local name=$1
	local span_id=$(uuidgen | tr -d '-' | tr '[:upper:]' '[:lower:]')

	local start_time_unix_nano=$(date +%s)
	"$@"
	local end_time_unix_nano=$(date +%s)
	local exit_status=$?

	# otel_trace_add_string_resource_attrib "service.namespace" "${name}"
	# otel_trace_add_int_resource_attrib "service.foo" 100

	# log_info "Passing ${name} ${TRACE_ID} ${span_id:0:16} ${parent_span_id} ${start_time_unix_nano} ${end_time_unix_nano} ${exit_status}"
	otel_trace_add_resource_scopespans_span $name \
		$TRACE_ID \
		${span_id:0:16} \
		$PARENT_SPAN_ID \
		$start_time_unix_nano \
		$end_time_unix_nano \
		$exit_status

	if [[ $OTEL_LOG_LEVEL == "debug" ]]; then
		log_info "traceId: ${TRACE_ID}"
		log_info "spanId: ${span_id:0:16}"
		log_info "parentSpanId: ${PARENT_SPAN_ID}"
		log_info "OTEL_EXPORTER_OTEL_ENDPOINT=${OTEL_EXPORTER_OTEL_ENDPOINT}"
		log_info "curl -ik -X POST -H 'Content-Type: application/json' -d ${otel_trace_resource_spans} ${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces"
		# curl -ik -X POST -H 'Content-Type: application/json' -d "${json}" "${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces" 
	else
		log_info "curling ${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces"
		# curl -ik -X POST -H 'Content-Type: application/json' -d "${json}" "${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces" -o /dev/null -s
	fi

	PARENT_SPAN_ID=${span_id:0:16}
}
