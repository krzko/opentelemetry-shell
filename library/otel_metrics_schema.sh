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

. "${OTEL_SH_LIB_PATH}/time.sh"

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
      "scopeMetrics": [
        {
          "scope": {},
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

  otel_metrics_resource_metrics=$(jq -r ".resourceMetrics[].resource.attributes += [$attribute]" <<< "$otel_metrics_resource_metrics")
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

  otel_metrics_resource_metrics=$(jq -r ".resourceMetrics[].resource.attributes += [$attribute]" <<< "$otel_metrics_resource_metrics")
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

  otel_metrics_resource_metrics=$(jq -r ".resourceMetrics[].scopeMetrics[-1].metrics += [$obj]" <<< "$otel_metrics_resource_metrics")

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

  otel_metrics_resource_metrics=$(jq -r ".resourceMetrics[].scopeMetrics[].metrics[-1].gauge.dataPoints += [$obj]" <<< "$otel_metrics_resource_metrics")

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

  otel_metrics_resource_metrics=$(jq -r ".resourceMetrics[].scopeMetrics[].metrics[-1].gauge.dataPoints += [$obj]" <<< "$otel_metrics_resource_metrics")

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
otel_metrics_add_sum() {
	local name=$1
	local description=$2
  local unit=$3

  local obj=$(cat <<EOF
{
  "name": "${name}",
  "description": "${description}",
  "unit": "${unit}",
  "sum": {
    "dataPoints": []
  }
  "aggregationTemporality": "AGGREGATION_TEMPORALITY_CUMULATIVE",
  "isMonotonic": true
}
EOF
)

  otel_metrics_resource_metrics=$(jq -r ".resourceMetrics[].scopeMetrics[-1].metrics += [$obj]" <<< "$otel_metrics_resource_metrics")

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
otel_metrics_add_sum_datapoint_double() {
	local key=$1
	local value=$2
	local as_value=$3
  local start_time_unix_nano=$4
  local time_unix_nano=$(get_epoch_now)

  local obj=$(cat <<EOF
{
  "startTimeUnixNano": "${start_time_unix_nano}",
  "timeUnixNano": "${time_unix_nano}",
  "asDouble": ${as_value}
}
EOF
)

  otel_metrics_resource_metrics=$(jq -r ".resourceMetrics[].scopeMetrics[].metrics[-1].sum.dataPoints += [$obj]" <<< "$otel_metrics_resource_metrics")


  otel_metrics_resource_metrics=$(jq -r ".resourceMetrics[].scopeMetrics[].metrics[-1].sum.aggregationTemporality = \"AGGREGATION_TEMPORALITY_CUMULATIVE\"" <<< "$otel_metrics_resource_metrics")
  otel_metrics_resource_metrics=$(jq -r ".resourceMetrics[].scopeMetrics[].metrics[-1].sum.isMonotonic = true" <<< "$otel_metrics_resource_metrics")

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
otel_metrics_add_sum_datapoint_int() {
	local key=$1
	local value=$2
	local as_value=$3
  local start_time_unix_nano=$4
  local time_unix_nano=$(get_epoch_now)

  local obj=$(cat <<EOF
{
  "startTimeUnixNano": "${start_time_unix_nano}",
  "timeUnixNano": "${time_unix_nano}",
  "asInt": "${as_value}"
}
EOF
)

  otel_metrics_resource_metrics=$(jq -r ".resourceMetrics[].scopeMetrics[].metrics[-1].sum.dataPoints += [$obj]" <<< "$otel_metrics_resource_metrics")


  otel_metrics_resource_metrics=$(jq -r ".resourceMetrics[].scopeMetrics[].metrics[-1].sum.aggregationTemporality = \"AGGREGATION_TEMPORALITY_CUMULATIVE\"" <<< "$otel_metrics_resource_metrics")
  otel_metrics_resource_metrics=$(jq -r ".resourceMetrics[].scopeMetrics[].metrics[-1].sum.isMonotonic = true" <<< "$otel_metrics_resource_metrics")
}
