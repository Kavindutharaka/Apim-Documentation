# Upgrade WSO2 API Manager from 4.0.0 to 4.2.0 and WSO2 Identity Server from 5.11.0 to 6.1.0

## Prepare for Migration

1. Download WSO2 Identity Server 6.1.0 from [here](https://wso2.com/identity-server/) and extract the folder. The extracted folder will be referred to as `<IS_HOME>` in this document.

2. Download WSO2 API Manager 4.2.0 from [here](https://wso2.com/api-manager/) and extract the folder. The extracted folder will be referred to as `<APIM_HOME>` in this document.

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

1. Follow the [Getting WSO2 Updates](https://uk.ob.docs.wso2.com/en/latest/get-started/quick-start-guide/#getting-wso2-updates) documentation and update the base products, accelerators, and toolkits using relevant scripts.

2. Run the `merge.sh` script in `<APIM_HOME>/<OB_APIM_ACCELERATOR_HOME>/bin` and `<IS_HOME>/<OB_IS_ACCELERATOR_HOME>/bin` respectively to copy the Open Banking artifacts into the the base product packs.

   ```
   ./merge.sh
   ```

3. Run the `merge.sh` script in `<APIM_HOME>/<OB_APIM_TOOLKIT_HOME>/bin` and `<IS_HOME>/<OB_IS_TOOLKIT_HOME>/bin` respectively:

   ```
   ./merge.sh
   ```

4. Add the relevant modifications to the `wso2is-5.11.0-deployment-uk.toml` file in the `<IS_HOME>/<OB_IS_TOOLKIT_HOME>/repository/resources` directory. 

5. Rename `wso2is-5.11.0-deployment-uk.toml` to `deployment.toml`. 

6. Copy the `deployment.toml` file to the `<IS_HOME>/repository/conf` directory to replace the existing file.

7. Open the `<IS_HOME>/repository/conf/deployment.toml` file, and configure the hostnames and databases related
   properties accordingly.
   - When configuring database related properties, ensure that the datasources are pointing to the existing databases. 

8. Add the relevant modifications to the `wso2am-4.0.0-deployment-uk.toml` file in the `<APIM_HOME>/<OB_APIM_TOOLKIT_HOME>/repository/resources` directory.

9. Rename `wso2am-4.0.0-deployment-uk.toml` to `deployment.toml`.

10. Copy the `deployment.toml` file to the `<APIM_HOME>/repository/conf` directory to replace the existing file.

11. Open the `<APIM_HOME>/repository/conf/deployment.toml` file, and configure the hostnames and databases related
    properties accordingly.
    - When configuring database related properties, ensure that the datasources are pointing to the existing databases.

12. Add the following configurations needed for Identity Server 6.1.0 and API Manager 4.2.0.

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

## Upgrade to WSO2 Identity Server 6.1.0

1. Follow the **Upgrade IS 5.11.0 to IS 6.0.0 for APIM 4.0.0 to 4.2.0** documentation (`Upgrade IS 5.11.0 to IS 6.0.0 for APIM 4.0.0 to 4.2.0.md`) from the beginning along with this document (`upgrade-api-manager-4.0.0-to-4.2.0-and-identity-server-5.11.0-to-6.1.0.md`) and start the migration. When following the above-mentioned documentation,

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
    
6. For the step 4 under the **Step 2: Migrate the IS Resources** topic in the above-mentioned documentation please refer to the **Migrating to 6.1.0** documentation (`migrate-to-610.md`). Follow the steps in order skipping the steps mentioned below.

    1. Skip the **Components** section under **Step 1: Migrate artifacts and configs** when following the above-mentioned documentation (`migrate-to-610.md`).
    
    2. When following the **Resources** section under **Step 1: Migrate artifacts and configs**, skip the configurations included inside the **Note**.
    
    3. Skip the **Tenants** section under **Step 1: Migrate artifacts and configs**.
    
    4. The **User Stores** section under **Step 1: Migrate artifacts and configs** is optional.
    
    5. Skip the **Webapps** section under **Step 1: Migrate artifacts and configs**.
   
    6. The instructions under the **Configurations** section is already followed at this point. Therefore, not need to follow that..

7. When following **Step 3: Migrate the IS Components** in the **Upgrade IS 5.11.0 to IS 6.0.0 for APIM 4.0.0 to 4.2.0** documentation (`Upgrade IS 5.11.0 to IS 6.0.0 for APIM 4.0.0 to 4.2.0.md`) use the migration tool provided by the WSO2 team (`wso2is-migration-1.1.163.zip`).

8. Then run the migration tool at the step 8 after following the rest of the instructions.

- Following the **Upgrade IS 5.11.0 to IS 6.0.0 for APIM 4.0.0 to 4.2.0** documentation (`Upgrade IS 5.11.0 to IS 6.0.0 for APIM 4.0.0 to 4.2.0.md`) with the above instructions, concludes the Identity Server migration.

Then start the API Manager migration.

## Upgrade to WSO2 API Manager 4.2.0

Follow the **Upgrading API Manager from 4.0.0 to 4.2.0** documentation (`upgrading-from-400-to-420.md`) along with the following instructions to perform the API Manager migration.

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

- This concludes the migration process.
