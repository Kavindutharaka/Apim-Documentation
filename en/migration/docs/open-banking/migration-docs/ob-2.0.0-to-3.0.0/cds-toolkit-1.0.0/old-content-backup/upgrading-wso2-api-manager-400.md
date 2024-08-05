# Upgrading to WSO2 API Manager 4.0.0

>**Before you begin:**
>
>    Make sure you have upgraded your API Manager to 3.2.0 according to the **Upgrading to WSO2 API Manager 3.2.0** (`upgrading-wso2-api-manager-320.md`) documentation.

1. Download and install the WSO2 API Manager 4.0.0 distribution from [here](https://wso2.com/api-manager/). 
2. Extract the downloaded archive file. This document refers to the root folder of the extracted file as `<APIM_HOME>`.

## Set up Open Banking Accelerator and CDS Toolkit for API Manager

 1. Download the `wso2-obam-accelerator-3.0.0.zip` file and extract it to the `<APIM_HOME>` directory. 
 2. Download the latest updates for `wso2-obam-accelerator-3.0.0`. For more information, see [Getting WSO2 Updates](https://cds.ob.docs.wso2.com/en/latest/install-and-setup/setting-up-servers/#getting-wso2-updates).
 3. Go to the `<APIM_HOME>/<APIM_ACCELERATOR_HOME>/bin` directory and run the merge.sh script.

    ```
    ./merge.sh
    ```

 4. Download the `wso2-obam-toolkit-cds-1.0.0.zip` file and extract it to the `<APIM_HOME>` directory. 
 5. Download the latest updates for `wso2-obam-toolkit-cds-1.0.0`. For more information, see [Getting WSO2 Updates](https://cds.ob.docs.wso2.com/en/latest/install-and-setup/setting-up-servers/#getting-wso2-updates).
 6. Go to the `<APIM_HOME>/<APIM_TOOLKIT_HOME>/bin` directory and run the merge.sh script.

    ```
    ./merge.sh
    ```
    
 7. Replace the existing `deployment.toml` file in the API Manager as follows:
    - Go to the `<APIM_HOME>/<OB_APIM_TOOLKIT_HOME>/repository/resources` directory.
    - Rename `wso2am-4.0.0-deployment-cds.toml` to `deployment.toml`.
    - Copy the `deployment.toml` file to the `<APIM_HOME>/repository/conf` directory and replace the existing file.
    
 8. Open the `<APIM_HOME>/repository/conf/deployment.toml` file, and configure the hostnames and databases related 
     properties accordingly. 
     - When configuring database related properties, point to your existing Open Banking 2.0 databases.

## Upgrading to WSO2 API Manager 4.0.0

>**Before you begin:**
>
>    Once the Identity Server 5.11.0 is configured as the Resident Key Manager, start the Identity Server 5.11.0.

1. Start the WSO2 API Manager 4.0.0 server and create a Custom Key Manager by following the
   [Configuring IS as Key Manager](https://cds.ob.docs.wso2.com/en/latest/try-out/dynamic-client-registration-flow/#step-2-configure-is-as-key-manager) documentation.

2. Do not copy any other Key Manager specific configurations from the previous API Manager version to the latest 
one that points to the Identity Server.

3. Get the **Upgrading API Manager from 3.2.0 to 4.0.0** documentation provided by the WSO2 team.

 - Upgrade your API Manager from 3.2.0 to 4.0.0 by following the provided documentation.

    >**Note**
    >
    >    When following the above mentioned documentation:
    >
    >    1. You can skip the steps 1,2, and 3 under **Step 1 - Migrate the API Manager configurations**.
    >   
    >    2. Modify the following configurations in the `<APIM_HOME>/repository/conf/deployment.toml` file before starting the migration.
    >
    >       ``` toml
    >       [[apim.gateway.environment]]
    >       name = "Production and Sandbox"
    >       [apim.sync_runtime_artifacts.gateway]
    >       gateway_labels =["Production and Sandbox", "Default"]
    >       ```
    >   
    >    3. In **Step 2 - Upgrade API Manager to 4.0.0**, skip the steps 3 and 5.

4. Start the API Manager server.

### Update API Endpoints Custom Mediation Policies

This section explains how to update the API Endpoint of each API.

1. Go to the API Publisher at `https://<APIM_HOST>:9443/publisher`.
2. Select the respective API.
3. Go to **API Configurations > Endpoints**.
4. Update the endpoints according to the 
[Summarized information for configuring APIs](https://cds.ob.docs.wso2.com/en/latest/try-out/account-and-transaction-flow/#summarized-information-for-configuring-apis)
section. For more information, refer to the deployment steps of each API. 

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

1. Go to the Management Console `https://<APIM_HOST>:9443/carbon` and log in as the admin user. ![management_console](https://cds.ob.docs.wso2.com/en/latest/assets/img/install-and-setup/upgrading-the-solution/management-console.png)
2. Select **Resources > Browse** in the left pane. <br/> ![select-browse](https://cds.ob.docs.wso2.com/en/latest/assets/img/install-and-setup/upgrading-the-solution/select-browse.png)
3. Locate the `/_system/governance/apimgt/applicationdata/workflow-extensions.xml` file. ![workflow_extensions](https://cds.ob.docs.wso2.com/en/latest/assets/img/install-and-setup/upgrading-the-solution/workflow-extensions.png)
4. Get the `workflow.txt` provided by the WSO2 team.
5. Click **Edit as text** and replace the content with the content you received. ![edit_as_text](https://cds.ob.docs.wso2.com/en/latest/assets/img/install-and-setup/upgrading-the-solution/edit-as-text.png)

### Update API Life Cycle

1. Go to the Management Console `https://<APIM_HOST>:9443/carbon` and log in as the admin user. ![management_console](https://cds.ob.docs.wso2.com/en/latest/assets/img/install-and-setup/upgrading-the-solution/management-console.png)
2. Select **Extensions > Lifecycles**. <br/> ![select_lifecycles](https://cds.ob.docs.wso2.com/en/latest/assets/img/install-and-setup/upgrading-the-solution/select-lifecycles.png)
3. Click the **View/Edit** button for APILifeCycle. ![view_edit_lifecycles](https://cds.ob.docs.wso2.com/en/latest/assets/img/install-and-setup/upgrading-the-solution/view-edit-lifecycles.png)
4. Get the `lifecycle.txt` provided by the WSO2 team.
5. Replace the Lifecycle Source with the content you received.

###  Update Identity Provider Entity ID 

1. Go to Identity Server Management Console `https://<IS_HOST>:9446/carbon` and log in as the admin user.
2. Select **Identity Providers > Resident**. ![resident_identity_provider](https://cds.ob.docs.wso2.com/en/latest/assets/img/install-and-setup/upgrading-the-solution/resident-identity-provider.png)
3. Go to **Inbound Authentication Configuration > OAuth2/OpenID Connect Configuration**.
4. Update the **Identity Provider Entity ID** to the following: 
    ```
    https://<IS_HOST>:9446/oauth2/token
    ```
   
     ![update_resident_identity_provider](https://cds.ob.docs.wso2.com/en/latest/assets/img/install-and-setup/upgrading-the-solution/update-resident-provider-entity.png)

5. Click **Update**.
