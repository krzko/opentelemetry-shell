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

log_info "Detected, Circle CI..."

if [ "$OTEL_SERVICE_NAME" == "unknown_service" ]; then
  return_spaces_to_dashes "${CIRCLE_REPOSITORY_URL}" "OTEL_SERVICE_NAME"
fi

detector_resource_attributes=(
  "circle.ci.branch:${CIRCLE_BRANCH}"
  "circle.ci.build.number:${CIRCLE_BUILD_NUM}"
  "circle.ci.build.url:${CIRCLE_BUILD_URL}"
  "circle.ci.job.name:${CIRCLE_JOB}"
  "circle.ci.pull.request.number:${CIRCLE_PR_NUMBER}"
  "circle.ci.pull.request.user:${CIRCLE_PR_USER}"
  "circle.ci.pull.request.repo:${CIRCLE_PR_REPONAME}"
  "circle.ci.repo:${CIRCLE_REPOSITORY_URL}"
)
