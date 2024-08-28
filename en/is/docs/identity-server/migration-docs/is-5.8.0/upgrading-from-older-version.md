# Upgrading from an Older Version of WSO2 IS

The following sections provide instructions that enable you to upgrade from older versions of WSO2 Identity Server
(from version 5.0.0 onwards) to the latest version of WSO2 Identity Server. In this topic, <OLD_IS_HOME> is the
directory that the older version of WSO2 Identity Server resides in, and <NEW_IS_HOME> is the directory that the
latest version of WSO2 Identity Server resides in.

# Before you begin

This release is a WUM-only release. This means that there are no manual patches. Any further fixes or
latest updates for this release can be updated through WSO2 Update Manager (WUM).

-   If you are upgrading to use this version in your production environment, use the WSO2 Update Manager to get the latest updates available for WSO2 IS. For more information on how to do this, see [Updating WSO2 Products](https://updates.docs.wso2.com/en/latest/).

# Migrating the embedded LDAP user store

It is not generally recommended to use the embedded LDAP user store that is shipped with WSO2 Identity Server
in production setups. However, if migration of the embedded LDAP is required, follow the instructions below to
migrate the existing WSO2 IS LDAP user store to the new version of WSO2 IS.

1.  Copy the <OLD_IS_HOME>/repository/data folder to <NEW_IS_HOME>/repository/data folder.
2.  Restart the server to save the changes.

# Migrating the configurations

You can use one of the following approaches to migrate depending on your production environment.

## Migrating by updating the custom configurations

This approach is recommended if:
-   You have done very few configuration changes in your previous version of WSO2 IS. These configuration changes have been tracked and are easy to redo.

Steps:
1.  If you have made configuration changes to the config files in your previous version of WSO2 IS, update
the files in the <NEW_IS_HOME>/repository/conf folder with your own configurations.
2.  Proceed to the [Migrating the data](#migrating-the-data) section to run the migration client.

## Migrating by updating the new configurations in 5.8.

This approach is recommended if:

-   You have done many configuration changes in your previous version of WSO2 IS. These configurations have not been tracked completely and/or are difficult to redo.

Steps:

1. Make a copy of the <OLD_IS_HOME>/repository/conf folder. (Do not change the original
configurations. You may use it as a backup in case there are any issues)
2. Copy the health-check-config.xml file from the <NEW_IS_HOME>/repository/conf directory
and paste it in the copy of the <OLD_IS_HOME>/repository/conf directory.
3. Copy the wso2-log-masking.properties file from the <NEW_IS_HOME>/repository/conf
directory and paste it in the copy of the <OLD_IS_HOME>/repository/conf directory.
4. The documents listed below provides all the configuration changes from IS 5.0.0 to IS 5.8.0. You can take a look at the relevant version and change the relevant configurations according to the features you are using.

    -   **Configuration Changes - WSO2 IS 5.0.0 to 5.1.0**
    -   **Configuration Changes - WSO2 IS 5.1.0 to 5.2.0**
    -   **Configuration Changes - WSO2 IS 5.2.0 to 5.3.0**
    -   **Configuration Changes - WSO2 IS 5.3.0 to 5.4.0**
    -   **Configuration Changes - WSO2 IS 5.4.0 to 5.5.0**
    -   **Configuration Changes - WSO2 IS 5.5.0 to 5.6.0**
    -   **Configuration Changes - WSO2 IS 5.6.0 to 5.7.0**

    > **Note:**
    >
    > The configuration changes listed above will not affect the existing system because these configurations are applied only at first start up and new tenant creation. If you want to change the configurations for the existing tenants, configure it through the management console user interface.

5. Replace the <NEW_IS_HOME>/repository/conf folder with the modified copy of the <OLD_IS_HOME>
/repository/conf folder.
6. Proceed to the [Migrating the data](#migrating-the-data) section to run the migration client.

## Migrating the custom components

Any custom OSGI bundles which were added manually should be recompiled with new dependency versions that
are relevant to the new WSO2 IS version. All custom OSGI components reside in the <OLD_IS_HOME>
/repository/components/dropins directory.

1.  Get the source codes of the custom OSGI components located in the dropins directory.
2.  Change the dependency versions in the relevant POM files according to the WSO2 IS version that you are upgrading to, and compile them. The compatible dependency versions for each release of WSO2 IS is given below.
    -   [WSO2 Identity Server 5.1.0](https://github.com/wso2/product-is/blob/v5.1.0/pom.xml)
    -   [WSO2 Identity Server 5.2.0](https://github.com/wso2/product-is/blob/v5.2.0/pom.xml)
    -   [WSO2 Identity Server 5.3.0](https://github.com/wso2/product-is/blob/v5.3.0/pom.xml)
    -   [WSO2 Identity Server 5.4.0](https://github.com/wso2/product-is/blob/v5.4.0/pom.xml)
    -   [WSO2 Identity Server 5.5.0](https://github.com/wso2/product-is/blob/v5.5.0/pom.xml)
    -   [WSO2 Identity Server 5.6.0](https://github.com/wso2/product-is/blob/v5.6.0/pom.xml)
    -   [WSO2 Identity Server 5.7.0](https://github.com/wso2/product-is/blob/v5.7.0/pom.xml)
3.  If you come across any compile time errors, refer to the WSO2 IS code base and make the necessary changes related to that particular component version.
4.  Add the compiled JAR files to the <NEW_IS_HOME>/repository/components/dropins directory.
5.  If there were any custom OSGI components in <OLD_IS_HOME>/repository/components/lib directory, add newly compiled versions of those components to the <NEW_IS_HOME>/repository/components/lib directory.

## Migrating the data

To upgrade the version of WSO2 Identity Server, the user store database should be upgraded. Note that there are
no registry schema changes between versions.

Follow the steps below as needed to complete the migration process.

Download the latest version of WSO2 Identity Server and unzip it in the <NEW_IS_HOME> directory.

1.  Take a backup of the existing database used by the <OLD_IS>. This backup is necessary in case the migration causes issues in the existing database.Make the following database updates as indicated below.

    1.  Get the `wso2is-migration-x.x.x.zip` file provided by the WSO2 team. Unzip it to a local directory. This folder is referred to as <IS_MIGRATION_TOOL_HOME>.

    2.  Copy the org.wso2.carbon.is.migration-x.x.x.jar file in the <IS_MIGRATION_TOOL_HOME>/dropins folder into the <NEW_IS_HOME>/repository/components/dropins directory.
    3.  Copy the migration-resources folder to the <NEW_IS_HOME> root folder.
    4.  Set the following property values accordingly in the migration-config.yaml file found in the <NEW_IS_HOME>/migration-resources folder. Specify the current WSO2 Identity Server version as the currentVersion value and specify the new version of WSO2 Identity Server that you want to migrate to, as the migrateVersion.

    > **Note**
    >
    > If your current version of WSO2 Identity Server is 5.4.1, set the value of the currentVersion parameter to 5.4.0 in the migration-config.yaml instead. This is because data migration is not required when migrating from 5.4.0 to 5.4.1.

    ```
    migrationEnable: "true"

    currentVersion: "5.x.x"

    migrateVersion: "5.x.x"
    ```

2.  Copy any custom OSGI bundles that were added manually from the <OLD_IS_HOME>/repository/components/dropins folder and paste it in the <NEW_IS_HOME>/repository/components/dropinsfolder.
3.  Copy any added JAR files from the <OLD_IS_HOME>/repository/components/lib folder and paste it in the <NEW_IS_HOME>/repository/components/lib folder.
4.  Copy the .jks files from the <OLD_IS_HOME>/repository/resources/security folder and paste them in <NEW_IS_HOME>/repository/resources/security folder.
5.  If you have created tenants in the previous WSO2 Identity Server version and if there are any resources in the <OLD_IS_HOME>/repository/tenants directory, copy the content to the <NEW_IS_HOME> /repository/tenants directory.
6.  If you have created secondary user stores in the previous WSO2 IS version, copy the content in the <OLD_IS_HOME>/repository/deployment/server/userstores directory to the <NEW_IS_HOME>/repository/deployment/server/userstores directory.

    >> **Note** 
    >>
    >> If your current version is 5.0.0, run the following queries on the database that is >referenced in the identity.xml file in order to identify if there is any corrupted data.
    >
    >```
    >SELECT * FROM IDN_OAUTH2_ACCESS_TOKEN WHERE AUTHZ_USER LIKE '% @%' AND
    >
    >TOKEN_STATE='ACTIVE';
    >SELECT * FROM IDN_OAUTH2_ACCESS_TOKEN WHERE AUTHZ_USER NOT LIKE '%@%'
    >AND TOKEN_STATE='ACTIVE';
    >```


7.  Start WSO2 Identity Server with the following command to perform the data migration for all components.

    -   Linux/Unix:

        ```
        sh wso2server.sh -Dmigrate -Dcomponent=identity
        ```

    -   Windows:

        ```
        wso2server.bat -Dmigrate -Dcomponent=identity
        ```

8.  Once the migration is successful, stop the server and remove the following files and folders from the <NEW_IS_HOME>/repository/components/dropins directory.

    -   org.wso2.carbon.is.migration-5.x.x.jar
    -   snakeyaml-1.16.0.wso2v1.jar
    -   migration-resources directory



