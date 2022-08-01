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
  "github.action:${GITHUB_ACTION}"
  "github.action_repository:${GITHUB_ACTION_REPOSITORY}"
  "github.actor:${GITHUB_ACTOR}"
  "github.job:${GITHUB_JOB}"
  "github.ref:${GITHUB_REF}"
  "github.ref_name:${GITHUB_REF_NAME}"
  "github.repository:${GITHUB_REPOSITORY}"
  "github.sha:${GITHUB_SHA}"
  "github.workflow:${GITHUB_WORKFLOW}"
  "github.workspace:${GITHUB_WORKSPACE}"
  "github.runner.arch:${RUNNER_ARCH}"
  "github.runner.name:${RUNNER_NAME}"
  "github.runner.os:${RUNNER_OS}"
)
