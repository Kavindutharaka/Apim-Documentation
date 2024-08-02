# API-M Data Migration on Kubernetes

This guide provides a guide to follow during data migration, if you are using K8s.

## Recommended Approach

When migrating a Kubernetes environment to a newer API Manager version, it is recommended to **perform the data migration in a separate VM** (preferred), a local machine, or a single container. Once the data migration is complete, you can then simply connect your Kubernetes deployment to the migrated data source.

- Firstly, ensure you have an APIM All-in-One/Control-Plane pack containing all your configurations and customizations. If you've completed previous migration steps, you should already have this pack.

- Then, follow the steps outlined in the version-specific data migration guideline to add migration resources and migration client(s) to the appropriate directories and carry out the data migration. Make sure your VM/machine/container has access to the data source.
  
- Once the migration is complete, update your Kubernetes deployment configuration to point to the migrated data source.
  
## Alternate Approach

If you can not follow the above approach and require to perform the data migration on a K8s cluster itself, you can do so with a with a K8s single pod Deployment, please refer the following.

---
**IMPORTANT!**

**This approach carries a significant risk and should only be considered as a last resort**. If the pod running the client is prematurely terminated during the data migration process, it can potentially corrupt the database, necessitating a restoration to a previous state. Therefore, if you must proceed with this method, ensure you take database dumps beforehand to facilitate restoration if needed.

---

- To begin, ensure you have an APIM All-in-One/Control-Plane pack containing all your configurations and customizations. If you've completed previous migration steps, obtaining this pack should be straightforward.

- Next, follow the version-specific data migration guideline and follow the outlined steps to add migration resources and migration clients to the appropriate directories.

- Then, create custom product images as follows:
    - If you use the inbuilt resident KM, create a custom product image containing the IS migration client jar and resources. 
    - Create a custom product image containing the API migration client jar and resources.
    - Please note that you cannot have both clients in a single image.

- Use these custom images with a K8s single pod Deployment to execute the identity/apim data migration process commands on the cluster. Below, we've provided a sample K8s Deployment for reference. Follow this example to develop your own K8s Deployment for the migration. 

    - Replace `<CUSTOM_APIM_IMG_WITH_MIGRATION_JAR>` with the custom images you built previously.
    - You can modify the `command` field to execute the relevant migration command. Refer to the version-specific data migration to identify the appropriate commands.
    - Each command may necessitate a new deployment. After the K8s pod initiates, monitor the logs. Once the server launches and the migration commands conclude, remove the deployment and proceed to the next command. Essentially, this approach involves executing each migration command sequentially via a K8s Deployment.
 
        ```yaml
        apiVersion: apps/v1
        kind: Deployment
        metadata:
            name: wso2am
            namespace: wso2am
        spec:
            replicas: 1
            selector:
                matchLabels:
                    app: wso2am
            template:
                metadata:
                    labels:
                        app: wso2am
                spec:
                    containers:
                    - name: wso2am
                    image: "<CUSTOM_APIM_IMG_WITH_MIGRATION_JAR>"
                    ports:
                    - containerPort: 9443
                    command: ["sh", "-c", "<API_M_HOME>/bin/api-manager.sh -Dmigrate -DmigrateFromVersion=3.x.x -DmigratedVersion=4.x.x"]
                    resources:
                        requests:
                            memory: "2000Mi"
                            cpu: "1000m"
                        limits:
                            memory: "4000Mi"
                            cpu: "1000m"
        ```

- Once the data migration is complete, update your Kubernetes new production deployment configuration to point to the migrated data source.
---
**IMPORTANT**

With either of the above options, if you are migrating from WSO2 IS/ WSO2 IS as KM in the previous version to WSO2 IS in the latest version, first migrate WSO2 IS/IS as KM.

---