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

log_info "Detected, Jenkins pipeline"

detector_resource_attributes=(
  "jenkins.build.id:${BUILD_ID}"
  "jenkins.build.number:${BUILD_NUMBER}"
  "jenkins.build.tag:${BUILD_TAG}"
  "jenkins.build.url:${BUILD_URL}"
  "jenkins.executor.number:${EXECUTOR_NUMBER}"
  "jenkins.hostname:${HOSTNAME}"
  "jenkins.java.home:${JAVA_HOME}"
  "jenkins.job.name:${JOB_NAME}"
  "jenkins.job.url:${JOB_URL}"
  "jenkins.node.name:${NODE_NAME}"
  "jenkins.url:${JENKINS_URL}"
  "jenkins.version:${JENKINS_VERSION}"
  "jenkins.workspace:${WORKSPACE}"
)
