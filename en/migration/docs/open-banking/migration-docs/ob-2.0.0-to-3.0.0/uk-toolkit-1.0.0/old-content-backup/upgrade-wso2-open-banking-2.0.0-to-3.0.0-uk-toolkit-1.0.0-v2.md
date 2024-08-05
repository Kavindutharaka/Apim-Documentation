# Upgrading WSO2 Open Banking from 2.0.0 to 3.0.0

This documentation guides on how to upgrade your WSO2 Open Banking 2.0.0 for the UK setup to WSO2 Open Banking 3.0.0 (Accelerator Model) UK Toolkit 1.0.0.

# Overview

WSO2 Open Banking solution runs on top of WSO2 Identity Server and WSO2 API Manager which are referred to as base products.

Given below is the product compatibility matrix for the WSO2 Open Banking solution. This matrix outlines the compatibility between the versions of WSO2 Open Banking solutions involved in this migration and the latest version of the base products they support.

| WSO2 Open Banking Version | Supported WSO2 Identity Server Version | Supported WSO2 API Manager Version |
|---------------------------|----------------------------------------|------------------------------------|
| 2.0.0                     | 5.10.0                                 | 3.1.0                              |
| 3.0.0                     | 6.1.0 (Latest)                         | 4.2.0 (Latest)                              |

## Prerequisites

We assume that you already have an existing WSO2 Open Banking 2.0.0 solution for the UK. WSO2 API Manager 3.1.0 and WSO2 Identity Server 5.10.0 are the base products required for WSO2 Open Banking 2.0.0. Therefore, we assume you already have WSO2 API Manager 3.1.0 and WSO2 Identity Server 5.10.0.

>**Important:**
>
>- In order to upgrade your existing Open Banking solution to the latest version, you need to upgrade the base products (WSO2 Identity Server and WSO2 API Manager) to the latest supported version as well.
>
>- Upgrading the base products involves step-by-step migrations, and therefore it requires several intermediate steps.
>- In addition to the base product migration, you need to configure WSO2 Identity Server as Key Manager. The Key Manager handles all clients, security, and access token-related operations. So you need to configure WSO2 Identity Server as Key Manager in each WSO2 API Manager migration.


The following diagram explains the flow of upgrading the WSO2 Open Banking solution:

