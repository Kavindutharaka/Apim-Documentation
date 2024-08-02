<small> [1. Config Migration](./config-migration.md) > 2. Resource & Artifact Migration > 3. Extensions & Customizations Migration > 4. Data Migration > 5. Server Startup </small>

# Configuration Migration

## Prerequisites

1. Follow the [Configuration Migration Guidelines](../../../general-config-migration.md) and make sure you understand that this step involves moving the relevant `toml` configurations from `<API-M_3.1.0_HOME>/repository/conf/deployment.toml` to `<API-M_4.2.0_HOME>/repository/conf/deployment.toml`

2. You may refer to API-M 4.2.0 [Configuration Catalog](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog/) for a comprehensive understanding of the configurations available in API-M 4.2.0.

3. It is recommended to begin the below process by creating a copy of your API-M 3.1.0 `deployment.toml`. Then, as you move configurations from API-M 3.1.0 to API-M 4.2.0, in the above copy, either comment out or remove those already moved configurations. This will help you keep track of the remaining configurations that need to be moved to API-M 4.2.0. 


## Steps for Configurations Migration

1.  **Configurations Requiring Modifications**: Below are the default TOML elements in the API-M 4.2.0 `deployment.toml` file. Look through the elements with the same names in your API-M 3.1.0 `deployment.toml`. If you find different values configured for these elements compared to the default values in API-M 4.2.0, you need to move those configuration values to API-M 4.2.0 in place of the default values.

    - Default API-M 4.2.0 TOML Elements:
      - `[server]`
      - `[super_admin]`
      - `[user_store]`
      - `[database.apim_db]`
      - `[database.shared_db]`
      - `[keystore.tls]`
      - `[[apim.gateway.environment]]`
      - `[apim.sync_runtime_artifacts.gateway]`
      - `[apim.key_manager]`
      - `[apim.cors]`
      - `[[event_handler]]`
      - `[service_provider]`
      - `[database.local]`
      - `[[event_listener]]`
      - `[oauth.grant_type.token_exchange]`

    - As an example, let's consider the `[database.apim_db]` TOML element. In API-M 4.2.0, this element points to the H2 database by default. If you've configured a different data source for `apim_db` in API-M 3.1.0, replace the `[database.apim_db]` configuration values in API-M 4.2.0 with those corresponding to your data source.

> **Important**
>
> **If you are working with a distributed setup,** please be aware that the default configurations mentioned above are the ones of an all-in-one pack. If you have separate packs optimized for individual profiles, you may notice variations in default TOML elements. You'll need to generate a list similar to the one above for each profile and proceed with the aforementioned step accordingly.

2. **Configurations to Rename**: As the next step, you need to identify and migrate any configurations that have been renamed between versions. So, if you've used any of the configurations listed in column one of the table below in API-M 3.1.0, make sure to include the corresponding configuration from column two in the API-M 4.2.0 `deployment.toml` file instead.

    <table>
    <tr><td style="text-align: center;"> <b>Old Configuration</b> </td>
    <td style="text-align: center;"> <b>New Renamed Configuration</b> </td></tr>
    <tr><td>

    ```toml
    [Tenant] 
    TenantDelete = true
    ```

    </td><td>

    ```toml
    [tenant_mgt]
    tenant_deletion = true
    ```

    </td></tr><tr></tr><tr><td>

    ```toml
    [Tenant.ListenerInvocationPolicy] 
    InvokeOnDelete = true/false
    ```

    </td><td>

    ```toml
    [tenant_mgt]
    invoke_on_delete = true/false
    ```

    </td></tr><tr></tr><tr><td>

    ```toml
    [transport.servlet_http.connector] 
    enable = false
    ```

    </td><td>

    ```toml
    [transport.http]
    enable = false
    ```

    </td></tr><tr></tr><tr><td>

    ```toml
    [oauth]
    additional_params_from_error_url = true
    ```

    </td><td>

    ```toml
    [oauth] 
    allow_additional_params_from_error_url = true
    ```

    </td></tr>

    </table>

3. **Configurations to Exclude**: Next, you have to identify which configurations you can ignore while migrating. If you have following configurations in API-M 3.1.0, you can safely ignore them during migration as these are no longer required for API-M 4.2.0. 

    - `[apim.auth_manager]` configuration. <!-- used previously for jaggery apps -->
    - `[apim.dynamic_correlation_logs]` configuration. <!-- used previously to enable logs without server restart -->
    - `[apim.lambda_mediator_config]` configuration. <!-- not required as  parameter passing is enabled by default in 4.2.0+. -->
    - `[authentication.jit_provisioning] associating_to_existing_user` configuration. <!-- fix for WSO2-2021-1573 which does not affect APIM 4.2.0 -->
    - `[oauth.grant_type.uma_ticket] retrieve_uma_permission_info_through_introspection` configuration.



4. **Configurations with Altered Behavior**: Pay special attention to the following configurations, as their behavior has altered between versions:

   - If you have enabled `[apim.analytics]` in API-M 3.1.0, please note that migrating old analytics configurations to the new version won't work because API-M 4.2.0 uses a new analytics model. For guidance on setting up and configuring the new APIM Analytics model, refer to [what-has-changed](../../../what-has-changed.md#major-changes-in-api-manager-420). If you are not planning to use the new analytics model, it is advised to remove this configuration block or set the `enable` field to false.
  
   - Due to the modifications in API-M analytics, transferring `[apim.monetization]` configuration directly between versions is not supported. You will need to reconfigure it according to the [API-M Monetization Documentation](https://apim.docs.wso2.com/en/4.2.0/design/api-monetization/monetizing-an-api/).

   - If you used the configuration `[oauth.access_token] invoke_token_revocation_event_on_renewal = false`, please be aware that it is no longer supported. In API-M 4.2.0, older tokens will be revoked when generating new access tokens.

   - The default value of `[oauth] enable_jwt_token_validation_during_introspection` configuration has changed from `false` in API-M 3.1.0 to `true` in API-M 4.2.0. It is recommended not to configure this in API-M 4.2.0 and leave the default value. However, if you wish to maintain the earlier behavior, add the following configuration to API-M 4.2.0. Please refer to [JWT token validation during introspection documentation](https://apim.docs.wso2.com/en/3.1.0/learn/api-security/openid-connect/obtaining-user-profile-information-with-openid-connect/).
        ```toml
        [oauth]
        enable_jwt_token_validation_during_introspection = false
        ``` 
        
 

5. **Configurations to Duplicate**: As the next step, move all other configurations from API-M 3.1.0 that weren't transferred in the previous steps to API-M 4.2.0. You can identify and copy these remaining configurations and paste them into the API-M 4.2.0 `deployment.toml` file. 

6. **Setting Up Secrets**: Now, if `[secrets]` TOML element is present in API-M 4.2.0 move it to the bottom of the `deployment.toml` file and if `[apim] enable_secure_vault = true` configuration is present, ensure that the configuration is placed before any other `[apim]` elements to prevent errors.

---
*By now, you should have API-M 4.2.0 pack(s) that have finished the Configuration Migration*.
