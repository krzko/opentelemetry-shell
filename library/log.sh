#!/usr/bin/env bash

# Echo to stderr. Useful for printing script usage information.
function echo_stderr {
  >&2 echo "$@"
}

# Log the given message at the given level. All logs are written to stderr with a timestamp.
function log {
  local -r level="$1"
  local -r message="$2"
  local -r timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  local -r script_name="${0##*/}#L${BASH_LINENO[1]}"
  local -r function="${FUNCNAME[2]}"
  echo_stderr -e "${timestamp} [${level}] [$script_name] ["${function}"()] ${message}"
}

# Log the given message at INFO level. All logs are written to stderr with a timestamp.
function log_info {
  local -r message="$1"
  log "INFO" "$message"
}

# Log the given message at WARN level. All logs are written to stderr with a timestamp.
function log_warn {
  local -r message="$1"
  log "WARN" "$message"
}

# Log the given message at ERROR level. All logs are written to stderr with a timestamp.
function log_error {
  local -r message="$1"
  log "ERROR" "$message"
}
