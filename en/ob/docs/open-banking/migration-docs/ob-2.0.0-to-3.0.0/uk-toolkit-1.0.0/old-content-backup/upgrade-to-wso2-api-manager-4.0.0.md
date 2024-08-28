# Upgrade to WSO2 API Manager 4.0.0

# Prerequisites

We assume you already upgraded your API Manager to 3.2.0 as instructed previously on the **Upgrading WSO2 API Manager from 3.1.0 to 3.2.0** (`upgrade-to-wso2-api-manager-3.2.0.md`) documentation.

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
