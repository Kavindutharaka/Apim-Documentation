# Data Migration Process

This document outlines the data migration process required when upgrading APIM from an older version to a newer version. The data migration process involves ensuring the compatibility of the databases with the new APIM version.

Please note that no new databases will be created during the data migration process. Instead, the existing databases will be modified to accommodate the new version and these modifications may include creating new tables, altering existing ones, and transferring data between tables. Therefore, after data migration, the new version will function using the previous databases.

This guide offers a general overview of the data migration process and its steps. It also provides a set of guidelines for executing the data migration.

## Data Migration Steps

1. Running Database Scripts:

   - This step involves running the database scripts on the registry database(shared_db) to add missing registry indices.

2. Migration of Identity Data:

   - This step involves the migration of data associated with identity components. This mainly involves creating new tables, altering existing ones, and transferring data between tables.
   - **This is applicable only for cases where inbuilt resident key manager(KM) is used; otherwise, if you have configured WSO2 IS as KM, you must independently migrate IS as KM first.**
   - Use the `Identity Migration Client` to execute the migration of identity data.
   - Additional guidance on running the client can be found in version-specific data migration documents.
   - Note that depending on the number of records in the identity tables, the identity data migration will take a considerable amount of time to finish. Do not stop the server during the migration process and wait until the migration process finishes completely and the server gets started.
   

3. Migration of APIM Data:

    - This step involves the migration of data associated with API-M components. This mainly involves creating new tables, altering existing ones, and transferring data between tables.
    - Use the `APIM Migration Client` to perform the migration of APIM data.
    - Additional guidance on running the client can be found in version-specific data migration documents.
    - Note that depending on the number of records in the tables, the APIM data migration will take a considerable amount of time to finish. Do not stop the server during the migration process and wait until the migration process finishes completely and the server gets started.


## Guidelines
   
1. Before running each migration client, create a **backup of all the databases**.
   
2. **If you are migrating to a distributed deployment**, you are only required to **run the data migration on the Control Plane profile.** In other words, out of the various API-M profile packs you have for each profile, run the data migration only on a Control Plane pack.
   
3. **Regardless of your deployment environment, it is advisable to conduct the data migration on a separate VM/local machine.** Once the data migration is completed, you can direct the production environment deployment to the migrated data source. For more information please refer [Data Migration on Different Environments](other-docs/data-migration-on-different-envs.md).
   
4.  **If you have many APIs**, there could be a high load on the database during the migration. Hence, increase the database pool size during migration. Please refer [Tuning JDBC Pool Configurations](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/mi-setup/performance_tuning/jdbc_tuning/) for more details.

5. Prior to API-M data migration, as a pre-migration step, **validate your old data** using the available pre-validators. 
    <details>
    <summary>Available API Validators </summary>

    | API Validators                         |                                          |                                          |
    | -------------------------------------- | ---------------------------------------- | ---------------------------------------- |
    | **CLI Tag**                            | **Pre-validator**                        | **Purpose**                              |
    | `apiDefinitionValidation`              | API Definition Validator                 | Validates if the API definitions are up to standards so that issues are not encountered during migration. Validations are done to check if APIs have valid OpenAPI, WSDL, Streaming API, or GraphQL API definitions. |
    | `apiAvailabilityValidation`            | API Availability Validator               | Validates the API availability in the database with respect to the API artifacts in the registry in order to verify there are no corrupted entries in the registry.                                                  |
    | `apiResourceLevelAuthSchemeValidation` | API Resource Level Auth Scheme Validator | Usage of resource level security with `Application` and `Application User` in 2.x versions, is not supported. This pre-validation checks and warns about such APIs with unsupported resource-level auth schemes.     |
    | `apiDeployedGatewayTypeValidation`     | API Deployed Gateway Type Validator      | If the deployed Gateway type of an API is given as `none`, deployment of that API will be skipped at migration. This pre-validation warns on such APIs having deployed Gateway type as `none`.                       |
    </details>
   
    <details>
    <summary>Available Application Validators </summary>

    | Application Validators      |                                         |                                         |
    | --------------------------- | --------------------------------------- | --------------------------------------- |
    | **CLI Tag**                 | **Pre-validator**                       | **Purpose**                             |
    | `appThirdPartyKMValidation` | Third Party Key Manager Usage Validator | If third party key managers were used with the old API-M, they may need to be reconfigured for the new API-M version. This pre-validation checks the usage of the built-in key manager and warns otherwise. |
    </details>

   - Commands to run pre-validation can be found in version specific data migration documents.
 
   - You can run data validation on all the existing validators or selected validators. If you only use the `-DrunPreMigration` command, all existing validations will be enabled. If not, you can provide a specific validator, such as `-DrunPreMigration=apiDefinitionValidation`, which only validates the API definitions.

   - **If you want to save the invalid API definitions**, save the invalid API definitions to the local file system during this data validation step. Use the `-DsaveInvalidDefinition` option for this as follows. The invalid definitions will be stored under a folder named `<API-M_HOME>/invalid-swagger-definitions` in the form of `<API_UUID>.json`. Then you can manually correct these definitions.

   - Check the server logs and verify if there are any error logs. If you have encountered any errors in the API definitions, you have to correct them manually on the old version before the component migration.

6. **If you are using PostgreSQL** , the database user should have the 'superuser' permission to migrate the API Manager Databases. If the user is not already a superuser, assign the permission before starting the migration.
    ```sql
    ALTER USER <user> WITH SUPERUSER;
    ```






