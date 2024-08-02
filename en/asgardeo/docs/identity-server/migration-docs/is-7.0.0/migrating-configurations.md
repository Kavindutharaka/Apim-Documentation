# Migrating Configurations

>**Note :**
>This section is only applicable if you’re migrating from a version prior to WSO2 Identity Server 5.9.0.

You need to provide the complete `conf` directory of the current IS version located at `<IS_HOME>/repository/conf` to the WSO2 team to migrate it to the latest version.

WSO2 team will provide two `conf` directories as follows:

1. The evaluation conf directory to use for testing the customizations before the actual migration (In step 1 and step 2 of [migrate to 7.0.0](migrate-to-700.md)).

    ```
    [super_admin]
    ...
    create_admin_account = "true"
    
    [database.identity_db]
    type = "h2"
    url = "jdbc:h2:./repository/database/WSO2IDENTITY_DB;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=60000"
    username = "wso2carbon"
    password = "wso2carbon"
    
    [database.shared_db]
    type = "h2"
    url = "jdbc:h2:./repository/database/WSO2IDENTITY_DB;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=60000"
    username = "wso2carbon"
    password = "wso2carbon"
    ```

2. The finalized conf directory to use during the migration (In step 4 and step 5 of [migrate to 7.0.0](migrate-to-700.md)). 

    ```
    [super_admin]
    ...
    create_admin_account = "false"
    
    [authorization_manager.properties]
    GroupAndRoleSeparationEnabled = false

Replace the evaluation conf directory provided by the WSO2 team with the existing conf directory available in the `<NEW_IS_HOME>/repository` directory.

Make any necessary changes to the `deployment.toml` file such as keystore passwords (Do not update any DB configurations at this stage).
