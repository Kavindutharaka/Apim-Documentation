# Migrating to 7.0.0
This document guides you through the migration process from earlier versions of WSO2 Identity Server to Identity Server 7.0.0.

## Before you begin
See the document on [preparing for migration](prepare-for-migration.md).

## Step 1: Preparing the environment with the new WSO2 IS 7.0.0 instance

### 1. Download and update the IS 7.0.0 pack.

>**Note**
>
> Always migrate to the [latest version](https://wso2.com/identity-and-access-management)
  to receive the latest fixes and the newest features. If you have a particular
  requirement to migrate to an intermediate version, contact
  [WSO2 Support](https://support.wso2.com/jira/secure/Dashboard.jspa).

- Download the WSO2 IS 7.0.0 pack and unzip it in the <NEW_IS_HOME> directory.
- Use the [Update Management Tool](https://updates.docs.wso2.com/en/latest/) (UMT) to get the latest updates for this release.

### 2. Migrating configurations. 

This is only applicable if you’re migrating from a version prior to 5.9. See the document on 
[migrating configurations](migrating-configurations.md).

### 3. Migrating customizations

>**Note**
>
>If your customizations are already available in the latest version, you can remove them
after migration. You can contact [WSO2 Support](https://support.wso2.com/jira/secure/Dashboard.jspa) for assistance. However, if a custom requirement is not available in the latest version, follow the steps given below to migrate them.

- See the document [Migrating Customizations](migrating-customizations.md) to go through the recommendations related to migrating customizations.
- Update the dependency versions aligning with the new WSO2 IS 7.0.0 versions.
- Once the custom components are migrated, get the latest JAR files of the custom components.
- Add the JAR files from the previous WSO2 Identity Server setup to the same path in the new version.

  eg: If the particular JAR file was in the `<OLD_IS_HOME>/repository/components/dropins` directory, add the updated JAR file to the `<NEW_IS_HOME>/repository/components/dropins` directory.

### 4. Adding DB drivers and other JAR files

- Add the DB driver inside `<NEW_IS_HOME>/repository/components/lib` directory.
- If you have manually added any JAR files to the `dropins` or `lib` directories of  OLD IS, you may add those to the `<NEW_IS_HOME>/repository/components/dropins` or  `<NEW_IS_HOME>/repository/components/lib` directories accordingly. You may consult the WSO2 team and verify if the particular JAR files are required to be copied.

### 5. Copying other resources from the OLD IS instance

- If you have created secondary user stores in the previous WSO2 Identity Server version, copy the content in the `<OLD_IS_HOME>/repository/deployment/server/userstores` directory to the `<NEW_IS_HOME>/repository/deployment/server/userstores` directory.
- Copy other eventpublishers and eventstreams as required (Only if any of these are used).
- The `<OLD_IS_HOME>/repository/deployment/server/webapps` directory should not be copied to the new IS instance.
- If you have created tenants in the previous WSO2 Identity Server version that contain resources, copy the content from `<OLD_IS_HOME>/repository/tenants directory`, to the `<NEW_IS_HOME>/repository/tenants` directory.
- Copy the `.jks` files from the `<OLD_IS_HOME>/repository/resources/security` directory and paste them in the `<NEW_IS_HOME>/repository/resources/security` directory.
- From WSO2 Identity Server 5.11.0 onwards, it is required to use a certificate with the RSA key size greater than 2048. If you have used a certificate that has a weak RSA key (key size less than 2048) in the previous IS version, can create a new Keystore having 2048 as the key size. Once created, make sure to point the internal keystore to the keystore that is copied from the previous WSO2 IS. The primary keystore can be pointed to a keystore with a certificate that has a strong RSA key.
    ```
    [keystore.primary]
    file_name = "primary.jks"
    type = "JKS"
    password = "wso2carbon"
    alias = "wso2carbon"
    key_password = "wso2carbon"
    
    [keystore.internal]
    file_name = "internal.jks"
    type = "JKS"
    password = "wso2carbon"
    alias = "wso2carbon"
    key_password = "wso2carbon"
    ```
- Challenge questions feature has been deprecated in WSO2 Identity Server 7.0 and is now available as a connector. If you intend to use this feature, add it as a connector to the product. Additionally, if you are migrating to Identity Server 7.0 from versions prior to 5.3, you are required to complete a migration process by following the provided instructions.

>**Note**
>
> Starting with Identity Server 5.3, the challenge questions registry path was updated. If you are migrating from a version prior to IS 5.3, it’s necessary to add the connector before the migration. For IS versions 5.3 and above, the inclusion of the connector is not required as they already utilize the updated registry path.

  1. Download the latest version of the challenge questions connector from the [connector store](https://store.wso2.com/store/assets/isconnector/details/1f79b51f-acae-4365-83ab-a2f1a6b690f9).
  2. Configure the connector according to the instructions in the [documentation](https://github.com/wso2-extensions/identity-challenge-questions/blob/main/docs/config.md).
  3. Add the following configuration to the <NEW_IS_HOME>/migration-resources/migration-config.yaml file under the  migratorConfigs of version 5.3.0.

  ```
    -
	   name: "ChallengeQuestionDataMigrator"
	   order: 8
	   parameters:
          schema: "identity"
  ```
    
### 6. Merging UI customizations

>**Note :**
> If the UI customizations are related to branding and themes, we suggest to use branding features in IS 7.0.0 for the UI customizations.
> Reach out to our support team through your [support account](https://support.wso2.com/jira/secure/Dashboard.jspa) for assistance if you have UI customizations and proceed with the best recommendation.

- The customizations made in the `<OLD_IS_HOME>/repository/deployment/server/webapps` directory have to be merged with the default webapps available in the `<NEW_IS_HOME>/repository/deployment/server/webapps directory`.
- Do not copy the files from the older instance to the new instance. Instead, merge the custom changes manually to the default files available in the new instance.

### 7. Adding and updating server configurations

- If you have made any changes to the `<OLD_IS_HOME>/repository/conf/deployment.toml` file, make sure to add those changes to the `<NEW_IS_HOME>/repository/conf/deployment.toml` file.
- Go through the [What Has Changed](what-has-changed.md) document and add/update configurations to ensure backward compatibility for any behavioral changes in the new IS.

## Step 2: Evaluating the new instance

This step intends to check whether the new runtime, using IS 7.0, works properly with the previous customizations and extensions implemented by customers for their use cases.

>**Note**
> As we have not yet completed the migration, your current database schema are not compatible with the new IS runtime. Therefore, use a separate test database which is compatible with IS 7.0 for this evaluation.

- Start the new IS instance and verify that the server starts without any issues. Try to resolve any encountered errors or contact [WSO2 Support](https://support.wso2.com/jira/secure/Dashboard.jspa) for assistance.
- Test the basic functionalities, custom components and UI customizations. Try to resolve any encountered issues or contact [WSO2 Support](https://support.wso2.com/jira/secure/Dashboard.jspa) for assistance.

## Step 3: Configuring the migration resources and client

- Visit the latest release tag and download the `wso2is-migration-x.x.x.zip` under Assets. Unzip it to a local directory.
- Copy the `org.wso2.carbon.is.migration-x.x.x.jar` file in the `<IS_MIGRATION_TOOL_HOME>/dropins` directory into the `<NEW_IS_HOME>/repository/components/dropins` directory.
- Copy the migration-resources directory to the root directory of `<NEW_IS_HOME>`.
- Configure the migration property values accordingly in the `<NEW_IS_HOME>/migration-resources/migration-config.yaml` file (Enter the current version of WSO2 Identity Server that you are using for `currentVersion`.)
  ```
  migrationEnable: "true"
  currentVersion: "5.11.0"
  migrateVersion: "7.0.0"
  ```

>**Note**
>
> If you're migrating from a version prior to WSO2 IS 5.11.0, configure **SymmetricKeyInternalCryptoProvider** as the default internal crypto provider.
>
>    1. Generate your own secret key using a tool like OpenSSL.
>
>        ```tab="Example"
>        openssl enc -nosalt -aes-128-cbc -k hello-world -P
>       ```
>
>    2. Add the configuration to the `<NEW_IS_HOME>/repository/conf/deployment.toml` file.
>
>        ```toml
>        [encryption]
>        key = "<provide-your-key-here>"
>        ```
>
>    3. Open the `<NEW_IS_HOME>/migration-resources/migration-config.yaml` file and note that the following two migrators are configured under **migratorConfigs** for 5.11.0:
>
>        - EncryptionAdminFlowMigrator
>        - EncryptionUserFlowMigrator
>
>    4. If you're migrating from a version prior to WSO2 IS 5.6.0, open the `<NEW_IS_HOME>/migration-resources/migration-config.yaml` file and change the value of `transformToSymmetric` to `true` as shown below.
>
>        ```yaml 
>        name: "KeyStorePasswordMigrator"
>        order: 9
>        parameters:
>        schema: "identity"
>        currentEncryptionAlgorithm: "RSA"
>        migratedEncryptionAlgorithm: "RSA/ECB/OAEPwithSHA1andMGF1Padding"
>        transformToSymmetric: "true"
>        ```
>
>    5.  Under each migrator's parameters, find the property value of **currentEncryptionAlgorithm** and ensure that it matches the value of the `org.wso2.CipherTransformation` property found in the `<OLD_IS_HOME>/repository/conf/carbon.properties` file.
> 

## Step 4: Mock migration

### 1. Preparing the database

1. Clone the DB used in the current IS instance.
2. Take a backup of the DB (This is required in case any error occurs during the migration).
3. Execute the DB scripts provided at disabling registry versioning section.
4. Update the DB configurations in `<NEW_IS_HOME>/repository/conf/deployment.toml` file, pointing to the cloned DB.

### 2. Performing dry run 

Before doing the migration, it is recommended to do a dry run and analyze the generated report for any recommendations related to the migration.

Dry-run capability of the migrator allows you to validate the system against the user store configurations and to generate a report regarding the migration compatibility. If there are any warnings in the migration report, it is recommended to contact WSO2 support to identify the best migration strategy.

Follow the steps given below to perform the dry run.

1.  Configure the migration report path using the `reportPath` parameter in the `<IS_HOME>/migration-resources/migration-config.yaml` file.

    > **Info**
    >
    > Use **one** of the following methods when configuring the report path:
    >
    > - Create a text file. Provide the absolute path for that text file for all `reportPath` parameters. All results from the dry run will be appended to this text file.
    > - Create separate directories to store dry run reports of each migrator having the `reportPath` parameter. Provide the absolute paths of these directories for the `reportPath` of the relevant migrator. Dry run result of each migrator will be created in their specific report directories according to the timestamp.

    > **Important**
    >
    > The `reportPath` should be added under a `parameters` attribute in the `migration-config.yaml` file. The `reportPath` attribute and, in some cases, the `parameters` attribute is commented out by default. Both these attributes should be uncommented and the report path value should be added as a string for all migrators which support dry run within the current IS version and the target IS version.

2.  Run the migration utility with the `dryRun` system property:

  -   On Linux/MacOS

      ``` bash 
      sh wso2server.sh -Dmigrate -Dcomponent=identity -DdryRun
      ```

  -   On Windows

      ``` bash
      wso2server.bat -Dmigrate -Dcomponent=identity -DdryRun
      ```

Once this is executed, you can analyze the generated report that resides in the provided location.

### 3. Updating migration time configurations

- Add or update the configurations below in the `<NEW_IS_HOME>/repository/conf/deployment.toml` file.
  ```
  [super_admin]
  ...
  create_admin_account = false
  
  [authorization_manager.properties]
  GroupAndRoleSeparationEnabled = false
  ```

- If you’re using a JDBC primary userstore and the current IS version is IS 5.9 or lower, in order to generate unique IDs for the non-unique ID primary userstore, 

     -     If the user count is less than 1000, the user_store type has to be database, during the migration (So that the unique ID will be generated during the migration) 
     - If the user count is higher than 1000, you should’ve already generated the unique IDs in the Adding and configuring migration resources section.

  ```
  [user_store]
  type = "database"
  ```
  
### 4. Running the migration client

1. Start the new WSO2 IS instance with the following command to execute the migration client.

   -   On Linux/MacOS

       ``` bash 
       sh wso2server.sh -Dmigrate -Dcomponent=identity
       ```

   -   On Windows

       ``` bash
       wso2server.bat -Dmigrate -Dcomponent=identity
       ```

2. Stop the server once the migration client execution is completed, without accessing any of the WSO2 IS pages/links.
3. If you run into any errors during migration,
   - Stop the server.
   - Share the `<IS_HOME>/repository/logs/wso2carbon.log` file with the WSO2 team for analysis.
   - Apply the solution provided by the WSO2 team.
   - Restore the DB with the backup obtained when following the **Preparing the database** section.
   - Execute the DB scripts provided at _disabling registry versioning_ section.
   - Start the migration again.
4. Once the migration is completed without any errors, revert the Migration-time configurations and change the user_store type to database_unique_id.
    ```
    [super_admin]
    ...
    create_admin_account = true
    
    [authorization_manager.properties]
    GroupAndRoleSeparationEnabled = false
    
    [user_store]
    type = "database_unique_id"
    ```
5. Start the server without the migration parameters.

   -   On Linux/MacOS

       ``` bash 
       sh wso2server.sh
       ```

   -   On Windows

       ``` bash
       wso2server.bat
       ```
       
### 5. Testing the migration

- Test the migration, as per _Evaluating the migrated instance_ section.
- Report any issues to the WSO2 team and apply the resolution. Do not proceed with the actual migration until all the issues are resolved.
- If all the test cases are successful, you may proceed with migrating the environment.

## Step 5: Actual migration

### 1. Preparing the database

- Refer to the Preparing the database section in the _Mock migration_ step.
- You may define the down time of the system by calculating the time taken for the mock migration.
- Stop the live instance (No changes are made to the live instance since the migration will be performed on the cloned DB instance. However, the live instance has to be stopped in order to prevent generating new data in the DB, for a down-time migration).

### 2. Performing the dry run

- Refer to the _Performing dry run_ section in the _Mock migration_ step.

### 3. Updating migration time configurations

- Refer to the Updating migration time configurations section in the _Mock migration_ step.

### 4. Running the migration client

- Refer to the _Running the migration client_ section in the _Mock migration_ step.
- You can expect to have no errors during the migration since all the errors should have been detected in the mock migration and resolved. If, on a rare occasion, you do encounter an error, get in touch with the WSO2 team for assistance and plan the next step.

### 5. Testing the migration

- Test the migration, as per _Evaluating the migrated instance_ section (We suggest testing this within the internal network prior to serving the live traffic).
- Report any issues to the WSO2 team and apply the resolution.
- If all the test cases are succeeded, you may proceed with serving the live traffic with the migrated environment.
- You may go for the _Rollback Plan_, if any critical functionalities are not working as expected.

## Evaluating the migrated instance

### 1. Testing the basic functionalities
- Check if the Console is accessible.
- Monitor the system health (CPU, memory usage etc).
- Monitor the WSO2 logs to see if there are errors logged in the log files.
- Perform an authentication flow for any of the applications.

### 2. Run the test suite
- Run functional tests against the migrated deployment to verify that all the functionalities are working as expected.
- Test the authentication flows of all the main applications.

### 3. Quality Assurance of the migrated instance
- Verify all the granular level functionalities are working as expected with the help of the QA team.
- Verify if there are any behavioral changes to be addressed.

## Rollback Plan

1. Stop the migrated WSO2 IS instance.
2. Start the previous WSO2 IS instance (This should be started as usual, since we haven’t used the DB used by this instance - only the clone is used for the migration process).
