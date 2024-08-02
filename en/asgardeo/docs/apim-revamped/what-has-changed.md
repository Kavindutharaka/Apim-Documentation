# What has Changed ?

This offers an overview of the modifications in features and behaviors between each APIM version and its predecessor. It is recommended to review these changes before migrating to newer versions, as certain features and behaviors present in older versions may have been altered or removed in the updated versions.

## Major Changes in API Manager 4.2.0

- Prior to WSO2 API Manager 4.2.0, the tenant configurations listed below were persisted only in the registry and only accessible via the Carbon Console. With the 4.2.0 release, these configurations are migrated to the `tenant-conf.json` file, and support is enabled to manage these through the Admin Portal (Advanced Configuration Section).

  - Self Sign Up Config - Self-signup is enabled out-of-the-box not only for the super tenant, but also for the other tenants. The 'Internal/subscriber' role is then taken from the `Advanced Configurations → DefaultRoles → SubscriberRole` when creating a tenant. In addition, the `sign-up-config.xml` file is removed along with the connection with the registry. For more information, see [Disabling or Enabling Self Signup](https://apim.docs.wso2.com/en/4.2.0/reference/customize-product/customizations/customizing-the-developer-portal/enabling-or-disabling-self-signup/).
  - Life Cycle Config - XML configuration is converted to JSON format. The life cycle changes can then be managed via `Advanced Configurations → LifeCycle` via the Admin Portal. The `APILifeCycle.xml` file is removed along with the connection with the registry. For more information, see [Customize API Life Cycle](https://apim.docs.wso2.com/en/4.2.0/design/lifecycle-management/customize-api-life-cycle/).
  
- From WSO2 API Manager 4.2.0 onwards, correlation logs can be enabled without restarting the server. Newly added CorrelationConfigManager will handle the configuration updates from the DevOps API.
  
- The schema name in the challenge string for basic auth will be changed from "Basic Auth" to "Basic" according to IANA standards. Therefore, when using the authorization header for REST calls, the header should be renamed to "Basic".

      Authorization: Basic <base64-encoded-credentials>


- Prior to API Manager 4.2.0, only a single registry handler property with nested elements can be added. From API Manager 4.2.0 onwards multiple registry handler properties with nested elements can be added.

Please refer to [WSO2 Official Documentation](https://apim.docs.wso2.com/en/4.2.0/get-started/about-this-release/#what-has-changed) for more information on what has changed.

Further, API-M 4.2.0 introduces a series of new configurations associated with the [New Features](https://apim.docs.wso2.com/en/4.2.0/get-started/about-this-release/#new-features) Please review the feature documentation and configure them accordingly.

## Major Changes in API Manager 4.1.0

- With 4.1.0 release, WSO2 API manager has realigned its previous API level mediation policies feature to a more sophisticated policy feature which provides support for not only mediation policies, but a vast number of different use cases. Please refer [About this release](https://apim.docs.wso2.com/en/4.1.0/get-started/about-this-release/) fro more information.
  
Please refer to [WSO2 Official Documentation](https://apim.docs.wso2.com/en/4.1.0/get-started/about-this-release/#what-has-changed) for more information on what has changed.

Further, API-M 4.1.0 introduces a series of new configurations associated with the [New Features](https://apim.docs.wso2.com/en/4.1.0/get-started/about-this-release/#new-features) Please review the feature documentation and configure them accordingly.

## Major Changes in API Manager 4.0.0

- Prior to WSO2 API Manager 4.0.0, the distributed deployment consisted of five main product profiles, namely Publisher, Developer Portal, Gateway, Key Manager, and Traffic Manager. However, the new architecture in API-M 4.0.0 only has [three profiles](https://apim.docs.wso2.com/en/4.0.0/install-and-setup/setup/distributed-deployment/understanding-the-distributed-deployment-of-wso2-api-m/), namely **Gateway**, **Traffic Manager**, and **Control Plane**.
  
- From API-M 4.0.0 onwards API Manager offers analytics as a cloud service. So, APIM analytics won't work if you simply migrate the old analytics configurations to the new version. Further, as the on-premise analytics data cannot be migrated to the Cloud, you need to maintain the old analytics server and keep the UI running for as long as you need that data (e.g. 3 months) after migrating to the new version of analytics in WSO2 API-M 4.0.0. You need to register with the analytics cloud in order to use the new API Manager Analytics. Please follow the [Analytics Documentation](https://apim.docs.wso2.com/en/4.0.0/api-analytics/getting-started-guide/).

- From API-M 4.0.0 onwards, synapse artifacts have been removed from the file system and are managed via database. At server startup the synapse configs are loaded to the memory from the Traffic Manager.

- Token and Revoke endpoints have been removed from the Gateway artifacts from API-M 4.0.0 onwards. Use endpoints in the Control Plane instead instead of Gateway endpoints as shown below.
    ```bash
    https://localhost:8243/token --> https://localhost:9443/oauth2/token
    https://localhost:8243/revoke --> https://localhost:9443/oauth2/revoke
    ```

- From WSO2 API-M 4.0.0 onwards error responses in API calls has changed from XML to JSON format. **If you have developed client applications to handle XML error responses you have to change the client applications to handle the JSON responses.**

Please refer to [WSO2 Official Documentation](https://apim.docs.wso2.com/en/4.0.0/get-started/about-this-release/#what-has-changed) for more information on what has changed.

Further, API-M 4.0.0 introduces a series of new configurations associated with the [New Features](https://apim.docs.wso2.com/en/4.0.0/get-started/about-this-release/#new-features) Please review the feature documentation and configure them accordingly.

## Major Changes in API Manager 3.2.0

- Starting from version 3.2.0 of API Manager, support for Third Party Key Managers was introduced, allowing integration with systems like WSO2 Identity Server (WSO2 IS) as well as other authorization servers like Keycloak, Okta, Auth0, and PingFederate.

- API key validation calls now occur against an in-memory store.
- Backend JWT generation now takes place at the gateway in API-M 3.2.0, requiring custom JWT generators to be added to the Gateway Node.
- The Jaggery-based Admin portal UI has been replaced with a new ReactJS-based application from version 3.2.0 onwards.
- The need for a separate BPS engine for simple approval and rejection tasks has been eliminated in API-M 3.2.0, thanks to the introduction of an Approval Workflow Executor with an inbuilt workflow.
- Support for tag-wise grouping has been removed in API-M 3.2.0, with users encouraged to utilize API category-based grouping instead.
- The implicit grant type has been removed from API-M 3.2.0 onwards.
- Out-of-the-box support for generating Opaque (Reference) access tokens via the Developer Portal has been removed starting from WSO2 API Manager version 3.2.0, requiring application developers to create new applications that only generate JWT type access tokens.
 
Please refer to [WSO2 Official Documentation](https://apim.docs.wso2.com/en/3.2.0/getting-started/about-this-release/#what-has-changed) for more information on what has changed.

Further, API-M 3.2.0 introduces a series of new configurations associated with the [New Features](https://apim.docs.wso2.com/en/3.2.0/getting-started/about-this-release/#wso2-api-m-related-new-features) Please review the feature documentation and configure them accordingly.

