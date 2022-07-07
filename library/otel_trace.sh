#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/log.sh"

# export OTEL_EXPORTER_OTEL_ENDPOINT=""
export UUID_TRACE_ID
export UUID_PARENT_SPAN_ID

function trace_parent {
	local -r NAME="$1"
	local -r URL="$2"

	UUID_TRACE_ID=$(uuidgen | tr -d '-' | tr '[:upper:]' '[:lower:]')
	UUID_PARENT_SPAN_ID=$(uuidgen | tr -d '-' | tr '[:upper:]' '[:lower:]')

	local EPOCH_START=$(date +%s)
	sleep 1
	local EPOCH_END=$(date +%s)

	local JSON=$(cat <<EOF
{"resourceSpans":[{
	"resource":{
		"attributes":[
			{"key":"service.name","value":{"stringValue":"opentelemtry_trace.sh"}}
		]
	},
	"scopeSpans":[{
		"scope":{},
			"spans":[{
				"traceId":"${UUID_TRACE_ID}",
				"spanId":"${UUID_PARENT_SPAN_ID:0:16}",
				"parentSpanId":"",
				"name":"${NAME}",
				"kind":"SPAN_KIND_SERVER",
				"startTimeUnixNano":"${EPOCH_START}000000000",
				"endTimeUnixNano":"${EPOCH_END}000000000",
				"attributes":[
					{"key":"bash.errorlevel","value":{"stringValue":"0"}},
					{"key":"bash.version","value":{"stringValue":"3.2.57"}},
                    {"key":"bash.pwd","value":{"stringValue":"/Users/kowalskk/code/github.service.anz/kowalskk/bash-func/examples"}},
                    {"key":"bash.version","value":{"stringValue":"3.2.57"}},
                    {"key":"command","value":{"stringValue":"./opentelemtry_trace.sh --foo bar"}},
                    {"key":"os.version","value":{"stringValue":"Darwin"}}
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
	log_info "Curling..."
	log_info "Parent TraceId: ${UUID_TRACE_ID}"
	log_info "Parent spanId: ${UUID_PARENT_SPAN_ID:0:16}"
	# curl -ik -X POST -H 'Content-Type: application/json' -d "${JSON}" "${URL}/v1/traces" -o /dev/null -s
	echo "${JSON}"
	curl -ik -X POST -H 'Content-Type: application/json' -d "${JSON}" "${URL}/v1/traces"
}


function trace_child {
	local -r NAME="$1"
	local -r URL="$2"

	UUID_SPAN_CHILD_ID=$(uuidgen | tr -d '-' | tr '[:upper:]' '[:lower:]')
	local EPOCH_CHILD_START=$(date +%s)
	sleep 1
	local EPOCH_CHILD_END=$(date +%s)

	local JSON=$(cat <<EOF
{"resourceSpans":[{
	"resource":{
		"attributes":[
			{"key":"service.name","value":{"stringValue":"opentelemtry_trace.sh"}}
		]
	},
	"scopeSpans":[{
		"scope":{},
			"spans":[{
				"traceId":"${UUID_TRACE_ID}",
				"spanId":"${UUID_SPAN_CHILD_ID:0:16}",
				"parentSpanId":"${UUID_PARENT_SPAN_ID:0:16}",
				"name":"${NAME}",
				"kind":"SPAN_KIND_SERVER",
				"startTimeUnixNano":"${EPOCH_CHILD_START}000000000",
				"endTimeUnixNano":"${EPOCH_CHILD_END}000000000",
				"attributes":[
					{"key":"bash.errorlevel","value":{"stringValue":"0"}},
					{"key":"bash.version","value":{"stringValue":"3.2.57"}},
                    {"key":"bash.pwd","value":{"stringValue":"/Users/kowalskk/code/github.service.anz/kowalskk/bash-func/examples"}},
                    {"key":"bash.version","value":{"stringValue":"3.2.57"}},
                    {"key":"command","value":{"stringValue":"./opentelemtry_trace.sh --foo bar"}},
                    {"key":"os.version","value":{"stringValue":"Darwin"}}
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

	log_info "Curling..."
	log_info "Parent TraceId: ${UUID_TRACE_ID}"
	log_info "Parent spanId: ${UUID_PARENT_SPAN_ID:0:16}"
	log_info "Span spanId: ${UUID_SPAN_CHILD_ID:0:16}"
	echo "${JSON}"
	# curl -ik -X POST -H 'Content-Type: application/json' -d "${JSON}" "${URL}/v1/traces" -o /dev/null -s
	curl -ik -X POST -H 'Content-Type: application/json' -d "${JSON}" "${URL}/v1/traces"

}
