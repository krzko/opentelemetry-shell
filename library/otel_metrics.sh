#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/otel_init.sh"
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/log.sh"

function send_count_metric {
	local -r NAME="$1"
	local -r URL="$2"

	local EPOCH_START=$(date +%s)
	sleep 1
	local EPOCH_END=$(date +%s)

    RANDOM=$((1 + $RANDOM % 10))

	local JSON=$(cat <<EOF
{
  "resourceMetrics": [
    {
      "resource": {
        "attributes": [
          {
            "key": "service.name",
            "value": {
              "stringValue": "unknown_service"
            }
          }
        ],
        "droppedAttributesCount": 0
      },
      "instrumentationLibraryMetrics": [
        {
          "metrics": [
            {
              "name": "random_count",
              "description": "",
              "unit": "1",
              "Sum": {
                "dataPoints": [
                  {
                    "labels": [
                      {
                        "key": "hostname",
                        "value": "test.local"
                      }
                    ],
                    "value": 36,
                    "startTimeUnixNano": 1623690881701000000,
                    "timeUnixNano": 1623690893726877700
                  }
                ],
                "isMonotonic": true,
                "aggregationTemporality": 2
              }
            }
          ],
          "instrumentationLibrary": {
            "name": "handmade"
          }
        }
      ]
    }
  ]
}
EOF
)

	log_info "Sending Metric: otel.shell_random_count=${RANDOM}"
	if [[ $OTEL_LOG_LEVEL == "debug" ]]; then
		echo "${JSON}"
		curl -ik -X POST -H 'Content-Type: application/json' -d "${JSON}" "${URL}/v1/metrics" 
	else
		curl -ik -X POST -H 'Content-Type: application/json' -d "${JSON}" "${URL}/v1/metrics" -o /dev/null -s
	fi
}