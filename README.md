# WSO2 API Manager 3.0.0 Openshift Resources 
*Kubernetes/Openshift Resources for container-based deployments of WSO2 API Manager (APIM)*

## Quick Start Guide

>In the context of this document, `KUBERNETES_HOME` will refer to a local copy of 
[`wso2/kubernetes-apim`](https://github.com/wso2/kubernetes-apim/) git repository. 

##### 1. Checkout WSO2 apim-openshift  repository using `git clone`:
```
git clone https://github.com/irham0019/apim-openshift.git
```

##### 2. Run ./build.sh in base/build.sh to generate the docker images:
    ```

* Deploy on Openshift

    1. Create a user called admin and assign the cluster-admin role. (Cluster-admin user is used to deploy openshift artifacts)
    ```
    oc login -u system:admin
    oc create user admin --full-name=admin
    oc adm policy add-cluster-role-to-user cluster-admin admin
    ```
    2. Create a new project called wso2.
    ```
    oc new-project wso2 --description="WSO2 API Manager 2.1.0" --display-name="wso2"
    ```
        
    3. Create a service account called wso2svcacct in wso2 project and assign anyuid security context constraint.
    ```
    oc create serviceaccount wso2svcacct
    oc adm policy add-scc-to-user anyuid -z wso2svcacct -n wso2
    ```
    4. Deploy any pattern by running `deploy-openshift.sh` script inside pattern folder (KUBERNETES_HOME/pattern-X/).
    ```
    ./deploy-openshift.sh
    ```
    5. Access Management Console 
       Using the following command to list the routes in the deployment.
        ```
        oc get routes
        ```
        Add relevant hosts and IP addresses to /etc/hosts file.
        
        > Sample Access URLs (This will vary based on the pattern)  
        > https://wso2apim  
        > https://wso2apim-km
        > https://wso2apim-gw  

    6. Undeploy any pattern by running `undeploy-openshift.sh` script inside pattern folder (/pattern-X/).
    ```
    ./undeploy-openshift.sh
    ```
 
           
<br>

> Tested in OpenShift v3.6.0 and Kubernetes v1.6.1

> NFS is tested in Kubernetes v1.6.1