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

# volumes
#oc create -f volumes/persistent-volumes.yaml

# Configuration Maps
#oc create configmap apim-analytics-1-bin --from-file=../confs/apim-analytics-1/bin/
#oc create configmap apim-analytics-1-conf --from-file=../confs/apim-analytics-1/repository/conf/
#oc create configmap apim-analytics-1-spark --from-file=../confs/apim-analytics-1/repository/conf/analytics/spark/
#oc create configmap apim-analytics-1-axis2 --from-file=../confs/apim-analytics-1/repository/conf/axis2/
#oc create configmap apim-analytics-1-datasources --from-file=../confs/apim-analytics-1/repository/conf/datasources/
#oc create configmap apim-analytics-1-tomcat --from-file=../confs/apim-analytics-1/repository/conf/tomcat/
#oc create configmap apim-analytics-1-conf-analytics --from-file=../confs/apim-analytics-1/repository/conf/analytics/
#
#oc create configmap apim-analytics-2-bin --from-file=../confs/apim-analytics-2/bin/
#oc create configmap apim-analytics-2-conf --from-file=../confs/apim-analytics-2/repository/conf/
#oc create configmap apim-analytics-2-spark --from-file=../confs/apim-analytics-2/repository/conf/analytics/spark/
#oc create configmap apim-analytics-2-axis2 --from-file=../confs/apim-analytics-2/repository/conf/axis2/
#oc create configmap apim-analytics-2-datasources --from-file=../confs/apim-analytics-2/repository/conf/datasources/
#oc create configmap apim-analytics-2-tomcat --from-file=../confs/apim-analytics-2/repository/conf/tomcat/
#oc create configmap apim-analytics-2-conf-analytics --from-file=../confs/apim-analytics-2/repository/conf/analytics/

#oc create configmap apim-manager-worker-bin --from-file=../confs/apim-manager-worker/bin/
oc create configmap apim-pub-store-conf --from-file=../confs/apim-pub-store/repository/conf/
oc create configmap apim-km-conf --from-file=../confs/apim-km/repository/conf/
oc create configmap apim-pub-store-bin --from-file=../confs/apim-pub-store/bin/
oc create configmap apim-km-bin --from-file=../confs/apim-km/bin/
#oc create configmap apim-tm1-conf --from-file=../confs/apim-tm-1/repository/conf/
#oc create configmap apim-tm1-bin --from-file=../confs/apim-tm-1/bin/
#oc create configmap apim-tm2-conf --from-file=../confs/apim-tm-2/repository/conf/
#oc create configmap apim-tm2-bin --from-file=../confs/apim-tm-2/bin/
#oc create configmap apim-manager-worker-identity --from-file=../confs/apim-manager-worker/repository/conf/identity/
#oc create configmap apim-manager-worker-axis2 --from-file=../confs/apim-manager-worker/repository/conf/axis2/
#oc create configmap apim-manager-worker-datasources --from-file=../confs/apim-manager-worker/repository/conf/datasources/
#oc create configmap apim-manager-worker-tomcat --from-file=../confs/apim-manager-worker/repository/conf/tomcat/

#oc create configmap apim-worker-bin --from-file=../confs/apim-worker/bin/
#oc create configmap apim-worker-conf --from-file=../confs/apim-worker/repository/conf/
#oc create configmap apim-worker-identity --from-file=../confs/apim-worker/repository/conf/identity/
#oc create configmap apim-worker-axis2 --from-file=../confs/apim-worker/repository/conf/axis2/
#oc create configmap apim-worker-datasources --from-file=../confs/apim-worker/repository/conf/datasources/
#oc create configmap apim-worker-tomcat --from-file=../confs/apim-worker/repository/conf/tomcat/

# databases
#echo 'deploying databases ...'
#oc create -f rdbms/rdbms-persistent-volume-claim.yaml
#oc create -f rdbms/rdbms-service.yaml
#oc create -f rdbms/rdbms-deployment.yaml


echo 'deploying wso2apim and wso2apim-km routes ...'
oc create -f apim-km/wso2apim-km-internal-service.yaml
oc create -f apim-km/wso2apim-km-clustering.yaml
sleep 15s
echo 'deploying apim manager-worker ...'
oc create -f apim-km/wso2apim-km-deployment.yaml
sleep 30s
oc create -f routes/wso2apim-km-route.yaml


#oc create -f apim-tm/wso2apim-tm-service.yaml
oc create -f apim-tm/wso2apim-tm-1-service.yaml
#oc create -f apim-tm/wso2apim-tm-2-service.yaml
#
#oc create -f apim-tm/wso2apim-tm-1-volume-claim.yaml
#sleep 30s
#echo 'deploying apim traffic manager ...'
#oc create -f apim-tm/wso2apim-tm-1-deployment.yaml
#oc create -f apim-tm/wso2apim-tm-2-deployment.yaml

echo 'deploying services and volume claims ...'
oc create -f apim-pub-store/wso2apim-service.yaml
sleep 2m
oc create -f apim-pub-store/wso2apim-publisher-store-deployment.yaml
oc create -f routes/wso2apim-route.yaml
oc create -f routes/wso2apim-gw-route.yaml
#oc create -f routes/wso2apim-gw-route.yaml
#oc create -f routes/wso2apim-analytics-route.yaml

