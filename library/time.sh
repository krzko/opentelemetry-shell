#!/usr/bin/env bash

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/log.sh"

#######################################
# Gets the Unix epoch timesyamp in nanoseconds
# GLOBALS:
#   EPOCHREALTIME
# OUTPUTS:
#   Write to stdout
#######################################
get_epoch_now() {
  local epoch=""

  if hash gdate 2>/dev/null; then
    if [ -z ${OTEL_LOG_LEVEL-} ]; then
      log_info "Using gdate..."
    fi
    epoch="$(gdate +%s.%N)"
  elif [ ${EPOCHREALTIME} ]; then
    if [ -z ${OTEL_LOG_LEVEL-} ]; then
      log_info 'Using $EPOCHREALTIME...'
    fi
    epoch=$EPOCHREALTIME
  else
    if [ -z ${OTEL_LOG_LEVEL-} ]; then
      log_info "Using date..."
    fi
    epoch=$(date +%s%N)
  fi

  echo "${epoch//.}"
}
