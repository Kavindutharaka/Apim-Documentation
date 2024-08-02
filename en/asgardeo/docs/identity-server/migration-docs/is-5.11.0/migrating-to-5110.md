# Migrating to 5.11.0

This section guides you through migrating from the earlier IS version to IS 5.11.0.

## Prerequisites

Make sure you have met the following prerequisites before proceeding with the instructions to migrate to 5.11.0. See the **Prepare for Migration** document.

> **Note**
>
> In this section, `<OLD_IS_HOME>` is the directory that the current Identity Server resides in, and `<NEW_IS_HOME>` is the WSO2 Identity Server 5.11.0 resides in. 
>
> -   **If you are using DB2**
>
>      Move indexes to the TS32K Tablespace. The index tablespace in the `IDN_OAUTH2_ACCESS_TOKEN`  and `IDN_OAUTH2_AUTHORIZATION_CODE` tables need to be moved to the existing TS32K tablespace to support newly added table indexes.
    SQLADM or DBADM authority is required to invoke the `ADMIN_MOVE_TABLE` stored procedure. You must also have the appropriate object creation authorities, including authorities to issue the **SELECT** statement on the source table, and to issue the **INSERT** statement on the target table.
>
>   -   Stored procedure
>   
>        Replace the >`<TABLE_SCHEMA_OF_IDN_OAUTH2_ACCESS_TOKEN_TABLE>` and >`<TABLE_SCHEMA_OF_IDN_OAUTH2_AUTHORIZATION_CODE_TABLE>` tags >with the respective schema for the table. 
>
>        ``` sql
>        CREATE BUFFERPOOL BP32K IMMEDIATE SIZE 250 AUTOMATIC >PAGESIZE 32K;
>
>        CREATE LARGE TABLESPACE TS32K PAGESIZE 32K MANAGED by >AUTOMATIC STORAGE BUFFERPOOL BP32K;
>
>        CALL SYSPROC.ADMIN_MOVE_TABLE(
>        <TABLE_SCHEMA_OF_IDN_OAUTH2_ACCESS_TOKEN_TABLE>,
>        'IDN_OAUTH2_ACCESS_TOKEN',
>        (SELECT TBSPACE FROM SYSCAT.TABLES WHERE 
>        TABNAME = 'IDN_OAUTH2_ACCESS_TOKEN' AND 
>        TABSCHEMA = <TABLE_SCHEMA_OF_IDN_OAUTH2_ACCESS_TOKEN_TABLE>),
>        'TS32K',
>        (SELECT TBSPACE FROM SYSCAT.TABLES WHERE 
>        TABNAME = 'IDN_OAUTH2_ACCESS_TOKEN' AND 
>        TABSCHEMA = <TABLE_SCHEMA_OF_IDN_OAUTH2_ACCESS_TOKEN_TABLE>),
>        '',
>        '',
>        '',
>        '',
>        '',
>        'MOVE');
>
>        CALL SYSPROC.ADMIN_MOVE_TABLE(
>        <TABLE_SCHEMA_OF_IDN_OAUTH2_AUTHORIZATION_CODE_TABLE>,
>        'IDN_OAUTH2_AUTHORIZATION_CODE',
>        (SELECT TBSPACE FROM SYSCAT.TABLES WHERE 
>        TABNAME = 'IDN_OAUTH2_AUTHORIZATION_CODE' AND 
>        TABSCHEMA = ><TABLE_SCHEMA_OF_IDN_OAUTH2_AUTHORIZATION_CODE_TABLE>),
>        'TS32K',
>        (SELECT TBSPACE FROM SYSCAT.TABLES WHERE 
>        TABNAME = 'IDN_OAUTH2_AUTHORIZATION_CODE' AND 
>        TABSCHEMA = ><TABLE_SCHEMA_OF_IDN_OAUTH2_AUTHORIZATION_CODE_TABLE>),
>        '',
>        '',
>        '',
>        '',
>        '',
>        'MOVE');
>        ```
>
>    If you receive an error due to missing `SYSTOOLSPACE` or   `SYSTOOLSTMPSPACE` tablespaces, create those tablespaces >manually using the following script before executing the stored >procedure given above. For more information, see [SYSTOOLSPACE >and SYSTOOLSTMPSPACE table spaces](https://www.ibm.com/support/>knowledgecenter/en/SSEPGG_10.5.0/com.ibm.db2.luw.admin.gui.doc/>doc/c0023713.html) in the IBM documentation.
>
>    ``` sql
>    CREATE TABLESPACE SYSTOOLSPACE IN IBMCATGROUP
>      MANAGED BY AUTOMATIC STORAGE USING STOGROUP IBMSTOGROUP
>      EXTENTSIZE 4;
>
>    CREATE USER TEMPORARY TABLESPACE SYSTOOLSTMPSPACE IN IBMCATGROUP
>      MANAGED BY AUTOMATIC STORAGE USING STOGROUP IBMSTOGROUP
>      EXTENTSIZE 4;
>    ```

---

## Steps to migrate to 5.11.0

Once all the above prerequisites have been met, follow the instructions given below to migrate to the latest version.

1. If you have manually added any custom OSGI bundles to the `<OLD_IS_HOME>/repository/components/dropins` directory, copy those OSGI bundles to the `<NEW_IS_HOME>/repository/components/dropins` directory.

    > **Important**
    >
    > You may need to update the custom components to work with WSO2 Identity Server 5.11.0. Refer the instruction **Migrating custom components** in the **Prepare for Migration** documentaion.

2. If you have manually added JAR files to the `<OLD_IS_HOME>/repository/components/lib` directory, copy and paste those JARs into the `<NEW_IS_HOME>/repository/components/lib` directory.

3. Copy the `.jks` files from the `<OLD_IS_HOME>/repository/resources/security` directory and paste them in the `<NEW_IS_HOME>/repository/resources/security` directory.

    > **Note**
    >
    > In WSO2 Identity Server 5.11.0, it is required to use a certificate with an RSA key size greater than 2048. If you used a certificate with a weak RSA key (key size less than 2048) in the previous IS version, add the following configuration to `<NEW_IS_HOME>/repository/conf/deployment toml` to configure internal and primary key stores.
    >
    >   ```toml
    >   [keystore.primary]
    >   file_name = "primary.jks"
    >   type = "JKS"
    >   password = "wso2carbon"
    >   alias = "wso2carbon"
    >   key_password = "wso2carbon"
    >
    >   [keystore.internal]
    >   file_name = "internal.jks"
    >   type = "JKS"
    >   password = "wso2carbon"
    >   alias = "wso2carbon"
    >   key_password = "wso2carbon"
    >   ```
    >
    > Make sure to point the internal keystore to the keystore copied from the previous WSO2 Identity Server version. The primary keystore can be pointed to a keystore with a certificate with a strong RSA key.

4. If you have created tenants in the previous WSO2 Identity Server version, copy the content from the `<OLD_IS_HOME>/repository/tenants` folder to the `<NEW_IS_HOME>/repository/tenants` folder.

    > **Note**
    > 
    > If you are migrating from IS 5.8.0 or a lower version, delete the `eventpublishers` and `eventstreams` folders from each tenant in the `tenants` folder when copying to IS 5.11.0. Make sure to **back up** the `tenants` folder before deleting the subfolders. You can use the following set of commands to find and delete all the relevant sub-folders at once:
    >
    >    ```
    >    cd <NEW_IS_HOME>/repository/tenants
    >    find . -type d -name 'eventpublishers' -exec rm -rf {} +
    >    find . -type d -name 'eventstreams' -exec rm -rf {} +
    >    ```

5. If you have created secondary user stores for the super tenant in the previous WSO2 IS version, copy the content in the `<OLD_IS_HOME>/repository/deployment/server/userstores` folder to the `<NEW_IS_HOME>/repository/deployment/server/userstores` folder. Secondary user stores of other tenants were migrated when you migrated the `tenants` folder in the previous step.

6. If you have customized any existing web apps in the previous WSO2 Identity Server version, you should manually apply those changes to the relevant files with careful inspection.

    If you have deployed custom webapps in the previous WSO2 Identity Server, update the webapps to be compatible with WSO2 IS 5.11.0 and copy the webapps to the `<NEW_IS_HOME>/repository/deployment/server/webapps` folder.

7. Ensure that you have migrated the configurations into the new version as advised in the document on **preparing for migration** document.
8. Make sure that all the properties in the `<IS_HOME>/repository/conf/deployment.toml` file, such as the database configurations, are set to the correct values based on the requirement.

9. Replace the `<NEW_IS_HOME>/repository/conf/email/email-admin-config.xml` file with
   `<OLD_IS_HOME>/repository/conf/email/email-admin-config.xml`.   

10. Follow the steps given below to perform database updates:
    1. Get the **migration client** (`wso2is-migration-x.x.x.zip`) provided by the WSO2 team.

        > **Note**
        > - **x.x.x** of `wso2is-migration-x.x.x.zip` denotes the version number of the most recently-released migration resources.
        > - The directory where the `wso2is-migration-x.x.x.zip` is unzipped will be referred to as ` <IS_MIGRATION_TOOL_HOME> `.

    2. Copy the `org.wso2.carbon.is.migration-x.x.x.jar` file in the `<IS_MIGRATION_TOOL_HOME>/dropins` directory into the `<NEW_IS_HOME>/repository/components/dropins` directory.

    3. Copy migration-resources directory to the `<NEW_IS_HOME>` root directory.

    4. Ensure that the property values are as follows in the `<NEW_IS_HOME>/migration-resources/migration-config.yaml` file.

        ``` java
        migrationEnable: "true"

        currentVersion: "5.7.0"

        migrateVersion: "5.11.0"
        ```
        
        > **Note**
        >
        > Here, the `currentVersion` is the current WSO2 Identity Server version that you are using.

        -   **If you are using PostgreSQL**

            During the migration, "uuid-ossp" extension is created in the database. To create this extension, the database user should have permission for the '**Superuser**. If the user is not already a superuser, assign the permission before starting the migration.
           
            ```
            ALTER USER <user> WITH SUPERUSER;
            ```

11. Configure the **SymmetricKeyInternalCryptoProvider** as the default internal cryptor provider.

    1. Generate your secret key using a tool like OpenSSL.

        ```tab="Example"
        openssl enc -nosalt -aes-128-cbc -k hello-world -P
        ```

    2. Add the configuration to the `<NEW_IS_HOME>/repository/conf/deployment.toml` file.

        ```toml
        [encryption]
        key = "<provide-your-key-here>"
        ```

    3. Open the `<NEW_IS_HOME>/migration-resources/migration-config.yaml` file. The following two migrators are configured under **migratorConfigs** for 5.11.0.
        - EncryptionAdminFlowMigrator
        - EncryptionUserFlowMigrator

    4. If you're migrating from a version prior to WSO2 IS 5.6.0, open the `<NEW_IS_HOME>/migration-resources/migration-config.yaml` file and change the value of `transformToSymmetric` to `true` as shown below.

        ```yaml 
        name: "KeyStorePasswordMigrator"
        order: 9
        parameters:
        schema: "identity"
        currentEncryptionAlgorithm: "RSA"
        migratedEncryptionAlgorithm: "RSA/ECB/OAEPwithSHA1andMGF1Padding"
        transformToSymmetric: "true"
        ```

    Under each migrator's parameters, find the property value of **currentEncryptionAlgorithm** and ensure that it matches with the value of the `org.wso2.CipherTransformation` property found in the `<OLD_IS_HOME>/repository/conf/carbon.properties` file.

12. Start the WSO2 Identity Server 5.11.0 with the following command to
    execute the migration client.

    -   Linux/Unix:

        ```bash 
        sh wso2server.sh -Dmigrate -Dcomponent=identity
        ```

    -   Windows:

        ```bash
        wso2server.bat -Dmigrate -Dcomponent=identity
        ```

13. Stop the server once the migration client execution is complete.

---

## Executing the sync tool

> **Warning**
> 
> Proceed with this step only if you have opted in for **Zero down time migration**. If not, your migration task is complete now. You can omit the following steps.

1. Start the data sync tool with the following command pointing to the `sync.properties` file. This will start syncing data created in the old WSO2 Identity Server database after taking the database dump to the new WSO2 Identity Server database.
    ```bash
    sh wso2server.sh -DsyncData -DconfigFile=<path to sync.properties file>/sync.properties
    ```

2. Monitor the logs in the sync tool to see how many entries are synced at a given time and to keep track of the progress in the data sync process. The following line will be printed in the logs in each table you have specified that has no data to be synced.

    **Sample**

    ```
    [2019-02-27 17:26:32,388]  INFO {org.wso2.is.data.sync.system.pipeline.process.BatchProcessor} -  No data to sync for: <TABLE_NAME>
    ```

    > **Info**
    >
    > If you have some traffic to the old version of the WSO2 Identity Server, the number of entries to be synced might not become zero at any time. In that case, observe the logs to decide on a point where the number of entries that are synced is low.

3. When the data sync is complete, switch the traffic from the old setup to the new setup.

4. Allow the sync client to run for some time to sync the entries that were not synced before switching the deployments. Stop the sync client when the number of entries synced by the sync tool becomes zero.

---

## Verifying the migration

After the migration is complete, proceed to the following verification steps.

+ Monitor the system's health (CPU, memory usage, etc.).
+ Monitor the WSO2 logs to see if errors are logged in the log files.
+ Run functional tests against the migrated deployment to verify that all the functionalities are working as expected.

> **Note**
> 
> - If you see any problems in the migrated system, revert the traffic to the previous setup and investigate the problem.
> - If the id token validation for the **Console** and **My Account** applications are failing, learn about **Validation of issuer in .well-known endpoint URL** in the **What has changed in 5.11.0** document.

## After migration

If you are using the data cleanup scripts to perform data purging, use the latest cleanup scripts or cleanup scripts specific to the migrated version. You can find the latest cleanup scripts from [here](https://github.com/wso2/carbon-identity-framework/tree/master/features/identity-core/org.wso2.carbon.identity.core.server.feature/resources/dbscripts/stored-procedures).
