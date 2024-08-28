<small> [1. Config Migration](./config-migration.md) > 2. Resource & Artifact Migration > 3. Extensions & Customizations Migration > 4. Data Migration > 5. Server Startup </small>

# Configuration Migration

## Prerequisites

1. Follow the [Configuration Migration Guidelines](../../../general-config-migration.md) and make sure you understand that this step involves moving the relevant `toml` configurations from `<API-M_4.0.0_HOME>/repository/conf/deployment.toml` to `<API-M_4.2.0_HOME>/repository/conf/deployment.toml`

2. You may refer to API-M 4.2.0 [Configuration Catalog](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog/) for a comprehensive understanding of the configurations available in API-M 4.2.0.

3. It is recommended to begin the below process by creating a copy of your API-M 4.0.0 `deployment.toml`. Then, as you move configurations from API-M 4.0.0 to API-M 4.2.0, in the above copy, either comment out or remove those already moved configurations. This will help you keep track of the remaining configurations that need to be moved to API-M 4.2.0. 


## Steps for Configurations Migration

1.  **Configurations Requiring Modifications**: Below are the default TOML elements in the API-M 4.2.0 `deployment.toml` file. Look through the elements with the same names in your API-M 4.0.0 `deployment.toml`. If you find different values configured for these elements compared to the default values in API-M 4.2.0, you need to move those configuration values to API-M 4.2.0 in place of the default values.

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

    - As an example, let's consider the `[database.apim_db]` TOML element. In API-M 4.2.0, this element points to the H2 database by default. If you've configured a different data source for `apim_db` in API-M 4.0.0, replace the `[database.apim_db]` configuration values in API-M 4.2.0 with those corresponding to your data source.

> **Important**
>
> **If you are working with a distributed setup,** please be aware that the default configurations mentioned above are the ones of an all-in-one pack. If you have separate packs optimized for individual profiles, you may notice variations in default TOML elements. You'll need to generate a list similar to the one above for each profile and proceed with the aforementioned step accordingly.

2. **Configurations to Duplicate**: As the next step, move all other configurations from API-M 4.0.0 that weren't transferred in the previous steps to API-M 4.2.0. You can identify and copy these remaining configurations and paste them into the API-M 4.2.0 `deployment.toml` file. 

3. **Setting Up Secrets**: Now, if `[secrets]` TOML element is present in API-M 4.2.0 move it to the bottom of the `deployment.toml` file and if `[apim] enable_secure_vault = true` configuration is present, ensure that the configuration is placed before any other `[apim]` elements to prevent errors.

---
*By now, you should have API-M 4.2.0 pack(s) that have finished the Configuration Migration*.
