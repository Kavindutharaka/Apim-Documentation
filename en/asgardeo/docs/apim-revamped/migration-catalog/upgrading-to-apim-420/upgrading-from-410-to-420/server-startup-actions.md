<small> 1. Config Migration > 2. Resource & Artifact Migration > 3. Extensions & Customizations Migration > 4. Data Migration > [5. Server Startup](./server-startup-actions.md) </small>

# Server Startup Actions

Please follow the following to **complete the migration** and start the new API-M server.

> **Important**
>
> **If you have tenant-specific customizations in the previous version,** ensure that you reapply those customizations before proceeding further. This step should be done at this point because because tenant directories are created only after the data migration step. 


### Step 1: Re-Index the API Manager Artifacts

1. To re-index the API artifacts in the registry, add the following configuration into the `<API-M_4.2.0_HOME>/repository/conf/deployment.toml` file. 
        
    ```toml
    [indexing]
    re_indexing = 1
    ```
        
    Please be aware that each time you require re-indexing, you should increment the value of `re_indexing` by one. For instance, if you've previously utilized this config to re-index artifacts with the previous version, ensure to increase the `re_indexing` value by one.
             
2. If the `<API-M_4.2.0_HOME>/solr` directory exists, take a backup and thereafter delete it. 

    > **Important** 
    > 
    > **If you use a distributed WSO2 API-M setup**, the above should be done on the Control Plane. Make sure to keep a delay between nodes to execute this step to re-index each Control Plane node, as the database can experience a large load.
    >
    > **If you are using a K8s deployment**, make sure to use a new mount for the solr and remove the older solr mount from the deployment . 
    >
    > Note that it takes a considerable amount of time for the API Manager to re-index the artifacts, depending on the API count and the number of tenants.

### Step 2: Restart the API Manager

> **Note**
>
> If the older API-M setup has been configured for a different admin role other than admin and if the role is not persisted in read-only userstore, make sure to change the admin_role="<admin_role>" under [super_admin] configuration in the deployment.toml file before restarting the server. After that, you have to follow the steps given below.
> 
> 1. Log in to the admin portal and navigate to the scope mapping section.
> 2. Map the admin role to the `<admin_role>` role.
> 3. Then log in to the Management Console and delete the **admin** role

- Restart the API-M server after migration. 

    - Linux / Mac OS
      ```bash
      sh api-manager.sh
      ```
    - Windows
      ```bash
      api-manager.bat
      ```
- If you are using a distributed setup, start the profiles one after the other. Refer to [Distributed API-M deployment](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/distributed-deployment/understanding-the-distributed-deployment-of-wso2-api-m/) for more information and the suggested sequence of profile startup.