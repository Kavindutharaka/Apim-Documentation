<small> 1. Config Migration > [2. Resource & Artifact Migration](./resource-and-artifact-migration.md) > 3. Extensions & Customizations Migration > 4. Data Migration > 5. Server Startup </small>

# API-M Resource and Artifact Migration

As part of the migration process we need to move several API-M resource and artifact files from the older version to the new version. 

## Prerequisites

1. Please go through the [Resource and Artifact Migration Guidelines](../../../general-resource-and-artifact-migration.md).

## Steps for Resource and Artifact Migration

1. To preserve the information about added private keys, certificates, and trusted CAs used in API-M 3.0.0, copy the keystores (e.g., `client-truststore.jks`, `wso2carbon.jks`, and any custom JKS) from `<API-M_3.0.0_HOME>/repository/resources/security` to replace the existing ones in the `<API-M_4.1.0_HOME>/repository/resources/security` directory. 

   - If you have a distributed setup, you will have to copy keystores between each old profile and new profile.
   - Additionally, if you wish to integrate WSO2 IS 5.11.0 as the Resident Key Manager in the new API-M 4.1.0 deployment, make sure to copy the keystores (i.e., client-truststore.jks, wso2carbon.jks in the <API-M_3.0.0_HOME>/repository/resources/security) and replace the existing keystores in to <IS_5.11.0_HOME>/repository/resources/security directory.
    ---
    > **Important**
    > 
    > If you had secure vault in the previous version now re-run the ciphertool. Please refer to the [Encrypting Passwords in Configuration Files documentation](https://apim.docs.wso2.com/en/4.1.0/install-and-setup/setup/security/logins-and-passwords/working-with-encrypted-passwords/#encrypting-passwords-in-product-configurations) for more information.
    >  - Linux
    >    ```
    >    ./ciphertool.sh -Dconfigure
    >    ```
    >  - Windows
    >    ```
    >    ./ciphertool.bat -Dconfigure
    >    ```

    ---

2. If you have used secondary user stores in API-M 3.0.0, you have to copy the `userstores` file created inside the old API-M version to the new API-M version.

   - For secondary userstores created for the super tenant, you have to copy them from `<API-M_3.0.0_HOME>/repository/deployment/server/userstores` directory to `<API-M_4.1.0_HOME>/repository/deployment/server/userstores` directory.
   - For secondary userstores created for tenants, you have to copy the userstores from `<API-M_3.0.0_HOME>/repository/tenants/<tenantid>/`  directory to API-M `<API-M_4.1.0_HOME>/repository/tenants/<tenantid>/` directory.

   Further, if you wish to configure WSO2 IS 5.11.0 as the KM in API-M 4.1.0 new deployment, the aforementioned secondary userstores need to be stored in to same path in IS.


3. If you have used global sequences in the previous version, copy the sequence files to `<API-M_4.1.0_HOME>/repository/deployment/server/synapse-configs/default/sequences` folder and add the following config to API-M 4.1.0 `deployment.toml` to prevent the sequence files from getting removed from the file system on server startup. In a distributed deployment, this needs to be done on Gateway nodes.
   
    ```toml
    [apim.sync_runtime_artifacts.gateway.skip_list]
    sequences = ["<SEQUENCE FILES LIST HERE>"]
   ```
   
   Example
   ```toml
   [apim.sync_runtime_artifacts.gateway.skip_list]
   sequences = ["sequence1.xml","sequence2.xml","sequence3.xml"]
    ```

4. Copy the JDBC driver from `<API-M_3.0.0_HOME>/repository/components/lib` to `<API-M_4.1.0_HOME>/repository/components/lib` directory. If you have upgraded the database separately, add the applicable JDBC driver. In a distributed setup, ensure the JDBC driver is placed in the respective folder on each profile, as every profile requires database access at runtime.
   
---
*By now, you should have API-M 4.1.0 pack(s) that have finished both the Configuration Migration and Resource and Artifact Migration.*
