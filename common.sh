#!/bin/ash
# shellcheck disable=SC2086

# ============LICENSE_START=======================================================
#  Copyright (C) 2020 Nordix Foundation.
# ================================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0
# ============LICENSE_END=========================================================

set -o errexit
set -o pipefail
set -o nounset
[ "${SHELL_XTRACE:-false}" = "true" ] && set -o xtrace

export PATH=/opt/bin:/usr/local/bin:/usr/bin:/bin

CONFIG=/config
TEMPLATES=/templates

PROC_NAME=${0##*/}
PROC_NAME=${PROC_NAME%.sh}

function now_ms() {
    # Requires coreutils package
    date +"%Y-%m-%d %H:%M:%S.%3N"
}

function log() {
    local level=$1
    shift
    local message="$*"
    >&2 printf "%s %-5s [%s] %s\n" "$(now_ms)" $level $PROC_NAME "$message"
}

find_file() {
  local dir=$1
  shift
  for app in "$@"; do
    if [ -f $dir/$app ]; then
      echo -n $dir/$app
      break
    fi
  done
}


# Extracts the body of a PEM file by removing the dashed header and footer
pem_body() {
    grep -Fv -- ----- "$1"
}