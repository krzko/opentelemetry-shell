#!/usr/bin/env bash
#
# AUTHORS, LICENSE and DOCUMENTATION
#

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
otel_trace_resource_spans=$(cat <<EOF
{
  "resourceSpans": [
    {
      "resource": {
		"attributes":[
			{"key":"service.name","value":{"stringValue":"${0##*/}"}},
			{"key":"service.instance.id","value":{"stringValue":"${hostname}"}},
			{"key":"service.version","value":{"stringValue":"${service_version}"}},
			{"key":"telemetry.sdk.name","value":{"stringValue":"${telemetry_sdk_name}"}},
			{"key":"telemetry.sdk.language","value":{"stringValue":"${telemetry_sdk_lang}"}},
			{"key":"telemetry.sdk.version","value":{"stringValue":"${telemetry_sdk_ver}"}}
		]
	},
      "scopeSpans": [
        {
          "scope": {},
          "spans": []
        }
      ]
    }
  ]
}
EOF
)

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
otel_trace_add_string_resource_attrib() {
    local key="${1}"
    local value="${2}"

    
    local attribute=$(cat <<EOF
{
  "key": "${1}",
  "value": { "stringValue": "${2}" }
}
EOF
)

    otel_trace_resource_spans=$(jq -r ".resourceSpans[].resource.attributes += [$attribute]" <<< $otel_trace_resource_spans)
    
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
otel_trace_add_int_resource_attrib() {
    local key="${1}"
    local value=$2

    
    local attribute=$(cat <<EOF
{
  "key": "${1}",
  "value": { "intValue": $2 }
}
EOF
)

    otel_trace_resource_spans=$(jq -r ".resourceSpans[].resource.attributes += [$attribute]" <<< $otel_trace_resource_spans)
    
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
otel_trace_add_resource_scopespans_span() {
	# log_info "Using ${1} ${2} ${3} ${4} ${5} ${6} ${7}"

	local name=$1
	local trace_id=$2
    local span_id=$3
	local parent_span_id=$4
	local start_time_unix_nano=$5
    local end_time_unix_nano=$6
	local status_code=$7

	if [[ $status_code -eq 0 ]]; then
		status_code="STATUS_CODE_OK"
	else
		status_code="STATUS_CODE_ERROR"
	fi

    local span=$(cat <<EOF
{
  "traceId": "${trace_id}",
  "spanId": "${span_id}",
  "parentSpanId": "${parent_span_id}",
  "name": "${name}",
  "kind": "SPAN_KIND_INTERNAL",
  "startTimeUnixNano": "${start_time_unix_nano}",
  "endTimeUnixNano": "${end_time_unix_nano}",
  "attributes": [],
  "status": {
    "code": "${status_code}"
  }
}
EOF
)

    otel_trace_resource_spans=$(jq -r ".resourceSpans[].scopeSpans[].spans += [$span]" <<< $otel_trace_resource_spans)

	parent_span_id=$span_id
    
}
