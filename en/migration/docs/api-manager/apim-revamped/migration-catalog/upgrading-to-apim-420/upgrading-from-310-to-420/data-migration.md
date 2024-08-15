<small> 1. Config Migration > 2. Resource & Artifact Migration > 3. Extensions & Customizations Migration > [4. Data Migration](./data-migration.md) > 5. Server Startup </small>

# Data Migration

> **Important**
>  
> To ensure the integrity of the database during the following steps, it is recommended to create database backups before each step. This precaution allows you to resume from the current step in case of an issue, instead of starting from the beginning. For instance, if you complete the Identity Server (IS) component migration and create a backup, you can resume from the API Manager (APIM) component migration step if something goes wrong, rather than repeating the IS component migration.

## Prerequisites

1. Follow the [Data Migration Guidelines](../../../general-data-migration.md).
   
2. Check on the [Tested DBMS](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/reference/product-compatibility/#tested-dbmss) for API-M 4.2.0. Only those versions will be supported in migration as well. Therefore, if you are currently on an older database version, please migrate your database to the supported version first before proceeding with the migration.

## Step 1: Run the Database Scripts

1. Run the relevant script mentioned [here](../../../../../../api-manager/migration-resources/apim-4.2.0-resources/db-scripts/upgrading-from-310-to-420/add-missing-registry-indices) on the registry database (`shared_db`) to add missing registry indices.

2. If there are frequently updating registry properties, having the versioning enabled for registry resources in the registry can lead to unnecessary growth in the registry related tables in the database. To avoid this, versioning has been disabled from API Manager 4.2.0. But, if registry versioning was enabled by you in WSO2 API-M 3.1.0 setup, it is required run the below scripts against the database that is used by the registry. Follow the below steps to achieve this. To verify registry versioning was turned on in your old API-M, open the registry.xml file in the <OLD_API-M_HOME>/repository/conf directory. Check whether versioningProperties, versioningComments, versioningTags and versioningRatings configurations are true.

    ```yaml
    <staticConfiguration>
        <versioningProperties>true</versioningProperties>
        <versioningComments>true</versioningComments>
        <versioningTags>true</versioningTags>
        <versioningRatings>true</versioningRatings>
    </staticConfiguration>
    ```
   > Warning
   >
   > If the above configurations are already set as false, you should not run the below scripts.

   To remove the registry versioning details, run the relevant script in [here](../../../../../../api-manager/migration-resources/apim-4.2.0-resources/db-scripts/upgrading-from-310-to-420/remove-registry-versioning-details) against the registry database (`shared_db`).

## Step 2: Migration of Identity Data

**This step is applicable only for cases where resident KM is used. If you use WSO2 IS as KM please migrate IS to 6.0.0 first.**

> **Note**
>
> APIM 4.2.0 also supports IS 6.1.0. To migrate IS to 6.1.0 you can follow the same steps as below, making sure to change the migratedVersion in step 3 to 6.1.0 and use the 6.1.0 version of the migration-config.yaml in step 5.

1. Download the `wso2is-migration-x.x.x.zip` (identity component migration resources) from [here](../../../../../../api-manager/migration-resources/apim-4.2.0-resources/attachments/is) and unzip it in a local directory. Let's refer to this directory that you extracted as `<IS_MIGRATION_TOOL_HOME>`.

2. Copy the `migration-resources` folder from the extracted folder to the `<API-M_4.2.0_HOME>` directory.

3. Open the `migration-config.yaml` file in the migration-resources directory and make sure that the `currentVersion` element is set to 5.10.0, as shown below.

    ```yaml
    migrationEnable: "true"
    currentVersion: "5.10.0"
    migrateVersion: "6.0.0"
    ```

4. Remove the following 3 steps from `migration-config.yaml`, which are included under version: "5.11.0".

    ```yaml
    - name: "EncryptionAdminFlowMigrator"
      order: 1
      parameters:
        currentEncryptionAlgorithm: "RSA/ECB/OAEPwithSHA1andMGF1Padding"
        migratedEncryptionAlgorithm: "AES/GCM/NoPadding"
        schema: "identity"
    - name: "EncryptionUserFlowMigrator"
      order: 2
      parameters:
        currentEncryptionAlgorithm: "RSA/ECB/OAEPwithSHA1andMGF1Padding"
        migratedEncryptionAlgorithm: "AES/GCM/NoPadding"
        schema: "identity"
                      
    - name: "SCIMGroupRoleMigrator"
      order: 18
    ```

5. Remove the following step from `migration-config.yaml`, which is included under version: "6.0.0".

    ```yaml
    - name: "SchemaMigrator"
      order: 4
      parameters:
        location: "step3"
        schema: "consent" 
    ```

6. Copy the `org.wso2.carbon.is.migration-x.x.x.jar` from the `<IS_MIGRATION_TOOL_HOME>/dropins` directory to the `<API-M_4.2.0_HOME>/repository/components/dropins` directory.

7. If you are migrating your user stores to the new user store managers with the unique ID capabilities, contact the WSO2 Support Team to obtain guidelines on migrating User Store Managers before moving to the next step.

8.  Start WSO2 API Manager 4.2.0 as follows to carry out the complete Identity component migration. If you're working with a distributed setup, remember to add the `-Dprofile=control-plane` property to the following commands as well.

   - Linux / Mac OS
      ```bash
      sh api-manager.sh -Dmigrate -Dcomponent=identity
      ```
   - Windows
      ```bash
      api-manager.bat -Dmigrate -Dcomponent=identity
      ```

9. After you have successfully completed the migration, stop the server and remove the following files and folders.

   -   Remove the `org.wso2.carbon.is.migration-x.x.x.jar` file, which is in the `<API-M_4.2.0_HOME>/repository/components/dropins` directory.

   -   Remove the `migration-resources` directory, which is in the `<API-M_4.2.0_HOME>` directory.

   -   If you ran WSO2 API-M as a Windows Service when doing the identity component migration, then you need to remove the following parameters in the command line arguments section (CMD_LINE_ARGS) of the api-manager.bat file.

       ```bash
       -Dmigrate -Dcomponent=identity
       ```

10. If you followed step 7 above, update the `<API-M_4.2.0_HOME>/repository/conf/deployment.toml` as follows after the identity migration.

    ```toml
    [user_store]
    type = "database_unique_id"
    ```

## Step 3: Migration the API Manager Data

> **Warning**
>  
> If you are using PostgreSQL for registry database, add the following parameter `preparedStatementCacheQueries=0` to the JDBC URL in `<API-M_4.2.0_HOME>/repository/conf/deployment.toml` as below before running the migration client.  This is needed because API-M migration client is running schema upgrades (i.e. DDL statements) to registry databases while APIM back-end is using the same registry tables in the databases.
>  ```toml
>  [database.shared_db]
>  type = "postgre"
>  url = "jdbc:postgresql://localhost:5432/reg_db?preparedStatementCacheQueries=0"
>  ```
>  
> If you are using a separate PostgreSQL database for the WSO2CONFIG_DB, add the same to the `<API-M_4.2.0_HOME>/repository/conf/deployment.toml` as below.
>  ```toml
>  [database.config]
>  type = "postgre"
>  url = "jdbc:postgresql://localhost:5432/config_db?preparedStatementCacheQueries=0"
>  ```

1. Download the `wso2am-migration-4.2.0.x.zip` (APIM component migration resources) from [here](../../../../../../api-manager/migration-resources/apim-4.2.0-resources/attachments/apim) and unzip it in a local directory.

2. Copy the `migration-resources` to the `<API-M_4.2.0_HOME>` folder.

3. Copy the `org.wso2.carbon.apimgt.migrate.client-4.2.0.x.jar` file residing in `<wso2am-migration-4.2.0.x>/dropins` into the `<API-M_4.2.0_HOME>/repository/components/dropins` directory.


> **Important**
> 
> If you have configured WSO2 IS 5.11.0 as Key Manager, make sure you have already started the WSO2 Identity Server instance before executing the next step.


4. Run the below command to execute the pre-migration step that will validate your old data. If you're working with a distributed setup, remember to add the `-Dprofile=control-plane` property to the following commands as well.

    - Linux / Mac OS
      ```bash
      sh api-manager.sh -Dmigrate -DmigrateFromVersion=3.1.0 -DmigratedVersion=4.2.0 -DrunPreMigration
      ```
    - Windows
      ```bash
      api-manager.bat -Dmigrate -DmigrateFromVersion=3.1.0 -DmigratedVersion=4.2.0 -DrunPreMigration
      ```

    If you want to save the invalid API definitions,
    
    - Linux / Mac OS
      ```bash
      sh api-manager.sh -Dmigrate -DmigrateFromVersion=3.1.0 -DmigratedVersion=4.2.0 -DrunPreMigration -DsaveInvalidDefinition
      ```
    - Windows
      ```bash
      api-manager.bat -Dmigrate -DmigrateFromVersion=3.1.0 -DmigratedVersion=4.2.0 -DrunPreMigration -DsaveInvalidDefinition
      ```


5. Start the API-M server to migrate the API-M components as follows. If you're working with a distributed setup, remember to add the `-Dprofile=control-plane` property to the following commands as well.

    - Linux / Mac OS
      ```bash
      sh api-manager.sh -Dmigrate -DmigrateFromVersion=3.1.0 -DmigratedVersion=4.2.0
      ```
    - Windows
      ```bash
      api-manager.bat -Dmigrate -DmigrateFromVersion=3.1.0 -DmigratedVersion=4.2.0
      ```

6. After you have successfully completed the migration, stop the server and remove the following files and folders.
    
    - Remove the `org.wso2.carbon.apimgt.migrate.client-4.2.0.x.jar` file, which is in the `<API-M_4.2.0_HOME>/repository/components/dropins` directory.
    - Remove the `migration-resources` directory, which is in the `<API-M_4.2.0_HOME>` directory.

---
*By now, you should have completed all the main steps of the migration.*
