# Building the docker images

##### 1. Download the relevant files



For apim and api-km

- wso2am-3.0.0.zip
- jdk-8u*-linux-x64.tar.gz (Any JDK 8u* version)
- dnsjava-2.1.8.jar (http://www.dnsjava.org/)
- [`kubernetes-membership-scheme-1.0.1.jar`](https://github.com/wso2/kubernetes-common/releases/tag/v1.0.1)
- mssql-jdbc-6.4.0.jre8.jar

Add the above files to apim/files and apim-km/files location.

> mssql docker image does not need since this is connecting to remote sql server 

##### 2. Build docker images

Run build.sh
```
./build.sh
```