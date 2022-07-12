#!/usr/bin/env bash
#
# AUTHORS, LICENSE and DOCUMENTATION
#

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/time.sh"

# otel_trace_resource_spans stores the .resourceSpans[].resource.attributes[].
# This is the outer json schema
otel_metrics_resource_metrics=$(cat <<EOF
{
  "resourceMetrics": [
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
      "instrumentationLibraryMetrics": [
        {
          "instrumentationLibrary": {},
          "metrics": []
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
otel_metrics_add_resourcemetrics_resource_attrib_string() {
  local key="${1}"
  local value="${2}"

  local attribute=$(cat <<EOF
{
  "key": "${1}",
  "value": { "stringValue": "${2}" }
}
EOF
)

  otel_metrics_resource_metrics=$(jq -r ".resourceMetrics[].resource.attributes += [$attribute]" <<< $otel_metrics_resource_metrics)
}

#######################################
# Adds an object of type int into .resourceSpans[].resource.attributes[] array
# GLOBALS:
#   A_STRING_PREFIX
# ARGUMENTS:
#   Key for the attribute
#   Value for the attribute
#######################################
otel_metrics_add_resourcemetrics_resource_attrib_int() {
  local key="${1}"
  local value=$2

  local attribute=$(cat <<EOF
{
  "key": "${1}",
  "value": { "intValue": $2 }
}
EOF
)

  otel_metrics_resource_metrics=$(jq -r ".resourceMetrics[].resource.attributes += [$attribute]" <<< $otel_metrics_resource_metrics)
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
otel_metrics_add_gauge() {
	local name=$1
	local description=$2
  local unit=$3

  local obj=$(cat <<EOF
{
  "name": "${name}",
  "description": "${description}",
  "unit": "${unit}",
  "gauge": {
    "dataPoints": []
  }
}
EOF
)

  otel_metrics_resource_metrics=$(jq -r ".resourceMetrics[].instrumentationLibraryMetrics[-1].metrics += [$obj]" <<< $otel_metrics_resource_metrics)

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
otel_metrics_add_gauge_datapoint_int() {
	local key=$1
	local value=$2
	local as_value=$3
  local time_unix_nano=$(get_epoch_now)

  local obj=$(cat <<EOF
{
  "attributes": [
    {
      "key": "${key}",
      "value": {
        "stringValue": "${value}"
      }
    }
  ],
  "timeUnixNano": "${time_unix_nano}",
  "asInt": "${as_value}"
}
EOF
)

  otel_metrics_resource_metrics=$(jq -r ".resourceMetrics[].instrumentationLibraryMetrics[].metrics[-1].gauge.dataPoints += [$obj]" <<< $otel_metrics_resource_metrics)

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
otel_metrics_add_gauge_datapoint_double() {
	local key=$1
	local value=$2
	local as_value=$3
  local time_unix_nano=$(get_epoch_now)

  local obj=$(cat <<EOF
{
  "attributes": [
    {
      "key": "${key}",
      "value": {
        "stringValue": "${value}"
      }
    }
  ],
  "timeUnixNano": "${time_unix_nano}",
  "asDouble": ${as_value}
}
EOF
)

  otel_metrics_resource_metrics=$(jq -r ".resourceMetrics[].instrumentationLibraryMetrics[].metrics[-1].gauge.dataPoints += [$obj]" <<< $otel_metrics_resource_metrics)

}
