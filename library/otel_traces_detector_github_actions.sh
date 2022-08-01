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

log_info "Detected, GitHub Actions..."

return_spaces_to_dashes "${GITHUB_REPOSITORY}_${GITHUB_WORKFLOW}" "OTEL_SERVICE_NAME"

export OTEL_SERVICE_NAME="${GITHUB_REPOSITORY}_${GITHUB_WORKFLOW}"

detector_resource_attributes=(
  "gha.action:${GITHUB_ACTION}"
  "gha.action_repository:${GITHUB_ACTION_REPOSITORY}"
  "gha.actor:${GITHUB_ACTOR}"
  "gha.job:${GITHUB_JOB}"
  "gha.ref:${GITHUB_REF}"
  "gha.ref_name:${GITHUB_REF_NAME}"
  "gha.github.repository:${GITHUB_REPOSITORY}"
  "gha.github.sha:${GITHUB_SHA}"
  "gha.workflow:${GITHUB_WORKFLOW}"
  "gha.workspace:${GITHUB_WORKSPACE}"
  "gha.runner.arch:${RUNNER_ARCH}"
  "gha.runner.name:${RUNNER_NAME}"
  "gha.runner.os:${RUNNER_OS}"
)
