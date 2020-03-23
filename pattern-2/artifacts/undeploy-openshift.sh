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

oc delete deployments,services,PersistentVolume,PersistentVolumeClaim,Routes -l pattern=wso2apim-pattern-2 -n wso2

oc delete configmaps apim-pub-store-conf
oc delete configmaps apim-km-conf
oc delete configmaps apim-pub-store-bin
oc delete configmaps apim-km-bin
oc delete configmaps apim-tm1-conf
oc delete configmaps apim-tm1-bin
oc delete configmaps apim-tm2-conf
oc delete configmaps apim-tm2-bin