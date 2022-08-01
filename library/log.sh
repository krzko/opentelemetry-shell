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

# https://opentelemetry.io/docs/reference/specification/logs/data-model/#severity-fields

#######################################
# Echo to stderr
# ARGUMENTS:
#   $@, expands to the positional parameters
# OUTPUTS:
#   Write to stderr
#######################################
function echo_stderr {
  >&2 echo "$@"
}

# Log the given message at the given level.
#######################################
# Log the given message at level, DEBUG.
# All logs are written to stderr with a timestamp.
# ARGUMENTS:
#   message, the entry to be printed
# OUTPUTS:
#   Write to stderr
#######################################
function log {
  local -r level="$1"
  local -r message="$2"
  local -r timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  local -r script_name="${0##*/}#L${BASH_LINENO[1]}"
  local -r function="${FUNCNAME[2]}"
  echo_stderr -e "${timestamp} [${level}] [$script_name] [${function}()] ${message}"
}

#######################################
# Log the given message at level, TRACE
# ARGUMENTS:
#   message, the text to be printed
# OUTPUTS:
#   Write to stderr
#######################################
function log_trace {
  local -r message="$1"
  log "TRACE" "$message"
}

#######################################
# Log the given message at level, DEBUG
# ARGUMENTS:
#   message, the text to be printed
# OUTPUTS:
#   Write to stderr
#######################################
function log_debug {
  if [ -z "${OTEL_LOG_LEVEL-}" ]; then
    local -r message="$1"
	else
    local -r message="$1"
    log "DEBUG" "$message"
	fi
}

#######################################
# Log the given message at level, INFO
# ARGUMENTS:
#   message, the text to be printed
# OUTPUTS:
#   Write to stderr
#######################################
function log_info {
  local -r message="$1"
  log "INFO" "$message"
}

#######################################
# Log the given message at level, WARN
# ARGUMENTS:
#   message, the text to be printed
# OUTPUTS:
#   Write to stderr
#######################################
function log_warn {
  local -r message="$1"
  log "WARN" "$message"
}

#######################################
# Log the given message at level, ERROR
# ARGUMENTS:
#   message, the text to be printed
# OUTPUTS:
#   Write to stderr
#######################################
function log_error {
  local -r message="$1"
  log "ERROR" "$message"
}

#######################################
# Log the given message at level, FATAL
# ARGUMENTS:
#   message, the text to be printed
# OUTPUTS:
#   Write to stderr
#######################################
function log_fatal {
  local -r message="$1"
  log "FATAL" "$message"
}
