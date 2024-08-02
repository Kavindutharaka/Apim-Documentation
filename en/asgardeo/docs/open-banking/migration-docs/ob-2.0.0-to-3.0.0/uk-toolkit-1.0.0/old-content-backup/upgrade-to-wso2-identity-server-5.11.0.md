# Upgrade to WSO2 Identity Sever 5.11.0

# Prerequisites

WSO2 Identity Sever 5.10.0 is a base product of WSO2 Open Banking 2.0.0. Therefore, we assume you already have WSO2 Identity Sever 5.10.0.

## Set up IS 5.11.0 as Key Manager for API Manager 4.0.0

   1. Download and install the WSO2 Identity Server 5.11.0 distribution from [here](https://wso2.com/identity-server/).

   2. Extract the downloaded archive file. This document refers to the root folder of the extracted file as `<IS_HOME>`.

## Migrate to WSO2 Identity Sever 5.11.0

1. Get the **Upgrading WSO2 IS as Key Manager to 5.11.0** documentation (`Upgrade IS as Key Manager 5.10.0 to IS 5.11.0 for APIM 3.2.0 to 4.0.0.md`) provided by the WSO2 team.

 - Follow **Step B - Migrate IS from 5.10.0 to 5.11.0** under **Step 1 - Upgrade IS as Key Manager 5.10.0 to IS 5.11.0** in the above-mentioned document and upgrade your WSO2 Identity Server.

2. Get the **Upgrading WSO2 Identity Server to 5.11.0** documentation (`migrating-to-5110.md`) provided by the WSO2 team.

 - Follow **WSO2 Identity Server Migrating to 5.11.0** to upgrade your current **IS as KM 5.10.0** distribution to IS 5.11.0 by following the provided documentation.
    
    >**Note**
    >
    >    In the above documentation, under **Steps to migrate to 5.11.0**,
    >
    >    1. Skip steps 1,2, and 4.
    >    2. **Do not** copy the API Manager - Key Manager specific configurations from 
    >       `<OLD_IS_KM_HOME>/repository/conf/api-manager.xml` of the previous IS as KM version to IS 5.11.0.
    >    
    >    3. Before executing the IS migration client according to Step 10, remove the following entries from 
              `migration-config.yaml` in the migration-resources directory:
    >
    >       ```yaml
    >       - version: "5.10.0"
    >         migratorConfigs:
    >           -
    >           name: "MigrationValidator"
    >           order: 2
    >           -
    >           name: "SchemaMigrator"
    >           order: 5
    >           parameters:
    >           location: "step2"
    >           schema: "identity"
    >           -
    >           name: "TenantPortalMigrator"
    >           order: 11
    >       ```
    > 
    >    4. Follow the step 11, only if you have enabled Symmetric Key Encryption in the previous IS as KM setup. If not, skip step 11.

    >**Warning**
    >
    >    Based on the number of records in the identity tables, the identity component migration will take a considerable time. 
        Do not stop the server during the migration process. Wait until the migration process finishes completely and the server gets started.

4. After successfully completing the migration, stop the server and remove the following directories and files.
     - Remove the `<IS_HOME>/repository/components/dropins/org.wso2.carbon.is.migration-x.x.x.jar` file.
     - Remove the `<IS_HOME>/migration-resources` directory.
