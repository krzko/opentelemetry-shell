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

# Azure Pipelines
if [ "${TF_BUILD-}" ]; then
  . "${OTEL_SH_LIB_PATH}/otel_traces_detector_azure_pipelines.sh"
fi

# Bitbucket Pipelines
if [ "${BITBUCKET_BUILD_NUMBER-}" ]; then
  . "${OTEL_SH_LIB_PATH}/otel_traces_detector_bitbucket_pipelines.sh"
fi

# Buildkite
if [ "${BUILDKITE-}" ]; then
  . "${OTEL_SH_LIB_PATH}/otel_traces_detector_buildkite.sh"
fi

# Circle CI
if [ "${CIRCLECI-}" ]; then
  . "${OTEL_SH_LIB_PATH}/otel_traces_detector_circle_ci.sh"
fi

# Github Actions
if [ "${GITHUB_ACTIONS-}" ]; then
  . "${OTEL_SH_LIB_PATH}/otel_traces_detector_github_actions.sh"
fi

# Gitlab CI
if [ "${GITLAB_CI-}" ]; then
  . "${OTEL_SH_LIB_PATH}/otel_traces_detector_gitlab_ci.sh"
fi

# Google Cloud Build
# if [ "${GOOGLE-CLOUD-BUILD-}" ]; then
#   . "${OTEL_SH_LIB_PATH}/otel_traces_detector_google_cloud_build.sh"
# fi

# TODO: Harness
# if [ "${DEPLOYMENT_ID-}" ]; then
#   . "${OTEL_SH_LIB_PATH}/otel_traces_detector_harness.sh"
# fi

# Jenkins
if [ "${CI-}" ] && [ "${JENKINS_URL-}" ]; then
  . "${OTEL_SH_LIB_PATH}/otel_traces_detector_jenkins.sh"
fi

# Jenkins X
# if [ "${JENKINS-X-}" ]; then
#   . "${OTEL_SH_LIB_PATH}/otel_traces_detector_jenkins_x.sh"
# fi

# Travis CI
if [ "${TRAVIS-}" ]; then
  . "${OTEL_SH_LIB_PATH}/otel_traces_detector_travis_ci.sh"
fi
