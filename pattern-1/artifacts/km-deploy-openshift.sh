#!/bin/bash

# ------------------------------------------------------------------------
# Copyright 2017 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License
# ------------------------------------------------------------------------

oc project wso2

echo 'deploying wso2apim and wso2apim-km routes ...'
oc create configmap apim-km-conf --from-file=../confs/apim-km/repository/conf/
oc create -f apim-km/wso2apim-gw-service.yaml
sleep 1m
# apim
echo 'deploying apim manager-worker ...'
oc create -f apim-km/wso2apim-gw-deployment.yaml
oc create -f routes/wso2apim-km-route.yaml