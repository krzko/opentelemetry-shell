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

log_info "Detected, Azure Pipelines..."

return_spaces_to_dashes "${GITHUB_REPOSITORY}" "service_name"

detector_resource_attributes=(
  "azure.branch:${BUILD_SOURCEBRANCHNAME}"
  "azure.build.id:${BUILD_BUILDID}"
  "azure.build.number:${BUILD_BUILDNUMBER}"
  "azure.job.name:${SYSTEM_JOBDISPLAYNAME}"
  "azure.stage.name:${SYSTEM_STAGEDISPLAYNAME}"
  "azure.pull.request.id:${SYSTEM_PULLREQUEST_PULLREQUESTID}"
  "azure.pull.request.number:${SYSTEM_PULLREQUEST_PULLREQUESTNUMBER}"
  "azure.build.user:${BUILD_REQUESTEDFOR}"
  "azure.repo:${BUILD_REPOSITORY_URI}"
)
