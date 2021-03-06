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

# builds the base images - apim, analytics

set -e

this_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
apim_dir=$(cd "${this_dir}/apim"; pwd)
apim_km_dir=$(cd "${this_dir}/apim-km"; pwd)
#apim_tm_dir=$(cd "${this_dir}/apim-tm"; pwd)
#mysql_dir=$(cd "${this_dir}/mysql"; pwd)

function docker_build() {
    tag=$1
    path=$2
    docker_api_version=`docker version | grep -m2 "API version" | tail -n1 | cut -d' ' -f5 | bc -l`
    echo "Building Docker image ${tag}..."
    if (( $(echo ${docker_api_version} '>=' 1.25 | bc -l) )); then
        docker build -t ${tag} ${path} --squash
    else
        echo "Docker API version is ${docker_api_version}, ignoring --squash option"
        docker build -t ${tag} ${path}
    fi
}

#docker_build docker.wso2.com/wso2am-kubernetes:3.0.0 $apim_dir
#docker_build docker.wso2.com/wso2am-km-kubernetes:3.0.0 $apim_km_dir
#docker_build docker.wso2.com/wso2am-tm-kubernetes:3.0.0 $apim_tm_dir
#docker_build docker.wso2.com/apim-rdbms-kubernetes:3.0.0 $mysql_dir

docker_build docker-registry.default.svc:5000/wso2/wso2am-kubernetes:3.0.0 $apim_dir
docker_build docker-registry.default.svc:5000/wso2/wso2am-km-kubernetes:3.0.0 $apim_km_dir
#docker_build docker-registry.default.svc:5000/wso2/wso2am-tm-kubernetes:3.0.0 $apim_tm_dir
#docker_build docker.wso2.com/apim-rdbms-kubernetes:3.0.0 $mysql_dir