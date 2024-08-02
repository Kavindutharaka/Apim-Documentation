# Upgrading WSO2 Open Banking from 2.0.0 to 3.0.0

This documentation guides you on how to upgrade your WSO2 Open Banking 2.0.0 for the UK setup to WSO2 Open Banking 3.0.0 (Accelerator Model) UK Toolkit 1.0.0 with WSO2 API Manager 4.2.0 and WSO2 Identity Server 6.1.0 as the base packs.

# Overview

WSO2 Open Banking solution runs on top of WSO2 Identity Server and WSO2 API Manager which are referred to as base products.

Given below is the product compatibility matrix for the WSO2 Open Banking solution. This matrix outlines the compatibility between the versions of WSO2 Open Banking solutions involved in this migration and the latest version of the base products they support.

| WSO2 Open Banking Version | Supported WSO2 Identity Server Version | Supported WSO2 API Manager Version |
|---------------------------|----------------------------------------|------------------------------------|
| 2.0.0                     | 5.10.0                                 | 3.1.0                              |
| 3.0.0                     | 6.1.0 (Latest)                         | 4.2.0 (Latest)                     |

## Prerequisites

We assume that you already have an existing WSO2 Open Banking 2.0.0 solution for the UK with some sample data populated in the databases. This setup will be referred to as the pre-migration setup in this documentation.

>**Important:**
>
>- In order to upgrade your existing Open Banking solution to the latest version, you need to upgrade the base products (WSO2 Identity Server and WSO2 API Manager) to the latest supported version as well.
>
>- In addition to the base product migration, you need to configure WSO2 Identity Server as Key Manager. The Key Manager handles all clients, security, and access token-related operations. So you need to configure WSO2 Identity Server as Key Manager in each WSO2 API Manager migration.

The following diagram explains the flow of upgrading the WSO2 Open Banking solution:

