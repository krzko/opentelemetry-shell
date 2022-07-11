#!/usr/bin/env bash
#
# AUTHORS, LICENSE and DOCUMENTATION
#

# otel_trace_resource_spans stores the .resourceSpans[].resource.attributes[].
# This is the outer json schema
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
# Adds an object of type string into .resourceSpans[].resource.attributes[] array
# ARGUMENTS:
#   Key for the attribute
#   Value for the attribute
#######################################
otel_trace_add_resourcespan_resource_attrib_string() {
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
# Adds an object of type int into .resourceSpans[].resource.attributes[] array
# GLOBALS:
#   A_STRING_PREFIX
# ARGUMENTS:
#   Key for the attribute
#   Value for the attribute
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
# Adds a span object into .resourceSpans[].scopeSpans[].spans array
# ARGUMENTS:
#  name of calling command/function
#  traceId, the top level Trace Id
#  spanId, the current Span Id
#  parentSpanId, the Id to asscociate the current span to
#  startTimeUnixNano, starting epoc time of the span
#  endTimeUnixNano, ending epoch time of the span
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

  otel_trace_resource_spans=$(jq -r ".resourceSpans[].scopeSpans[-1].spans += [$span]" <<< $otel_trace_resource_spans)

	parent_span_id=$span_id
}

#######################################
# Adds an object of type string into .resourceSpans[].scopeSpans[].spans[].attributes
# ARGUMENTS:
#   Key for the attribute
#   Value for the attribute
#######################################
otel_trace_add_resourcespan_scopespans_spans_attrib_string() {
  local key="${1}"
  local value="${2}"

  local attribute=$(cat <<EOF
{
  "key": "${1}",
  "value": { "stringValue": "${2}" }
}
EOF
)

  otel_trace_resource_spans=$(jq -r ".resourceSpans[].scopeSpans[].spans[-1].attributes += [$attribute]" <<< $otel_trace_resource_spans)
}
