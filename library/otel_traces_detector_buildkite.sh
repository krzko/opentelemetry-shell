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

. "${OTEL_SH_LIB_PATH}/log.sh"
. "${OTEL_SH_LIB_PATH}/strings.sh"

log_info "Detected, Buildkite..."

if [ "$OTEL_SERVICE_NAME" == "unknown_service" ]; then
  return_spaces_to_dashes "${BUILDKITE_REPO}" "OTEL_SERVICE_NAME"
fi

detector_resource_attributes=(
  "buildkite.branch:${BUILDKITE_BRANCH}"
  "buildkite.build.number:${BUILDKITE_BUILD_NUMBER}"
  "buildkite.build.url:${BUILDKITE_BUILD_URL}"
  "buildkite.pull.request.number:${BUILDKITE_PULL_REQUEST}"
  "buildkite.pull.request.repo:${BUILDKITE_PULL_REQUEST_REPO}"
  "buildkite.repo:${BUILDKITE_REPO}"
)
