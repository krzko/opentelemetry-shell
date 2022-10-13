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

export telemetry_sdk_ver="0.0.9"

#######################################
# Returns a version of the SDK
# OUTPUTS:
#   Write to stdout
#######################################
otel_sh_ver() {
  printf "OpenTelemetry Shell v%s\n" $telemetry_sdk_ver
}

