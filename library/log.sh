#!/usr/bin/env bash
#
# AUTHORS, LICENSE and DOCUMENTATION
#

# https://opentelemetry.io/docs/reference/specification/logs/data-model/#severity-fields

# Echo to stderr
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
  echo_stderr -e "${timestamp} [${level}] [$script_name] ["${function}"()] ${message}"
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
  local -r message="$1"
  log "DEBUG" "$message"
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
