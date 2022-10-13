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

log_info "Detected, Bitbucket Pipelines..."

if [ "$OTEL_SERVICE_NAME" == "unknown_service" ]; then
  return_spaces_to_dashes "${BITBUCKET_REPO_FULL_NAME}" "OTEL_SERVICE_NAME"
fi

detector_resource_attributes=(
  "buildkite.branch:${BITBUCKET_BRANCH}"
  "buildkite.build.number:${BITBUCKET_BUILD_NUMBER}"
  "buildkite.build.user:${BITBUCKET_STEP_TRIGGERER_UUID}"
  "buildkite.pipeline.id:${BITBUCKET_PIPELINE_UUID}"
  "buildkite.pull.request.id:${BITBUCKET_PR_ID}"
  "buildkite.repo:${BITBUCKET_REPO_FULL_NAME}"
)
