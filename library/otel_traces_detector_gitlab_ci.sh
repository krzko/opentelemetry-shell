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

log_info "Detected, Gitlab CI..."

if [ -z "${OTEL_SERVICE_NAME-}" ]; then
    return_spaces_to_dashes "${CI_PROJECT_URL}-pipelines" "OTEL_SERVICE_NAME"
fi

if [ -n "${detector_resource_attributes-}" ]; then
    detector_resource_attributes=()
fi

detector_resource_attributes+=(
  "gitlab.ci.branch:${CI_COMMIT_REF_NAME}"
  "gitlab.ci.build.number:${CI_PIPELINE_ID}"
  "gitlab.ci.build.url:${CI_PIPELINE_URL}"
  "gitlab.ci.repo:${CI_PROJECT_URL}"
)

if [ -n "${CI_MERGE_REQUEST_SOURCE_BRANCH_NAME-}" ]; then
  detector_resource_attributes+=(
    "gitlab.ci.pull.request.branch:${CI_MERGE_REQUEST_SOURCE_BRANCH_NAME}"
    "gitlab.ci.pull.request.number:${CI_MERGE_REQUEST_ID}"
    "gitlab.ci.pull.request.repo:${CI_MERGE_REQUEST_SOURCE_PROJECT_PATH}"
  )
fi
