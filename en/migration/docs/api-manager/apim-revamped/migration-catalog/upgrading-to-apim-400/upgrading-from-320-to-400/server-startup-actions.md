<small> 1. Config Migration > 2. Resource & Artifact Migration > 3. Extensions & Customizations Migration > 4. Data Migration > [5. Server Startup](./server-startup-actions.md) </small>

# Server Startup Actions

Please follow the following to **complete the migration** and start the new API-M server.

> **Important**
>
> **If you have tenant-specific customizations in the previous version,** ensure that you reapply those customizations before proceeding further. This step should be done at this point because because tenant directories are created only after the data migration step. 


### Step 1: Re-Index the API Manager Artifacts

1. Get the `reg-index.sql` script from [here](../../../../../../api-manager/migration-resources/apim-4.0.0-resources/attachments/apim/excludes-apim1.10.0-4.0.0) and run it against the database contains the registry and user management data (`SHARED_DB`).

    > **Note**
    >
    > Note that depending on the number of records in the `REG_LOG` table, this script will take a considerable amount of time to finish. Do not stop the execution of script until it is completed.

2. If you have **multiple tenants** (no need to do this step if you do not have multiple tenants), Get the `tenantloader-1.0.jar` file script from [here](../../../../../../api-manager/migration-resources/apim-4.0.0-resources/attachments/apim/excludes-apim1.10.0-4.0.0) and add it to the `<API-M_4.0.0_HOME>/repository/components/dropins` directory.

   > **Note**
   >
   > If you are working with a clustered/distributed API Manager setup, follow this step on the Store and Publisher nodes.

3. To re-index the API artifacts in the registry, add the following configuration into the `<API-M_4.0.0_HOME>/repository/conf/deployment.toml` file. 
        
    ```toml
    [indexing]
    re_indexing = 1
    ```
        
    Please be aware that each time you require re-indexing, you should increment the value of `re_indexing` by one. For instance, if you've previously utilized this config to re-index artifacts with the previous version, ensure to increase the `re_indexing` value by one.
             
4. If the `<API-M_4.0.0_HOME>/solr` directory exists, take a backup and thereafter delete it. 

    > **Important** 
    > 
    > **If you use a distributed WSO2 API-M setup**, the above should be done on the Control Plane. Make sure to keep a delay between nodes to execute this step to re-index each Control Plane node, as the database can experience a large load.
    >
    > **If you are using a K8s deployment**, make sure to use a new mount for the solr and remove the older solr mount from the deployment . 
    >
    > Note that it takes a considerable amount of time for the API Manager to re-index the artifacts, depending on the API count and the number of tenants.

5. If you completed step 2, start the server. Once the server is started, stop it. Then, delete the `tenantloader-1.0.jar` file from the `<API-M_4.0.0_HOME>/repository/components/dropins` directory.

### Step 2: Restart the API Manager

- Restart the API-M server after migration. 

    - Linux / Mac OS
      ```bash
      sh api-manager.sh
      ```
    - Windows
      ```bash
      api-manager.bat
      ```
- If you are using a distributed setup, start the profiles one after the other. Refer to [Distributed API-M deployment](https://apim.docs.wso2.com/en/4.0.0/install-and-setup/setup/distributed-deployment/understanding-the-distributed-deployment-of-wso2-api-m/) for more information and the suggested sequence of profile startup.

> **Important** 
> 
> **If you are migrating from a version prior to 4.x**, after the migration is completed, you will see that revision 1 has been created for all APIs that were in a published state and deployed to the gateway environments. If you plan on updating/editing any of these APIs after the migration, **make sure to create a revision 2** before making any updates or edits. This is important in case you need to revert the changes and restore the API to its post-migration state.
>
> Revision 1 is created systematically by the internal 4.0 version migrator of the APIM migration client. Therefore, all API updates added by the migration client will be applied to the current API and not to revision 1. After the migration, **DO NOT** restore revision 1 from the publisher portal.
