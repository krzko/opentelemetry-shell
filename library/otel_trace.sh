#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/otel_init.sh"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/log.sh"

export TRACE_ID=$(uuidgen | tr -d '-' | tr '[:upper:]' '[:lower:]')
PARENT_SPAN_ID=""

function trace_parent {
	local -r NAME="$1"	
	local SPAN_ID=$(uuidgen | tr -d '-' | tr '[:upper:]' '[:lower:]')
	PARENT_SPAN_ID=$SPAN_ID

	local EPOCH_START=$(date +%s)
	"$@"
	local EPOCH_END=$(date +%s)
	local EXIT_CODE=$?

	local JSON=$(cat <<EOF
{"resourceSpans":[{
	"resource":{
		"attributes":[
			{"key":"service.name","value":{"stringValue":"$(basename "$0")"}},
			{"key":"service.namespace","value":{"stringValue":"${NAME}"}},
			{"key":"service.instance.id","value":{"stringValue":"${HOSTNAME}"}},
			{"key":"service.version","value":{"stringValue":"${OTEL_SH_VERSION}"}},
			{"key":"telemetry.sdk.name","value":{"stringValue":"opentelemetry.sh"}},
			{"key":"telemetry.sdk.language","value":{"stringValue":"shell"}},
			{"key":"telemetry.sdk.version","value":{"stringValue":"${OTEL_SH_VERSION}"}}
		]
	},
	"scopeSpans":[{
		"scope":{},
			"spans":[{
				"traceId":"${TRACE_ID}",
				"spanId":"${SPAN_ID:0:16}",
				"parentSpanId":"",
				"name":"${NAME}",
				"kind":"SPAN_KIND_SERVER",
				"startTimeUnixNano":"${EPOCH_START}000000000",
				"endTimeUnixNano":"${EPOCH_END}000000000",
				"attributes":[
					{"key":"shell.errorlevel","value":{"stringValue":"${EXIT_CODE}"}},
                    {"key":"shell.pwd","value":{"stringValue":"${PWD}"}},
					{"key":"shell.user","value":{"stringValue":"${USER}"}},
					{"key":"shell.version","value":{"stringValue":"${BASH_VERSION}"}},
                    {"key":"command","value":{"stringValue":"$@"}},
                    {"key":"os.version","value":{"stringValue":"${OS_VERSION}"}}
				],
				"status":{
					"code":"STATUS_CODE_OK"
				}
			}]
		}]
	}]
}
EOF
)

	log_info "Sending SpanId: ${PARENT_SPAN_ID}"
	if [[ $OTEL_LOG_LEVEL == "debug" ]]; then
		log_info "Parent TraceId: ${TRACE_ID}"
		log_info "Parent spanId: ${PARENT_SPAN_ID:0:16}"
		echo "JSON: ${JSON}"
		echo "OTEL_EXPORTER_OTEL_ENDPOINT: ${OTEL_EXPORTER_OTEL_ENDPOINT}"
		curl -ik -X POST -H 'Content-Type: application/json' -d "${JSON}" "${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces" 
	else
		curl -ik -X POST -H 'Content-Type: application/json' -d "${JSON}" "${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces" -o /dev/null -s
	fi

	
	return $EXIT_CODE
}


function trace_child {
	local -r NAME="$1"

	local SPAN_ID=$(uuidgen | tr -d '-' | tr '[:upper:]' '[:lower:]')
	local EPOCH_CHILD_START=$(date +%s)
	"$@"
	local EPOCH_CHILD_END=$(date +%s)

	local JSON=$(cat <<EOF
{"resourceSpans":[{
	"resource":{
		"attributes":[
			{"key":"service.name","value":{"stringValue":"$(basename "$0")"}},
			{"key":"service.namespace","value":{"stringValue":"${NAME}"}},
			{"key":"service.instance.id","value":{"stringValue":"${HOSTNAME}"}},
			{"key":"service.version","value":{"stringValue":"${OTEL_SH_VERSION}"}},
			{"key":"telemetry.sdk.name","value":{"stringValue":"opentelemetry.sh"}},
			{"key":"telemetry.sdk.language","value":{"stringValue":"shell"}},
			{"key":"telemetry.sdk.version","value":{"stringValue":"${OTEL_SH_VERSION}"}}
		]
	},
	"scopeSpans":[{
		"scope":{},
			"spans":[{
				"traceId":"${TRACE_ID}",
				"spanId":"${SPAN_ID:0:16}",
				"parentSpanId":"${PARENT_SPAN_ID:0:16}",
				"name":"${NAME}",
				"kind":"SPAN_KIND_SERVER",
				"startTimeUnixNano":"${EPOCH_CHILD_START}000000000",
				"endTimeUnixNano":"${EPOCH_CHILD_END}000000000",
				"attributes":[
					{"key":"shell.errorlevel","value":{"stringValue":"${EXIT_CODE}"}},
                    {"key":"shell.pwd","value":{"stringValue":"${PWD}"}},
					{"key":"shell.user","value":{"stringValue":"${USER}"}},
					{"key":"shell.version","value":{"stringValue":"${BASH_VERSION}"}},
                    {"key":"command","value":{"stringValue":"$@"}},
                    {"key":"os.version","value":{"stringValue":"${OS_VERSION}"}}
				],
				"status":{
					"code":"STATUS_CODE_OK"
				}
			}]
		}]
	}]
}
EOF
)

	log_info "Sending SpanId: ${SPAN_ID}"
	if [[ $OTEL_LOG_LEVEL == "debug" ]]; then
		log_info "Parent TraceId: ${TRACE_ID}"
		log_info "Parent spanId: ${PARENT_SPAN_ID:0:16}"
		log_info "Child spanId: ${SPAN_ID:0:16}"
		echo "JSON: ${JSON}"
		echo "OTEL_EXPORTER_OTEL_ENDPOINT: ${OTEL_EXPORTER_OTEL_ENDPOINT}"
		curl -ik -X POST -H 'Content-Type: application/json' -d "${JSON}" "${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces"

	else
		curl -ik -X POST -H 'Content-Type: application/json' -d "${JSON}" "${OTEL_EXPORTER_OTEL_ENDPOINT}/v1/traces" -o /dev/null -s
	fi

}