![migration-flow](https://uk.ob.docs.wso2.com/en/latest/assets/img/install-and-setup/upgrading-the-solution/migration-flow.png)

Given below are the steps you need to follow to upgrade your WSO2 Open Banking 2.0.0 for the UK setup to WSO2 Open Banking 3.0.0 - UK Toolkit 1.0.0:

1. Prepare for Migration
2. Upgrade IS as KM 5.10.0 to IS as KM 6.1.0
3. Upgrade WSO2 API Manager 3.1.0 to WSO2 API Manager 4.2.0
4. Migrate Open Banking Data
5. Migrate Reporting Data (Optional)
6. Post-Migration Configurations

# 1. Prepare for Migration

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

    1. Add the following configuration in Identity Server 6.1.0 `deployment.toml` file.

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

# 2. Migrating WSO2 IS as Key Manager from Identity Server 5.10.0 to 6.1.0

1. Get the **Upgrading WSO2 IS as Key Manager to 6.0.0** (`Upgrade IS KM 5.10.0 to IS 6.0.0 for APIM 3.1.0 to 4.2.0.md`) documentation provided by the WSO2 team. This will instruct you to upgrade your IS as Key Manager 5.10.0 to IS 6.1.0. Take note of the essential points provided below while following the instructions in the documentation.

    >**Important**
    > 
    >Please note that the information contained in the above-mentioned documentation is also applicable for WSO2 Identity Server 6.1.0.

2. Follow **Step A: Upgrade IS as Key Manager 5.10.0 to IS 6.0.0** in the above-mentioned documentation. Follow all the steps and make sure to perform the necessary steps mentioned below:

    >**Note**
    > 
    > Refer to the **Migrating to 6.1.0** (`migrate-to-610.md`) documentation when following the step 5 under **Step 1: Migrate the IS as KM configurations**.

3. When following **Step 2: Migrate the IS as KM Resources**, download the WSO2 IS Connector for API Manager 4.2.0 from [here](https://apim.docs.wso2.com/en/4.2.0/assets/attachments/administer/wso2is-extensions-1.6.8.zip). Extract the folder (`wso2is-extensions-1.6.8.zip`) and get the relevant JAR files and WAR file. 

4. When following **Step 3: Migrate the IS as KM Components**, use the `wso2is-migration-1.1.163.zip` folder as the identity component migration resource.


- Following the **Step A: Upgrade IS as Key Manager 5.10.0 to IS 6.0.0** in the above-mentioned documentation with the above instructions, concludes the WSO2 IS as Key Manager from Identity Server 5.10.0 to 6.1.0 migration.

# 3. Migrating WSO2 API Manager from 3.1.0 to 4.2.0

1. Get the **Upgrading API Manager from 3.1.0 to 4.2.0** (`upgrading-from-310-to-420.md`) documentation provided by the WSO2 team. This will instruct you to upgrade your API-M environment from 3.1.0 to 4.2.0. Take note of the essential points provided below while following the instructions in the documentation.

2. When following **Step 1: Migrate the API Manager Configurations**, use the DB scripts (`db-scripts/upgrading-from-310-to-420`) provided by the WSO2 team.

3. Skip the guidelines under **Step 3: Migrate the Identity Components** as you have already done this in **Step 3** of **Step A: Upgrade IS as Key Manager 5.10.0 to IS 6.0.0**.

4. When following **Step 4: Migrate the API Manager Components**, use the provided API Manager Migration resources (`wso2am-migration-4.2.0.54.zip`).

5. Before starting the API Manager 4.2.0 server for the first time in Step 6 under **Step 6: Restart the WSO2 API Manager 4.2.0 Server**, make sure you have already started WSO2 Identity Server 6.1.0.

- Following the above-mentioned documentation with the above instructions, concludes the WSO2 API Manager migration.

# 4. Migrating Open Banking Data

In this step, you will transfer your Open Banking data from your existing Open Banking 2.0.0 platform to the new WSO2 Open Banking 3.0.0 platform. This process includes moving important information such as customer accounts, transactions, and permissions.

## Prerequisites

Make sure the following:

- In your Open Banking 2.0.0 database, check the column size of the following:

    | Database          | Table       | Column| Data type | Size |
    |-------------------|-------------|-------|-----------|------|
    |`openbank_apimgtdb`|`SP_METADATA`|`VALUE`| `VARCHAR` | 4096 |

    - If the column size is less than 4096, execute the following command against the `SP_METADATA` table:

         ```
         ALTER TABLE SP_METADATA MODIFY VALUE VARCHAR(4096);
         ```

>**Note:** 
>
>Please read the following section before proceeding with the migration:
>
>- The `SPMigrator` migrates the Dynamic Client Registration related data.
>    - If the regulatory applications are registered through the signup flow.
>        - Please skip this migrator by removing the following configuration in `migration-config.yaml`.
>          ```
>          - 
>            name: "SPMigrator"
>            spec: "UK"
>            order: 3
>            parameters:
>              schema: "ob"
>          ```
>
>  - The default `common-auth-script.js` (the adaptive authentication script of service provider applications) that was provided in Open Banking 2.0.0 is not supported in Open Banking 3.0.0. Therefore, the migration tool is configured to automatically update the `common-auth-script` file of all service provider apps to the format which is supported in Open Banking 3.0.0.
>
>      - This default script supported in Open Banking 3.0.0 is available in the `common-auth-script.js` file placed at the `openbanking-migration-resources/common-auth-scripts/UK` directory.
>      - Make sure to change the content of the file appropriately if you have used a customized adaptive authentication script for all the service provider applications in your Open Banking 2.0.0 setup and that logic **will not be supported directly** in Open Banking 3.0.0.
>      - If you can assure that the customized adaptive authentication logic used in Open Banking 2.0.0 is supported in Open Banking 3.0.0 without any modifications, you can skip this step during the migration by setting the `commonAuthScriptUpdateEnable` parameter under the relevant spec version of the `SPMigrator` to `false` in `migration-config.yaml`. Otherwise, it should be `true`.
>           ```
>        -
>          name: "SPMigrator"
>          spec: "UK"
>          order: 3
>          parameters:
>          schema: "ob"
>          commonAuthScriptUpdateEnable: "false"
>        ```
>      - If you have configured different adaptive authentication logics for service provider applications, the migration-tool does not support the automated update.
>      - In this case also, the `commonAuthScriptUpdateEnable` parameter under the relevant spec version of the SPMigrator should be set to **false** in `migration-config.yaml` **before starting** the OB-migration process as shown above.
>
>      >**Note:**
>      > 
>      >- If any update is required, the adaptive authentication logic of each service provider should be updated manually based on your customizations via the carbon console once the entire migration process is concluded.
>

>**Before you begin:**
>
>    Back up all the databases before performing the migration.

1. To create the required database tables:
    - Run the relevant SQL script in the `<IS_HOME>/dbscripts/open-banking/consent` directory against the `openbank_openbankingdb` database.

2. Get the WSO2 Open Banking Migration Client Tool v1.0.0 (`wso2-openbanking-migration-1.0.1.zip`) provided by the WSO2 team.

3. Copy the `wso2-openbanking-migration-1.0.1/openbanking-migration-resources` directory to `<IS_HOME>`.

4. Copy the `wso2-openbanking-migration-1.0.1/dropins/com.wso2.openbanking.migration-1.0.1.jar` file to `<IS_HOME>/repository/components/dropins`.

5. Open the `wso2-openbanking-migration-1.0.1/openbanking-migration-resources/migration-config.yaml` file and set the `migrationEnable` property to `true`.

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

# 5. Migrating Reporting Data

In this step, you will transfer data from your existing reporting system to the new WSO2 Open Banking platform. This will involve moving data related to reports, dashboards, and visualizations.

>**Note:**
> 
>Follow this step only if you are using WSO2 Open Banking Business Intelligence with your existing WSO2 Open Banking 2.0.0 setup.

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

# 6. Post-Migration Configurations

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

4. Sign in to the Identity Server Management Console.

5. Navigate to **Identity Providers → Resident → Inbound Authentication Configuration → OAuth2/OpenID Connect Configuration → Identity Provider Entity ID**.

6. Change the **Identity Provider Entity ID** value from `https://localhost:8243/token` to `https://localhost:9446/oauth2/token`.

7. If the `urn:ietf:params:oauth:grant-type:uma-ticket` grant type was used in the Open Banking 2 setup, follow the below instructions to configure User Managed Access with WSO2 Identity Server:

    >WSO2 Identity Server (WSO2 IS) supports the UMA 2.0 protocol, which allows a resource owner to easily share resources with other requesting parties. To use UMA with WSO2 Identity Server, first you need to configure the authenticator with WSO2 Identity Server.
    > 
    > You can either download the UMA artifacts or build the authenticator from the source code by following the steps given below.
    > 1. Download the UMA connector and other required artifacts from the [WSO2 store](https://store.wso2.com/store/assets/isconnector/list).
    > 2. Add the following `.jar` files to the `<IS_HOME>/repository/components/dropins` directory.
    > 
    > ```
    >   org.wso2.carbon.identity.oauth.uma.common-x.x.x.jar
    >   org.wso2.carbon.identity.oauth.uma.grant-x.x.x.jar
    >   org.wso2.carbon.identity.oauth.uma.permission.service-x.x.x.jar
    >   org.wso2.carbon.identity.oauth.uma.resource.service-x.x.x.jar
    >   org.wso2.carbon.identity.oauth.uma.xacml.extension-x.x.x.jar
    >   ```
    > 3. Add the following `.war` files to the `<IS_HOME>/repository/deployment/server/webapps` directory.
    >  ```
    >    api#identity#oauth2#uma#resourceregistration#v_.war
    >    api#identity#oauth2#uma#permission#v_.war
    >    ```
    > 4. Get the `org.wso2.carbon.identity.oauth.uma.server.feature/resources/dbscripts/` folder provided by the WSO2 team.
    > 5. Run the corresponding db script from the above-mentioned folder. 
    > 6. Start/ Restart WSO2 Identity Server.
    > 7. Stop WSO2 Identity Server if it is already running.
    > 8. Add the below configuration to the `<IS-Home>/repository/conf/deployment.toml` file.
    >  ```toml
    >  [[oauth.custom_grant_type]]
    >  name = "urn:ietf:params:oauth:grant-type:uma-ticket"
    >  grant_handler = "org.wso2.carbon.identity.oauth.uma.grant.UMA2GrantHandler"
    >  grant_validator = "org.wso2.carbon.identity.oauth.uma.grant.GrantValidator"
    >
    >  [[resource.access_control]]
    >  context = "(.*)/api/identity/oauth2/uma/resourceregistration/v1.0/(.*)"
    >  secure = "true"
    >  http_method = "all"
    >
    >  [[resource.access_control]]
    >  context = "(.*)/api/identity/oauth2/uma/permission/v1.0/(.*)"
    >  secure = "true"
    >  http_method = "all"
    >    ```
    > 8. Start/ Restart WSO2 Identity Server.

8. Restart the WSO2 Identity Server.

9. Restart the WSO2 API Manager Server.

