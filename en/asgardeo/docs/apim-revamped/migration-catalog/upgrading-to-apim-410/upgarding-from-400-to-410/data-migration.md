<small> 1. Config Migration > 2. Resource & Artifact Migration > 3. Extensions & Customizations Migration > [4. Data Migration](./data-migration.md) > 5. Server Startup </small>

# Data Migration

> **Important**
>  
> To ensure the integrity of the database during the following steps, it is recommended to create database backups before each step. This precaution allows you to resume from the current step in case of an issue, instead of starting from the beginning. For instance, if you complete the Identity Server (IS) component migration and create a backup, you can resume from the API Manager (APIM) component migration step if something goes wrong, rather than repeating the IS component migration.

## Prerequisites

1. Follow the [Data Migration Guidelines](../../../general-data-migration.md).
   
2. Check on the [Tested DBMS](https://apim.docs.wso2.com/en/4.1.0/install-and-setup/setup/reference/product-compatibility/#tested-dbmss) for API-M 4.1.0. Only those versions will be supported in migration as well. Therefore, if you are currently on an older database version, please migrate your database to the supported version first before proceeding with the migration.

## Step 1: Run the Database Scripts

From DB scripts included [here](../../../../../../api-manager/migration-resources/apim-4.1.0-resources/db-scripts/upgrading-from-400-to-410), run the script corresponding to your DB type on the `shared_db` (used as the registry database).

## Step 2: Migration the API Manager Data

> **Warning**
>  
> If you are using PostgreSQL for registry database, add the following parameter `preparedStatementCacheQueries=0` to the JDBC URL in `<API-M_4.1.0_HOME>/repository/conf/deployment.toml` as below before running the migration client.  This is needed because API-M migration client is running schema upgrades (i.e. DDL statements) to registry databases while APIM back-end is using the same registry tables in the databases.
>  ```toml
>  [database.shared_db]
>  type = "postgre"
>  url = "jdbc:postgresql://localhost:5432/reg_db?preparedStatementCacheQueries=0"
>  ```
>  
> If you are using a separate PostgreSQL database for the WSO2CONFIG_DB, add the same to the `<API-M_4.1.0_HOME>/repository/conf/deployment.toml` as below.
>  ```toml
>  [database.config]
>  type = "postgre"
>  url = "jdbc:postgresql://localhost:5432/config_db?preparedStatementCacheQueries=0"
>  ```

1. Download the `wso2am-migration-4.1.0.x.zip` (APIM component migration resources) from [here](../../../../../../api-manager/migration-resources/apim-4.1.0-resources/attachments/apim) and unzip it in a local directory.

2. Copy the `migration-resources` to the `<API-M_4.1.0_HOME>` folder.

3. Copy the `org.wso2.carbon.apimgt.migrate.client-4.1.0.x.jar` file residing in `<wso2am-migration-4.1.0.x>/dropins` into the `<API-M_4.1.0_HOME>/repository/components/dropins` directory.

> Note
>
> If the older API-M setup has been configured for a different admin role other than admin and if the role is not persisted in read-only user store, make sure not to change the admin_role configuration in the deployment.toml this time.

> **Important**
> 
> If you have configured WSO2 IS 5.11.0 as Key Manager, make sure you have already started the WSO2 Identity Server instance before executing the next step.


4. Run the below command to execute the pre-migration step that will validate your old data. If you're working with a distributed setup, remember to add the `-Dprofile=control-plane` property to the following commands as well.

    - Linux / Mac OS
      ```bash
      sh api-manager.sh -Dmigrate -DmigrateFromVersion=4.0.0 -DmigratedVersion=4.1.0 -DrunPreMigration
      ```
    - Windows
      ```bash
      api-manager.bat -Dmigrate -DmigrateFromVersion=4.0.0 -DmigratedVersion=4.1.0 -DrunPreMigration
      ```

    If you want to save the invalid API definitions,
    
    - Linux / Mac OS
      ```bash
      sh api-manager.sh -Dmigrate -DmigrateFromVersion=4.0.0 -DmigratedVersion=4.1.0 -DrunPreMigration -DsaveInvalidDefinition
      ```
    - Windows
      ```bash
      api-manager.bat -Dmigrate -DmigrateFromVersion=4.0.0 -DmigratedVersion=4.1.0 -DrunPreMigration -DsaveInvalidDefinition
      ```


5. Start the API-M server to migrate the API-M components as follows. If you're working with a distributed setup, remember to add the `-Dprofile=control-plane` property to the following commands as well.

    - Linux / Mac OS
      ```bash
      sh api-manager.sh -Dmigrate -DmigrateFromVersion=4.0.0 -DmigratedVersion=4.1.0
      ```
    - Windows
      ```bash
      api-manager.bat -Dmigrate -DmigrateFromVersion=4.0.0 -DmigratedVersion=4.1.0
      ```

6. After you have successfully completed the migration, stop the server and remove the following files and folders.
    
    - Remove the `org.wso2.carbon.apimgt.migrate.client-4.1.0.x.jar` file, which is in the `<API-M_4.1.0_HOME>/repository/components/dropins` directory.
    - Remove the `migration-resources` directory, which is in the `<API-M_4.1.0_HOME>` directory.

---
*By now, you should have completed all the main steps of the migration.*
