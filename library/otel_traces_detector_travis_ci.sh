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

log_info "Detected, Travis CI..."

if [ "$OTEL_SERVICE_NAME" == "unknown_service" ]; then
  return_spaces_to_dashes "${TRAVIS_REPO_SLUG}" "OTEL_SERVICE_NAME"
fi

detector_resource_attributes=(
  "travis.branch:${TRAVIS_BRANCH}"
  "travis.build.number:${BUILD_NUMBER}"
  "travis.build.url:${TRAVIS_BUILD_WEB_URL}"
  "travis.pull.request:${TRAVIS_PULL_REQUEST}"
  "travis.pull.request.branch:${TRAVIS_PULL_REQUEST_BRANCH}"
  "travis.pull.request.repo:${TRAVIS_PULL_REQUEST_SLUG}"
  "travis.repo:${TRAVIS_REPO_SLUG}"
)
