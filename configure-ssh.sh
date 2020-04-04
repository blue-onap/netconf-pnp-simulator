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

set -eu

HERE=${0%/*}
source $HERE/common.sh

SSH_CONFIG=$CONFIG/ssh

ssh_pubkey=$(find_file $SSH_CONFIG id_ecdsa.pub id_dsa.pub id_rsa.pub)
test -n "$ssh_pubkey"
name=${ssh_pubkey##*/}
name=${name%%.pub}
set -- $(cat $ssh_pubkey)
log INFO Configure SSH ingress service
xmlstarlet ed --pf --omit-decl \
    --update '//_:name[text()="netconf"]/following-sibling::_:authorized-key/_:name' --value "$name" \
    --update '//_:name[text()="netconf"]/following-sibling::_:authorized-key/_:algorithm' --value "$1" \
    --update '//_:name[text()="netconf"]/following-sibling::_:authorized-key/_:key-data' --value "$2" \
    $TEMPLATES/load_auth_pubkey.xml | \
sysrepocfg --datastore=startup --format=xml ietf-system --import=-