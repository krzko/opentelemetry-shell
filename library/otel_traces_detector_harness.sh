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

log_info "Detected, Harness..."

if [ "$OTEL_SERVICE_NAME" == "unknown_service" ]; then
  return_spaces_to_dashes "${REPO_NAME}" "OTEL_SERVICE_NAME"
fi

declare -t detector_resource_attributes

detector_resource_attributes+=(
  "harness.app.name:${app.name}"
  "harness.app.desc:${app.description}"
  "harness.service.name:${service.name}"
  "harness.env.name:${env.name}"
  "harness.env.environmentType:${env.environmentType}"
  "harness.infra.name:${infra.name}"
  "harness.workflow.displayName:${workflow.displayName}"
  "harness.currentStep.name:${currentStep.name}"
  "harness.currentStep.type:${currentStep.type}"
  "harness.deploymentTriggeredBy:${deploymentTriggeredBy}"
)

# Shell script step
if [ ${context.published_name.var_name-} ]; then
  detector_resource_attributes+=(
    "harness.context.published_name.var_name:${context.published_name.var_name}"
  )
fi

# Instance
if [ ${instance.name-} ]; then
  detector_resource_attributes+=(
    "harness.instance.name:${instance.name}"
    "harness.instance.hostName:${instance.hostName}"
  )
fi

# Approval
if [ ${published_name.approvedBy.name-} ]; then
  detector_resource_attributes+=(
    "harness.published_name.approvedBy.name:${published_name.approvedBy.name}"
    "harness.published_name.approvedBy.email:${published_name.approvedBy.email}"
    "harness.published_name.approvedOn:${published_name.approvedOn}"
  )
fi
