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

log_info "Detected, Google Cloud Build..."

if [ "$OTEL_SERVICE_NAME" == "unknown_service" ]; then
  return_spaces_to_dashes "${REPO_NAME}" "OTEL_SERVICE_NAME"
fi

detector_resource_attributes=(
  "cloud.build.branch:${BRANCH_NAME}"
  "cloud.build.build.number:${BUILD_ID}"
  "cloud.build.pull.request.branch:${HEAD_BRANCH}"
  "cloud.build.repo:${REPO_NAME}"
  "cloud.build.repo.owner:${REPO_OWNER}"
)
