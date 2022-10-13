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

set -euo pipefail

if [ -z "${OTEL_SH_LIB_PATH-}" ]; then
  export OTEL_SH_LIB_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
fi

. "${OTEL_SH_LIB_PATH}/log.sh"
. "${OTEL_SH_LIB_PATH}/otel_ver.sh"

export os_version=$(uname -a)
export hostname=$(hostname)

export telemetry_sdk_name="opentelemetry.sh"
export telemetry_sdk_lang="bash"

printf "\n"
printf " _____ _____ _____ _____ _____ _____ __    _____ _____ _____ _____ _____ __ __ \n"
printf "|     |  _  |   __|   | |_   _|   __|  |  |   __|     |   __|_   _| __  |  |  |\n"
printf "|  |  |   __|   __| | | | | | |   __|  |__|   __| | | |   __| | | |    -|_   _|\n"
printf "|_____|__|  |_____|_|___| |_| |_____|_____|_____|_|_|_|_____| |_| |__|__| |_|  \n"
printf " _____ _____ _____ __    __                                                    \n"
printf "|   __|  |  |   __|  |  |  |                                                   \n"
printf "|__   |     |   __|  |__|  |__                                                 \n"
printf "|_____|__|__|_____|_____|_____|                                                \n"
printf "\n"

log_info "Initialising OpenTelemetry Shell v${telemetry_sdk_ver}"

# OTEL_EXPORTER_OTLP_TRACES_ENDPOINT
# OTEL_EXPORTER_OTLP_METRICS_ENDPOINT
# OTEL_EXPORTER_OTLP_LOGS_ENDPOINT

if [ -z "${OTEL_EXPORTER_OTEL_ENDPOINT-}" ]; then
  log_error "OTEL_EXPORTER_OTEL_ENDPOINT not exported"
  exit 1
fi

if [ -z "${OTEL_SERVICE_NAME-}" ]; then
  export OTEL_SERVICE_NAME="unknown_service"
fi

if [ -z "${service_version-}" ]; then
  export service_version="undefined"
fi