![migration-flow](https://uk.ob.docs.wso2.com/en/latest/assets/img/install-and-setup/upgrading-the-solution/migration-flow.png)

Given below are the steps you need to follow to upgrade your WSO2 Open Banking 2.0.0 for the UK setup to WSO2 Open Banking 3.0.0 - UK Toolkit 1.0.0:

1. Upgrading WSO2 API Manager from 3.1.0 to 3.2.0 

    1. Setup IS as Key Manager 5.10.0 with API Manager 3.2.0
    2. Upgrade API Manager from 3.1.0 to 3.2.0

2. Upgrading WSO2 Identity Sever from 5.10.0 to 5.11.0 

    1. Upgrade IS as Key Manager 5.10.0 to IS 5.11.0
    2. Upgrade WSO2 Identity Sever from 5.10.0 to 5.11.0

3. Upgrading WSO2 API Manager from 3.2.0 to 4.0.0 

    1. Configuring IS as Key Manager
    2. Upgrading API Manager from 3.2.0 to 4.0.0

4. Upgrading WSO2 API Manager from 4.0.0 to 4.2.0 and WSO2 Identity Server from 5.11.0 to 6.1.0 

    1. Prepare for Migration
    2. Upgrading WSO2 Identity Server from 5.11.0 to 6.1.0
    3. Upgrading WSO2 API Manager from 4.0.0 to 4.2.0

5. Migrating Open Banking Data

   This is the step where you migrate Open Banking data. This involves moving the data from your existing Open Banking platform to the new WSO2 Open Banking platform. This includes data such as customer accounts, transactions, and permissions.

6. Migrating Reporting Data 

   Migrating Reporting Data involves moving the data from your existing reporting system to the new WSO2 Open Banking platform. This includes data such as reports, dashboards, and visualizations.

7. Configuring After Migration

   This section explains the modifications that need to be performed after the upgrade/migration process.

>**Before you begin:**
> 
>Make sure the following:
>
>    - The DCR applications created in Open Banking 2.0.0 should not contain a SoftwareId/IssuerName that includes an underscore **"_"**.
>      
>    - If you have such DCR applications, before the migration process, rename the **Service Provider Name** of each DCR application's Service Provider application by logging into `https://<IS_HOST>:9446/carbon`.
>     
>    - In your Open Banking 2.0.0 database, check the column size of the following:
>
>        | Database          | Table       | Column| Data type | Size |
>        |-------------------|-------------|-------|-----------|------|
>        |`openbank_apimgtdb`|`SP_METADATA`|`VALUE`| `VARCHAR` | 4096 |
>
>        - If the column size is less than 4096, execute the following command against the `SP_METADATA` table:
>
>             ``` 
>             ALTER TABLE SP_METADATA MODIFY VALUE VARCHAR(4096); 
>             ```

# 1. Upgrading from WSO2 API Manager 3.1.0 to WSO2 API Manager 3.2.0

This section instructs you on how to migrate WSO2 API Manager from 3.1.0 to WSO2 API Manager 3.2.0, which is a prerequisite for upgrading to the latest API Manager version.

## Prerequisites

WSO2 API Manager 3.1.0 is a base product of WSO2 Open Banking 2.0.0. Therefore, we assume you already have WSO2 API Manager 3.1.0.

Upgrading WSO2 API Manager from 3.1.0 to 3.2.0 consists of 2 steps:

a. Upgrade WSO2 IS as Key Manager 5.10.0 for API Manager 3.2.0

b. Upgrade WSO2 API Manager from 3.1.0 to 3.2.0

## a. Upgrade WSO2 IS as Key Manager 5.10.0 for API Manager 3.2.0

Follow the **Upgrading WSO2 IS as Key Manager 5.10.0 for API Manager 3.2.0** documentation (`Upgrade IS as Key Manager 5.10.0 to IS 5.10.0 for APIM 3.1.0 to 3.2.0.md`) provided by the WSO2 team and upgrade **IS as Key Manager 5.10.0 for API Manager 3.2.0**. Follow the entire documentation carefully.

## b. Upgrade WSO2 API Manager from 3.1.0 to 3.2.0

Follow the **Upgrading WSO2 API Manager from 3.1.0 to 3.2.0** documentation (`upgrading-from-310-to-320.md`) provided by the WSO2 team and upgrade WSO2 API Manager from 3.1.0 to 3.2.0. Follow the entire documentation carefully and make sure to perform the necessary custom steps mentioned below:

>**Note**
>
>    In the above documentation, under **Step 1 - Migrate the API Manager configurations**, skip steps 6,7,8, and 9 as we are only trying to migrate the databases at this level.

---

# 2. Upgrading from WSO2 Identity Sever 5.10.0 to WSO2 Identity Sever 5.11.0

This section instructs you on how to migrate WSO2 Identity Sever 5.10.0 to WSO2 Identity Sever 5.11.0, which is a prerequisite for upgrading to the latest Identity Sever version.

## Prerequisites

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

---

# 3. Upgrading from WSO2 API Manager 3.2.0 to WSO2 API Manager 4.0.0

This section instructs you on how to migrate WSO2 API Manager 3.2.0 to WSO2 API Manager 4.0.0, which is a prerequisite for upgrading to the latest Identity Sever version.

## Prerequisites

We assume you have already upgraded your API Manager to 3.2.0 as instructed in a previous step.

1. Download and install the WSO2 API Manager 4.0.0 distribution from [here](https://wso2.com/api-manager/).

2. Extract the downloaded archive file. This document refers to the root folder of the extracted file as `<APIM_HOME>`.

## Upgrade to WSO2 API Manager 4.0.0

>**Before you begin:**
>
>   Once the Identity Server 5.11.0 is configured as the Resident Key Manager, start the Identity Server 5.11.0.

1. Start the WSO2 API Manager 4.0.0 server and create a Custom Key Manager by following the
   [Configuring IS as Key Manager](https://uk.ob.docs.wso2.com/en/latest/try-out/dynamic-client-registration-flow/#configuring-is-as-key-manager) documentation.

2. Do not copy any other Key Manager specific configurations from the previous API Manager version to the latest one that points to the Identity Server.

3. Follow the **Upgrading WSO2 API Manager from 3.2.0 to 4.0.0** (`upgrading-from-320-to-400.md`) documentation provided by the WSO2 team and upgrade your API Manager from 3.2.0 to 4.0.0. Follow the entire documentation carefully and make sure to perform the necessary steps mentioned below:

   >**Note**
   >
   >    When following the above-mentioned documentation:
   >
   >    1. You can skip the steps 1,2, and 3 under **Step 1 - Migrate the API Manager configurations**.
   >
   >    2. Modify the following configurations in the `<APIM_HOME>/repository/conf/deployment.toml` file before starting the migration.
   >
   >        ``` toml
   >        [[apim.gateway.environment]]
   >        name = "Production and Sandbox"
   >        [apim.sync_runtime_artifacts.gateway]
   >        gateway_labels =["Production and Sandbox", "Default"]
   >        ```
   >
   >    3. In **Step 2 - Upgrade API Manager to 4.0.0**, skip the steps 3 and 5.

4. Start the API Manager server.

### Replace Custom Mediation Policies

This section explains how to replace the Custom Mediation Policy of each API with the latest Mediation Policy.

1. Go to the API Publisher at `https://<APIM_HOST>:9443/publisher`.
2. Select the respective API.
3. Go to **API Configurations > Runtime**.
4. Click the **Edit** button under **Request > Message Mediation** and remove the existing Custom Mediation Policy.
5. Upload the relevant insequence file from the `<APIM_HOME>/<OB_APIM_TOOLKIT_HOME>/repository/resources/apis` directory
   and click **Select**.
6. Scroll down and click **SAVE**.
7. Go to **Deployments** using the left menu pane.
8. Click **Deploy New Version**.
9. Select the **API Gateway type** and **Deploy**.
10. Repeat these steps for all APIs.

### Enable Schema Validation

This section explains how to enable Schema Validation for APIs.

1. Go to the API Publisher at `https://<APIM_HOST>:9443/publisher`.
2. Select the respective API.
3. Go to **API Configurations > Runtime**.
4. Enable Schema Validation.
5. Scroll down and click **SAVE**.
6. Go to **Deployments** using the left menu pane.
7. Click **Deploy New Version**.
8. Select the **API Gateway type** and **Deploy**.
10. Repeat these steps for all APIs except for the Dynamic Client Registration(DCR) API.

### Update Workflow-Extensions

1. Go to the Management Console `https://<APIM_HOST>:9443/carbon` and log in as the admin user. ![management_console](https://uk.ob.docs.wso2.com/en/latest/assets/img/install-and-setup/upgrading-the-solution/management-console.png)
2. Select **Resources > Browse** in the left pane. <br/> ![select-browse](https://uk.ob.docs.wso2.com/en/latest/assets/img/install-and-setup/upgrading-the-solution/select-browse.png)
3. Locate the `/_system/governance/apimgt/applicationdata/workflow-extensions.xml` file. ![workflow_extensions](https://uk.ob.docs.wso2.com/en/latest/assets/img/install-and-setup/upgrading-the-solution/workflow-extensions.png)
4. Get the `workflow.txt` provided by the WSO2 team.
5. Click **Edit as text** and replace the content with the content you received. ![edit_as_text](https://uk.ob.docs.wso2.com/en/latest/assets/img/install-and-setup/upgrading-the-solution/edit-as-text.png)

### Update API Life Cycle

1. Go to the Management Console `https://<APIM_HOST>:9443/carbon` and log in as the admin user. ![management_console](https://uk.ob.docs.wso2.com/en/latest/assets/img/install-and-setup/upgrading-the-solution/management-console.png)
2. Select **Extensions > Lifecycles**. <br/> ![select_lifecycles](https://uk.ob.docs.wso2.com/en/latest/assets/img/install-and-setup/upgrading-the-solution/select-lifecycles.png)
3. Click the **View/Edit** button for APILifeCycle. ![view_edit_lifecycles](https://uk.ob.docs.wso2.com/en/latest/assets/img/install-and-setup/upgrading-the-solution/view-edit-lifecycles.png)
4. Get the `lifecycle.txt` provided by the WSO2 team.
5. Replace the Lifecycle Source with the content you received.

###  Update Identity Provider Entity ID

1. Go to Identity Server Management Console `https://<IS_HOST>:9446/carbon` and log in as the admin user.
2. Select **Identity Providers > Resident**. ![resident_identity_provider](https://uk.ob.docs.wso2.com/en/latest/assets/img/install-and-setup/upgrading-the-solution/resident-identity-provider.png)
3. Go to **Inbound Authentication Configuration > OAuth2/OpenID Connect Configuration**.
4. Update the **Identity Provider Entity ID** to the following:
    ```
    https://<IS_HOST>:9446/oauth2/token
    ```

   ![update_resident_identity_provider](https://uk.ob.docs.wso2.com/en/latest/assets/img/install-and-setup/upgrading-the-solution/update-resident-provider-entity.png)

5. Click **Update**.

---

# 4. Upgrading from WSO2 API Manager 4.0.0 to WSO2 API Manager 4.2.0 and from WSO2 Identity Server 5.11.0 to WSO2 Identity Server 6.1.0

WSO2 Open Banking 3.0.0 - UK Toolkit 1.0.0 runs on top of WSO2 API Manager 4.2.0 and WSO2 Identity Server 6.1.0. Therefore, you need to upgrade your API Manager and Identity Server to the above-mentioned versions in order to migrate your Open Banking Solution to the latest version.

This section instructs you on how to migrate,
- WSO2 API Manager 4.0.0 to WSO2 API Manager 4.2.0
- WSO2 Identity Server 5.11.0 to WSO2 Identity Server 6.1.0

## Prerequisites

Up to this point, you have already migrated to WSO2 API Manager 4.0.0 and WSO2 Identity Server to 5.11.0 as instructed in the previous steps.

## Prepare for Migration

In the following section, you will be setting up Open Banking Accelerator and UK Toolkit for Identity Server and API Manager. 

1. Download WSO2 Identity Server 6.1.0 from [here](https://wso2.com/identity-server/) and extract the folder. This extracted folder will be referred to as `<IS_HOME>` in this document.

2. Download WSO2 API Manager 4.2.0 from [here](https://wso2.com/api-manager/) and extract the folder. This extracted folder will be referred to as `<APIM_HOME>` in this document.

3. Get WSO2 Open Banking Accelerator 3.0.0 provided by the WSO2 team.

4. Extract the WSO2 Open Banking Accelerator zip files. Get the following accelerators and extract them.

    - `wso2-obiam-accelerator-3.0.0`
    - `wso2-obam-accelerator-3.0.0`

5. Get WSO2 Open Banking UK Toolkit 1.0.0 provided by the WSO2 team. Get the following toolkits and extract them.

    - `wso2-obiam-toolkit-uk-1.0.0`
    - `wso2-obam-toolkit-uk-1.0.0`

- This document uses the following placeholders to refer to the following products:

  | Product                                             | Placeholder                  |
  |-----------------------------------------------------|------------------------------|
  | WSO2 Identity Server 6.1.0                          | `<IS_HOME>`                  |
  | WSO2 API Manager 4.2.0                              | `<APIM_HOME>`                |
  | WSO2 Open Banking Identity Server Accelerator 3.0.0 | `<OB_IS_ACCELERATOR_HOME>`   |
  | WSO2 Open Banking API Manager Accelerator 3.0.0     | `<OB_APIM_ACCELERATOR_HOME>` |
  | WSO2 Open Banking Identity Server UK Toolkit 1.0.0  | `<OB_IS_TOOLKIT_HOME>`       |
  | WSO2 Open Banking API Manager UK Toolkit 1.0.0      | `<OB_APIM_TOOLKIT_HOME>`     |

6. Follow the [Getting WSO2 Updates](https://uk.ob.docs.wso2.com/en/latest/get-started/quick-start-guide/#getting-wso2-updates) documentation and update the base products, accelerators, and toolkits using relevant scripts.

7. Run the `merge.sh` script in `<APIM_HOME>/<OB_APIM_ACCELERATOR_HOME>/bin` and `<IS_HOME>/<OB_IS_ACCELERATOR_HOME>/bin` respectively to copy the Open Banking artifacts into the base product packs.

   ```
   ./merge.sh
   ```

8. Run the `merge.sh` script in `<APIM_HOME>/<OB_APIM_TOOLKIT_HOME>/bin` and `<IS_HOME>/<OB_IS_TOOLKIT_HOME>/bin` respectively:

   ```
   ./merge.sh
   ```

9. Add the relevant modifications to the `wso2is-5.11.0-deployment-uk.toml` file in the `<IS_HOME>/<OB_IS_TOOLKIT_HOME>/repository/resources` directory.

10. Rename `wso2is-5.11.0-deployment-uk.toml` to `deployment.toml`.

11. Copy the `deployment.toml` file to the `<IS_HOME>/repository/conf` directory to replace the existing file.

12. Open the `<IS_HOME>/repository/conf/deployment.toml` file, and configure the hostnames and databases related
   properties accordingly.
    - When configuring database related properties, ensure that the datasources are pointing to the existing databases.

13. Add the relevant modifications to the `wso2am-4.0.0-deployment-uk.toml` file in the `<APIM_HOME>/<OB_APIM_TOOLKIT_HOME>/repository/resources` directory.

14. Rename `wso2am-4.0.0-deployment-uk.toml` to `deployment.toml`.

15. Copy the `deployment.toml` file to the `<APIM_HOME>/repository/conf` directory to replace the existing file.

16. Open the `<APIM_HOME>/repository/conf/deployment.toml` file, and configure the hostnames and databases related
    properties accordingly.
    - When configuring database related properties, ensure that the datasources are pointing to the existing databases.

17. Add the following configurations needed for Identity Server 6.1.0 and API Manager 4.2.0.

    1. Add the following configuration in IS 6.1.0 deployment.toml

        ```toml
        [application_mgt]
        enable_role_validation = true
        ```

    2. Add the following configuration in the `deployment.toml` file of API Manager 4.2.0 after the configurations done under `[open_banking.dcr]`. Note that the version must be specified as `v3` for API Manager 4.2.0.

        ```toml
        [open_banking.dcr.apim_rest_endpoints]
        app_creation = "api/am/devportal/v3/applications"
        key_generation = "api/am/devportal/v3/applications/application-id/map-keys"
        api_retrieve = "api/am/devportal/v3/apis"
        api_subscribe = "api/am/devportal/v3/subscriptions/multiple"
        retrieve_subscribe="api/am/devportal/v3/subscriptions”
        ```

- Now all the Open Banking related artifacts and configurations are included in the base packs.

## Upgrading WSO2 Identity Server from 5.11.0 to 6.1.0

1. Follow the **Upgrade IS 5.11.0 to IS 6.0.0 for APIM 4.0.0 to 4.2.0** documentation (`Upgrade IS 5.11.0 to IS 6.0.0 for APIM 4.0.0 to 4.2.0.md`) provided by the WSO2 team to upgrade WSO2 Identity Server from 5.11.0 to 6.1.0. Follow the entire documentation carefully and make sure to perform the necessary custom steps mentioned below:

   > **Note:**
   >
   > Please note that the instructions provided in the above-mentioned document are also applicable for WSO2 Identity Server 6.1.0.

2. Follow the step 4 under **Step A: Upgrade IS 5.11.0 to IS 6.0.0** > **Step 1: Migrate the IS configurations** if applicable.

3. Step 5 under **Step A: Upgrade IS 5.11.0 to IS 6.0.0** > **Step 1: Migrate the IS configurations** refers to the `Configurations` section of the **Migrating to 6.1.0** documentation (`migrate-to-610.md`). Skip the step 3 of that section.

4. Follow the steps mentioned in the `Note` provided under the step 5 under **Step A: Upgrade IS 5.11.0 to IS 6.0.0** > **Step 1: Migrate the IS configurations**.

   > **Note:**
   >
   > Here, we need to point the datasources to the existing databases.

5. When following the step 2 of the **Step 2: Migrate the IS Resources** in the above-mentioned document, use the IS connector related to the API Manager 4.2.0 provided by the WSO2 team (`wso2is-extensions-1.6.8.zip`). Please use the jar versions included in the provided `wso2is-extensions-1.6.8.zip` folder.

6. For the step 4 under the **Step 2: Migrate the IS Resources** topic in the above-mentioned documentation please refer to the **Migrating to 6.1.0** documentation (`migrate-to-610.md`). Follow all the steps in **Step A: Upgrade IS 5.11.0 to IS 6.0.0/6.1.0** in order, skipping the steps mentioned below.

    1. Skip the **Components** section under **Step 1: Migrate artifacts and configs** when following the above-mentioned documentation (`migrate-to-610.md`).

    2. When following the **Resources** section under **Step 1: Migrate artifacts and configs**, skip the configurations included inside the **Note**.

    3. Skip the **Tenants** section under **Step 1: Migrate artifacts and configs**.

    4. The **User Stores** section under **Step 1: Migrate artifacts and configs** is optional.

    5. Skip the **Webapps** section under **Step 1: Migrate artifacts and configs**.

    6. The instructions under the **Configurations** section is already followed at this point. Therefore, not need to follow that..

7. When following **Step 3: Migrate the IS Components** in the **Upgrade IS 5.11.0 to IS 6.0.0 for APIM 4.0.0 to 4.2.0** documentation (`Upgrade IS 5.11.0 to IS 6.0.0 for APIM 4.0.0 to 4.2.0.md`) use the migration tool provided by the WSO2 team (`wso2is-migration-1.1.163.zip`).

8. Then run the migration tool at the step 8 after following the rest of the instructions.

- Following the **Step A: Upgrade IS 5.11.0 to IS 6.0.0/6.1.0** of the **Upgrade IS 5.11.0 to IS 6.0.0 for APIM 4.0.0 to 4.2.0** documentation (`Upgrade IS 5.11.0 to IS 6.0.0 for APIM 4.0.0 to 4.2.0.md`) with the above instructions, concludes the Identity Server migration.

Then start the API Manager migration.

## Upgrading WSO2 API Manager from 4.0.0 to 4.2.0

Follow the **Upgrading API Manager from 4.0.0 to 4.2.0** documentation (`upgrading-from-400-to-420.md`) provided by the WSO2 team to perform the API Manager migration. Follow the entire documentation carefully and make sure to perform the necessary custom steps mentioned below:

1. When following step 1 in **Step 1: Migrate the API Manager Configurations**, make sure to point the datasources to the existing databases.

2. When setting the `realm_manager`, set it as same as the datasource name of the user database of Open Banking (for example, by default it is `WSO2UM_DB`.)

3. Skip step 3 under **Step 1: Migrate the API Manager Configurations**.

4. Follow step 4 under **Step 1: Migrate the API Manager Configurations** if applicable.

5. For the step 5 under **Step 1: Migrate the API Manager Configurations** use the relevant database scripts provided by the WSO2 team (`db-scripts/upgrading-from-400-to-420`).

6. When following **Step 2: Migrate the API Manager Resources** in the above-mentioned documentation,

    - Skip steps 2 and 3.
    - Follow the step 4 only if the secure vault is enabled.
    - Skip step 5 if the setup does not have a secondary user store.
    - Skip step 6.

7. Skip **Step 3: Migrate the Identity Components**.

8. When migrating the API Manager components under **Step 4: Migrate the API Manager Components**, use the latest API Manager migration tool provided by the WSO2 team (`wso2am-migration-4.2.0.54.zip`).

9. Before running the migration tool for APIM migration, make sure the Identity Server is up.

10. Skip the instructions inside the **Note** under **Step 6: Restart the API Manager Server**.

11. Restart the WSO2 API Manager Server.

- Following the **Upgrading API Manager from 4.0.0 to 4.2.0** documentation (`upgrading-from-400-to-420.md`) with the above instructions, concludes the API Manager migration.

---

# 5. Migrating Open Banking Data

In this step, you will transfer your Open Banking data from your existing Open Banking 2.0.0 platform to the new WSO2 Open Banking 3.0.0 platform. This process includes moving important information such as customer accounts, transactions, and permissions.

>**Before you begin:**
>
>    Back up all the databases before performing the migration.

1. To create the required database tables:
    - Run the relevant SQL script in the `<IS_HOME>/dbscripts/open-banking/consent` directory against
      the `openbank_openbankingdb` database.
2. Get the WSO2 Open Banking Migration Client Tool v1.0.0 (`wso2-openbanking-migration-1.0.0.zip`) provided by the WSO2 team.
3. Copy the `wso2-openbanking-migration-1.0.0/openbanking-migration-resources` directory to `<IS_HOME>`.
4. Copy the `wso2-openbanking-migration-1.0.0/dropins/com.wso2.openbanking.migration-1.0.0.jar` file to `<IS_HOME>/repository/components/dropins`.
5. Open the `wso2-openbanking-migration-1.0.0/openbanking-migration-resources/migration-config.yaml` file and
   set the `migrationEnable` property to `true`.
6. Start the Identity Server with the following command:

    ```
       sh wso2server.sh -DobMigrationSpec=UK
    ```

7. Stop the server.

   >**Warning**
   >
   >    If a failure occurred during the migration process, delete all the migrated data from the tables that
   were generated during migration.

8. Remove the `<IS_HOME>/repository/components/dropins/com.wso2.openbanking.migration-1.0.0.jar` file.
9. Remove the `<IS_HOME>/openbanking-migration-resources` directory.
10. Start the Identity Server and API Manager servers.

---

# 6. Migrating Reporting Data

In this step, you will transfer data from your existing reporting system to the new WSO2 Open Banking platform. This will involve moving data related to reports, dashboards, and visualizations.

>**Before you begin:**
>
>    Make sure you are running Data Reporting v3.1.5 in your WSO2 Open Banking Business Intelligence 2.0.0 setup.
>    If not, follow the [Upgrading Data Reporting from v3.1.2 to v3.1.5](https://docs.wso2.com/display/OB200/PSD2+Data+Reporting#PSD2DataReporting-DataReportingv3.1.5)
documentation and upgrade.

1. Stop the WSO2 Open Banking Business Intelligence 2.0.0 server if it is running.
2. Download and install the WSO2 Streaming Integrator 4.0.0 distribution from [here](https://wso2.com/integration/streaming-integrator/).
3. Backup your `openbank_ob_reporting_statsdb` and `openbank_ob_reporting_summarizeddb` databases of your WSO2 Open Banking Business Intelligence 2.0.0 setup.

## Set up Open Banking Accelerator and UK Toolkit for Streaming Integrator

Set up WSO2 Open Banking Business Intelligence Accelerator and WSO2 Open Banking Business Intelligence UK Toolkit
as follows:

>**Note**
>
>    - `<SI_HOME>` refers to the root directory of WSO2 Streaming Integrator.
>    - `<OB_BI_ACCELERATOR_HOME>` refers to the root directory of WSO2 Open Banking Business Intelligence Accelerator.
>    - `<OB_BI_TOOLKIT_HOME>` refers to the root directory of WSO2 Open Banking Business Intelligence UK Toolkit.

1. Copy and extract the `wso2-obbi-accelerator-3.0.0.zip` accelerator file in the root directory of WSO2 Streaming
   Integrator.

2. Run the `merge.sh` script in `<SI_HOME>/<OB_BI_ACCELERATOR_HOME>/bin`:

    ```
    ./merge.sh
    ```

3. Copy and extract the `wso2-obbi-toolkit-uk-1.0.0.zip` toolkit file in the root directory of WSO2 Streaming
   Integrator.

4. Run the `merge.sh` script in `<SI_HOME>/<OB_BI_TOOLKIT_HOME>/bin`.

    ```
    ./merge.sh
    ```

5. Replace the existing `deployment.yaml` file in the Streaming Integrator as follows:
    - Go to the `<SI_HOME>/<OB_BI_ACCELERATOR_HOME>/repository/resources` directory.
    - Rename `wso2si-4.0.0-deployment.yaml` to `deployment.yaml`.
    - Copy the `deployment.yaml` file to the `<SI_HOME>/conf/server` directory to replace the existing file.

6. Open the `<SI_HOME>/conf/server/deployment.toml` file, and configure the hostnames and databases related
   properties accordingly.
    - When configuring database related properties, point to your existing Open Banking 2.0 databases.

7. Exchange the public certificates between servers.

   >**Follow the steps given below:**
   >
   >    a. Go to the `<SI_HOME>/resources/security` directory and export the public certificate of the Streaming
   Integrator:
   >
   >    ``` shell
   >    keytool -export -alias wso2carbon -keystore wso2carbon.jks -file publickeySI.pem
   >    ```
   >
   >    b. Go to the `<IS_HOME>/repository/resources/security` directory and import the public certificate of the
   Streaming Integrator to the truststore of the Identity Server:
   >
   >    ``` shell
   >    keytool -import -alias wso2 -file publickeySI.pem -keystore client-truststore.jks -storepass wso2carbon
   >    ```
   >
   >    c. Go to the `<IS_HOME>/repository/resources/security` directory and export the public certificate of the
   Identity Server:
   >
   >    ``` shell
   >    keytool -export -alias wso2carbon -keystore wso2carbon.jks -file publickeyIAM.pem
   >    ```
   >
   >    d. Go to the `<SI_HOME>/resources/security` directory and import the public certificate of the Identity
   Server to the truststore of the Streaming Integrator:
   >
   >    ``` shell
   >    keytool -import -alias wso2 -file publickeyIAM.pem -keystore client-truststore.jks -storepass wso2carbon
   >    ```
   >
   >    e. Go to the `<APIM_HOME>/repository/resources/security` directory and repeat step b,c, and d.

## Upgrade to WSO2 Streaming Integrator 4.0.0

1. To migrate the reporting data and tables from the Open Banking 2.0 setup to 3.0.
    - Go to the
      `wso2-openbanking-migration-1.0.0/openbanking-migration-resources/reporting-migration-scripts/uk`
      directory.
    - Select the relevant SQL script and execute it against your `openbank_ob_reporting_statsdb` database.

2. Start the Streaming Integrator server. For more information, see [Try Out Data Publishing](https://uk.ob.docs.wso2.com/en/latest/get-started/data-publishing-try-out/).

---

# 7. Configuring After Migration

This section explains the modifications that need to be performed after the upgrade/migration process.

1. Stop the servers if running.

2. Remove `com.wso2.openbanking.migration-1.0.0.jar` from the `IS_HOME>/repository/components/dropins` folder.

3. Remove `openbanking-migration-resources` folder from the `<IS_HOME>/repository/components/dropins` folder.

   > **Note:**
   >
   > Make sure to perform the following changes before starting with the Open Banking flows:
   >    1. Redeploy the APIs with the relevant insequence files supported in WSO2 Open Banking 3.0.0 UK Toolkit 1.0.0.
   >    2. Ensure the Production/Sandbox Endpoints of the published APIs are precise.
   >
   > - Follow the [Quick Start Guide - Tryout Flow of the UK Toolkit 1.0.0 documentation](https://uk.ob.docs.wso2.com/en/latest/get-started/try-out-flow/) for a sample tryout flow of the Account and Transaction API.
   > - Navigate to the **Tryout** section in the [UK Toolkit 1.0.0 documentation](https://uk.ob.docs.wso2.com/en/latest/try-out/dynamic-client-registration-flow/) for more information on API flows.

4. Restart the WSO2 Identity Server.

5. Restart the WSO2 API Manager Server. 
