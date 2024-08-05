# Upgrade WSO2 Open Banking from 1.5.0 to 2.0.0 for Berlin

This page explains the following:

- Databases and Synapse configurations
- Disable Registry versioning
- Migrating Keystores
- Migrating custom components
- Upgrading Open Banking Identity and Access Management module (Open Banking Key Manager)
- Upgrading Open Banking API Manager
- Upgrading Open Banking Business Intelligence
- Application Attribute Changes
- Republish the APIs

## Databases and Synapse configurations

- Take a backup of the existing database used by WSO2 Open Banking 1.5.0. This backup is necessary in case the migration causes issues in the existing database.
- Take a backup of the existing synapse configurations in WSO2 Open Banking 1.5.0. The synapse configuration is available in the `<WSO2_OB_APIM_HOME>/repository/deployment/server/synapse-configs` directory.

## Disable Registry versioning

When you have enabled versioning for Registry properties and if they are updated frequently, it can lead to an unnecessary growth in the Registry related database tables. To avoid this, WSO2 Open Banking 2.0 disables versioning by default.

If you enabled Registry versioning for your WSO2 Open Banking 1.5.0 setup, you need to disable it before upgrading the solution. The required steps are as follows:

1. Open the `<WSO2_OB_KM_150_HOME>/repository/conf/registry.xml` and `<WSO2_OB_APIM_150_HOME>/repository/conf/registry.xml` files.

2. Locate the following properties in both files:

   ```
   <versioningProperties>true</versioningProperties>
   <versioningComments>true</versioningComments>
   <versioningTags>true</versioningTags>
   <versioningRatings>true</versioningRatings>
   ```

3. If the above configurations are true, use the relevant versioning script provided by the WSO2 team.

    >**Note**
    >
    >If the above versioning configurations are already set as false you should not run the database scripts.

## Migrating Keystores

Copy the keystores (`.jks` files) from WSO2 Open Banking 1.5.0 to WSO2 Open Banking 2.0.0.

| **Copy From**                                           | **Copy To**                                             |
|---------------------------------------------------------|---------------------------------------------------------|
| `<WSO2_OB_KM_150_HOME>/repository/resources/security`   | `<WSO2_OB_IAM_200_HOME>/repository/resources/security`  |
| `<WSO2_OB_APIM_150_HOME>/repository/resources/security` | `<WSO2_OB_APIM_200_HOME>/repository/resources/security` |
| `<WSO2_OB_BI_150_HOME>/repository/resources/security`   | `<WSO2_OB_BI_200_HOME>/repository/resources/security`   |

## Migrating custom components

>**Changed internal API context paths**
>
>The context paths of the following internal APIs have changed. If you have used the following for any custom implementation, update them accordingly:
>
>| **Context path in 1.5.0** | **Context path in 2.0.0**         |
>|---------------------------|-----------------------------------|
>| `/consent`                | `/api/openbanking/consent-mgt`    |
>| `/openbankingberlin`      | `/api/openbanking/backend-berlin` |

>**Renamed JARs and packages**
>
>If you have used the following jar files/packages for any custom implementations, update them as follows:
>
>| **Package name in 1.5.0**             | **Package name in 2.0.0**                            |
>|---------------------------------------|------------------------------------------------------|
>| `com.wso2.finance.periodical.updater` | `com.wso2.finance.open.banking.periodical.updater`   |
>| `com.wso2.finance.status.validater`   | `com.wso2.finance.open.banking.status.validater`     |
>| `eidas-cert-validator`                | `com.wso2.finance.open.banking.eidas.cert.validator` |

### WSO2 Open Banking Identity and Access Management module

The WSO2 Key Manager is referred to as the WSO2 Open Banking Identity and Access Management module in WSO2 Open Banking 2.0.0. This module is based on WSO2 Identity Server 5.10.0, which includes major upgrades to the main component and WSO2 Carbon Kernel. Any customized OSGi bundle added to Identity Server needs to be recompiled with the new dependency versions relevant to Identity Server 5.10.0.

To recompile the custom OSGi bundles:

1. Obtain the source codes of the custom OSGi component
2. Update the dependency versions in the relevant POM files according to Identity Server 5.10.0
3. Compile the project

Make sure to recompile the following and place them in the WSO2 Open Banking 2.0.0 solution

| **Content**                               | **Recompile**                                         | **Copy to**                                            |
|-------------------------------------------|-------------------------------------------------------|--------------------------------------------------------|
| Custom OSGI bundles(manually added files) | `<WSO2_OB_KM_150_HOME>/repository/components/dropins` | `<WSO2_OB_IAM_200_HOME>/repository/components/dropins` |
| Custom JAR files(manually added files)    | `<WSO2_OB_KM_150_HOME>/repository/components/libs`    | `<WSO2_OB_IAM_200_HOME>/repository/components/libs`    |

### WSO2 Open Banking API Management module

You need to copy the custom OSGi bundles and custom JAR files (manually added by you to the solution) as follows:

| **Content**                                | **Copy from**                                           | **Copy to**                                             |
|--------------------------------------------|---------------------------------------------------------|---------------------------------------------------------|
| Custom OSGi bundles (manually added files) | `<WSO2_OB_APIM_150_HOME>/repository/components/dropins` | `<WSO2_OB_APIM_200_HOME>/repository/components/dropins` |
| Custom JAR files(manually added files)     | `<WSO2_OB_APIM_150_HOME>/repository/component/lib`      | `<WSO2_OB_APIM_200_HOME>/repository/components/lib`     |

## Upgrading Open Banking Identity and Access Management module (Open Banking Key Manager)

WSO2 Open Banking 2.0.0 refers to WSO2 Key Manager as the WSO2 Open Banking Identity and Access Management module. This section guides you on how to upgrade from Identity Key Manager 1.5.0 to Identity and Access Management 2.0.0.

This section explains the following:

- Setting Up Database
- Configuring the `deployment.toml` file
- Migrating secondary user stores
- Migrating Databases

### Setting Up Database

1. Copy the relevant JDBC driver to the `<WSO2_OB_IAM_200_HOME>/repository/components/lib` directory.

   >**Tip**
   >
   >If you are using an Oracle database make sure the users have the CREATE PROCEDURE privilege before proceeding.

2. According to your database, execute the relevant database script against the mentioned databases:

   | **Database**             | **Script location**                                                              |
   |--------------------------|----------------------------------------------------------------------------------|
   | `openbank_openbankingdb` | `<WSO2_OB_IAM_200_HOME>/dbscripts/finance/berlin-group.org/migration-1.5.0_to_2` |
   
### Configuring the `deployment.toml` file

WSO2 Open Banking 2.0.0 introduces a new configuration model where the users have all the product configurations in a single configuration file, namely deployment.toml.

1. Copy the `<WSO2_OB_IAM_200_HOME>/repository/resources/finance/scripts/wso2-obiam-conf/deployement/bg/deployment.toml` file to the `<WSO2_OB_IAM_200_HOME>/repository/conf/` directory and replace the existing file.

2. Open the `<WSO2_OB_IAM_200_HOME>/repository/conf/deployment.toml` file and update the datasource configurations for the following databases:

   - User Store
   - Registry database(s)
   - API Manager database
   - Open Banking Database

3. Datasource configurations in 1.5.0 maps with the 2.0.0 new configuration model as follows:

   | **Key Manager 1.5.0**  | **Identity and Access Management 2.0.0** |
   |------------------------|------------------------------------------|
   | `WSO2AM_DB`            | `apim_db`                                |
   | `WSO2CONFIG_DB`        | `config`                                 |
   | `WSO2REG_DB`           | `shared_db`                              |
   | `WSO2UM_DB`            | `WSO2UM_DB`                              |
   | `WSO2_OPEN_BANKING_DB` | `open_banking_database`                  |
   
   **Given below are sample configurations for each database type:**
   
   **MySQL**
   
   ```
   config.url = "jdbc:mysql://localhost:3306/openbank_apimgtdb?autoReconnect=true&useSSL=false"
   config.username = "root"
   config.password = "root"
   config.driver = "com.mysql.jdbc.Driver"
   ```
   
   **MSSQL**
   
   ```
   config.url = "jdbc:sqlserver://localhost:1433;databaseName=openbank_apimgtdb;encrypt=false"
   config.username = "sa"
   config.password = "Root"
   config.driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver"   
   ```
   
   **Oracle**
   
   ```
   config.url = "jdbc:oracle:thin:@localhost:1521:ORCLCDB"
   config.username = "C##bg_ob_apimgtdb"
   config.password = "wso2carbon"
   config.driver = "oracle.jdbc.driver.OracleDriver"   
   ```

4. The `deployment.toml` file contains placeholder, update them with the hostnames of the following servers:
    
    | **Placeholder**      | **Server**                         |
    |----------------------|------------------------------------|
    | `IAM_HOSTNAME`       | Identity and Access Management     |
    | `APIM_HOSTNAME`      | API Management                     |
    | `ANALYTICS_HOSTNAME` | Open Banking Business Intelligence |
    
### Migrating secondary user stores

If you have created any secondary user stores for Open Banking 1.5.0, copy the content to the new setup as follows:

| **Content**           | **Copy from**                                                    | **Copy to**                                                      |
|-----------------------|------------------------------------------------------------------|------------------------------------------------------------------|
| Secondary user stores | `<WSO2_OB_IAM_150_HOME>/repository/deployment/server/userstores` | `<WSO2_OB_IAM_200_HOME>/repository/deployment/server/userstores` |


### Migrating Databases

1. Get the migration client (`wso2is-migration-x.x.x.zip`) provided by the WSO2 team.

2. Extract it into a local directory. The directory where the `wso2is-migration-x.x.x.zip` is extracted is referred to as `<IS_MIGRATION_TOOL_HOME>`.

3. Copy the `<IS_MIGRATION_TOOL_HOME>/dropins/org.wso2.carbon.is.migration-x.x.x.jar` file into the `<WSO2_OB_IAM_200_HOME>/repository/components/dropins` directory.

4. Copy the `<IS_MIGRATION_TOOL_HOME>/migration-resources` directory to the `<WSO2_OB_IAM_200_HOME>` root directory.

5. Open the `<WSO2_OB_IAM_200_HOME>/migration-resources/migration-config.yaml` file:

   1. Make sure versions are as follows:
   
   ```
   migrationEnable: "true"
   currentVersion: "5.7.0"
   migrateVersion: "5.10.0"
   ```
   
   2. Remove the following configurations under the version: "5.8.0" tag:
   
   ```
   -
       name: "UMAPermissionTicketSchemaMigrator"
       order: 3
       parameters:
       location: "step2"
       schema: "uma"
   ```
   
   3. Remove the following configurations under the version: "5.10.0" tag:
   
   ```
   -
       name: "MigrationValidator"
       order: 2
   -
       name: "SchemaMigrator"
       order: 5
       parameters:
       location: "step2"
       schema: "identity"
   ```

6. Update the `<WSO2_OB_IAM_200_HOME>/repository/conf/deployment.toml` by configuring the previous user store.

   ```
   [user_store]
   type = "database"
   #type = "database_unique_id"
   #class = "org.wso2.carbon.user.core.jdbc.UniqueIDJDBCUserStoreManager"
   ```

7. Start the WSO2 Open Banking Identity Access Management 2.0.0 server with the migration client. Use the commands given below:

   **Linux/Unix or macOS**
   
   ```
   sh wso2server.sh -Dmigrate -Dcomponent=identity
   ```
   
   **Windows**
   
   ```
   wso2server.bat -Dmigrate -Dcomponent=identity
   ```

8. Once the migration client execution is completed, stop the server.

9. Remove the `<WSO2_OB_IAM_200_HOME>/repository/components/dropins/org.wso2.carbon.is.migration-x.x.x.jar` file.

10. Remove the `<WSO2_OB_IAM_200_HOME>/migration-resources` directory.

11. Restart the Identity and Access Management server now.

## Upgrading Open Banking API Manager

This section guides you on how to upgrade WSO2 Open Banking API Management 1.5.0 to 2.0.0.

This section explains the following:

- Setting Up Database
- Configuring the `deployment.toml` file
- Moving Synapse configurations
- Migrating Databases
- Migrating API Manager artifacts
- Reindexing Registry artifacts

### Setting Up Database

Copy the relevant JDBC driver to the `<WSO2_OB_APIM_200_HOME>/repository/components/lib` directory.

>**Note**
>
>If you are using an Oracle database make sure the users have the CREATE PROCEDURE privilege before proceeding.

### Configuring the deployment.toml file

WSO2 Open Banking 2.0.0 introduces a new configuration model where the users have all the product configurations in a single configuration file, namely deployment.toml.

1. Copy the `<WSO2_OB_APIM_200_HOME>/repository/resources/finance/scripts/wso2-obam-conf/deployement/bg/deployment.toml` file to the `<WSO2_OB_APIM_200_HOME>/repository/conf/` directory and replace the existing one.

2. Open the `<WSO2_OB_APIM_200_HOME>/repository/conf/deployment.toml` file and update the datasource configurations for the following databases:

   - User Store
   - Registry database(s)
   - API Manager database
   - Open Banking Database

3. Datasource configurations in 1.5.0 maps with the 2.0.0 new configuration model as follows:
    
    | **API Manager 1.5.0**  | **API Manager 2.0.0**   |
    |------------------------|-------------------------|
    | `WSO2AM_DB`            | `apim_db`               |
    | `WSO2CONFIG_DB`        | `config`                |
    | `WSO2REG_DB`           | `shared_db`             |
    | `WSO2UM_DB`            | `WSO2UM_DB`             |
    | `WSO2AM_STATS_DB`      | `WSO2AM_STATS_DB`       |
    | `WSO2_OPEN_BANKING_DB` | `open_banking_database` |

   **Given below are sample configurations for each database type:**
   
   **MySQL**
   
   ```
   config.url = "jdbc:mysql://localhost:3306/openbank_apimgtdb?autoReconnect=true&useSSL=false"
   config.username = "root"
   config.password = "root"
   config.driver = "com.mysql.jdbc.Driver"
   ```
   
   **MSSQL**
   
   ```
   config.url = "jdbc:sqlserver://localhost:1433;databaseName=openbank_apimgtdb;encrypt=false"
   config.username = "sa"
   config.password = "Root"
   config.driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver"
   ```
   
   **Oracle**
   
   ```
   config.url = "jdbc:oracle:thin:@localhost:1521:ORCLCDB"
   config.username = "C##bg_ob_apimgtdb"
   config.password = "wso2carbon"
   config.driver = "oracle.jdbc.driver.OracleDriver"
   ```

4. The `deployment.toml` file contains placeholder, update them with the hostnames of the following servers:
   
   | **Placeholder**      | **Server**                         |
   |----------------------|------------------------------------|
   | `IAM_HOSTNAME`       | Identity and Access Management     |
   | `APIM_HOSTNAME`      | API Management                     |
   | `ANALYTICS_HOSTNAME` | Open Banking Business Intelligence |
   
### Moving Synapse configurations

1. Stop all WSO2 API Manager server instances that are running.

2. Move the following content to WSO2 Open Banking 2.0.0:

   >**Warning**
   >
   >When replacing the Synapse configurations, **do not replace** the following, as they contain API Management module version 2.0.0.
   >- `/api/_RevokeAPI_.xml`
   >- `/sequences/_cors_request_handler_.xml`
   >- `/sequences/main.xml`

   | **Content**                         | **Copy from**                                                                  | **Copy to**                                                                    |
   |-------------------------------------|--------------------------------------------------------------------------------|--------------------------------------------------------------------------------|
   | Synapse super tenant configurations | `<WSO2_OB_APIM_150_HOME>/repository/deployment/server/synapse-configs/default` | `<WSO2_OB_APIM_200_HOME>/repository/deployment/server/synapse-configs/default` |
   
### Migrating Databases

1. To migrate data into WSO2 Open Banking API Manager 2.0.0, execute the relevant database script against the `WSO2AM_DB` database.

2. Get the API Manager migration database scripts provided by the WSO2 team.

### Migrating API Manager artifacts

1. Migration resources:

   1. Get the API Manager migration resources (`migration-resources.zip`) provided by the WSO2 team.
   
   2. Extract the received `migration-resources.zip`.
   
   3. Copy the extracted `migration-resources` directory to the `<WSO2_OB_APIM_200_HOME>` directory.

2. Migration client:

   1. Get the API Manager migration client (`org.wso2.carbon.apimgt.migrate.client-3.1.0-3.jar`) provided by the WSO2 team.

   2. Copy the received `org.wso2.carbon.apimgt.migrate.client-3.1.0-3.jar` to the `<WSO2_OB_APIM_200_HOME>/repository/components/dropins` directory.

3. Start the API Management server with the migration client. Use the commands below:

   **Linux/Unix or macOS**
   
   ```
   sh wso2server.sh -DmigrateFromVersion=2.6.0
   ```
   
   **Windows**
   
   ```
   wso2server.bat -DmigrateFromVersion=2.6.0
   ```

4. Once the migration client execution is completed, stop the server.

5. Remove the `<WSO2_OB_APIM_200_HOME>/repository/components/dropins/org.wso2.carbon.apimgt.migrate.client-3.1.0-3.jar` file.

6. Remove the `<WSO2_OB_APIM_200_HOME>/migration-resources` directory.

### Reindexing Registry artifacts

1. Execute the given database scripts against the `SHARED_DB` database.

2. Get the relevant registry indexing script provided by the WSO2 team.

3. Add the following configurations to the `<WSO2_OB_APIM_200_HOME>/repository/conf/deployment.toml` file.

   ```
   [indexing]
   re_indexing= 1
   ```

4. Backup the `<WSO2_OB_APIM_200_HOME>/solr` directory if it exists, then delete it.

5. Start the API Management server.

## Upgrading Open Banking Business Intelligence

This section explains how to upgrade from Open Banking Business Intelligence 1.5.0 to 2.0.0.

>**Warning**
>
>These steps are only required if you have configured Open Banking Business Intelligence in your existing deployment.

### Migrating the Analytics database

1. Get the relevant analytics migration script provided by the WSO2 team. Execute the downloaded database scripts against the `APIM_ANALYTICS_DB` database.

2. After a WUM update for Open Banking Business Intelligence 1.5.0, the data types and field-names of certain database tables were changed. It is important to reflect these changes in your databases before the upgrading process.

   - Get the relevant updating analytics database scripts provided by the WSO2 team.
   - Update the scripts by replacing the `<APIM_ANALYTICS_DB>` placeholder with the hostname of your database server.
   - Execute the relevant script, according to your database type to perform these changes if they are not already available.

### Migrating configurations

1. Open the following configuration files and update them by configuring the databases that you have used in Open Banking Business Intelligence 1.5.0.

   - `<WSO2_OB_BI_200_HOME>/conf/dashboard/deployment.yaml`
   - `<WSO2_OB_BI_200_HOME>/conf/worker/deployment.yaml`

2. Open the following siddhi files and replace the `<ANALYTICS_HOSTNAME>` placeholder with the hostname of your Open Banking Business Intelligence server.

   - `<WSO2_OB_BI_200_HOME>/deployment/siddhi-files/TRAAccountValidationApp.siddhi`
   - `<WSO2_OB_BI_200_HOME>/deployment/siddhi-files/TRAPaymentValidationApp.siddhi`

3. Place the relevant JDBC driver as an OSGi bundle in the `<WSO2_OB_BI_200_HOME>/lib` directory.

   >**For Oracle or MSSQL database drivers:**
   >
   >You need to include the database driver corresponding to the database for the WSO2 Open Banking Business Intelligence server to communicate with the database. The WSO2 Open Banking Business Intelligence is an OSGi-based product. Therefore, when you integrate third-party products such as Oracle and MS SQL with WSO2 OB BI, you need to check whether the libraries you need to add are OSGi based. If they are not, you need to convert them to OSGi bundles before adding them to the `<WSO2_OB_BI_200_HOME>/lib` directory.
   >To convert the jar files to OSGi bundles, follow the steps below.
   >
   >1. Download the non-OSGi jar for the required third party product, and save it in a preferred directory in your machine.
   >
   >2. Go to the `<WSO2_OB_BI_200_HOME>/bin` directory. Run the command given below to generate the converted file in the `<WSO2_OB_BI_200_HOME>/lib` directory.
   >
   >   ```
   >   ./jartobundle.sh <PATH_TO_NON-OSGi_JAR> ../lib
   >   ```

4. Go to the `<WSO2_OB_BI_200_HOME>/bin` directory and start the Worker and Dashboard profiles.

## Application Attribute Changes

To upgrade the application attribute data :

1. Go to the `<WSO2_OB_IAM_200_HOME>/dbscripts/finance/apimgt/migration_1.5.0_to_2.0.0` directory. 
2. Execute the relevant database script against the `WSO2AM_DB` database. 
3. Restart the WSO2 API Management module.

## Republish the APIs

To use the APIs published in WSO2 Open Banking 1.5.0 setup, you need to redeploy these APIs to reflect the changes from the sequence files.

>**Before you begin:**
>
>1. Open the `<WSO2_OB_APIM_200_HOME>/repository/resources/api_templates/velocity_template.xml` file.
>2. Update the `<IAM_HOSTNAME>` placeholder with the hostname of your Identity and Access Management server.
>3. Restart the API Management server.

1. Sign in to the WSO2 API Publisher at `https://<WSO2_OB_APIM_200_HOST>:9443/publisher`.

2. Navigate to the API listing page, and select the API which you want to edit.

3. Go to **Runtime Configurations** using the left menu panel.

    ![runtime-configs](https://docs.wso2.com/download/thumbnails/150027328/RuntimeConfigs.png?version=1&modificationDate=1603182015000&api=v2)

4. Click the edit button under **Request > Message Mediation**.

5. Now, select the **Custom Policy** option.

6. Upload the relevant in-sequence file from the `<WSO2_OB_APIM_200_HOME>/repository/resources/finance/apis/berlin-group.org` directory.

7. Scroll down and click **SAVE**.

8. Go to **Lifecycle** using the left menu panel.

    ![lifecycle](https://docs.wso2.com/download/attachments/150027328/Lifycycle.png?version=1&modificationDate=1603182015000&api=v2)

9. Redeploy the API by clicking the **Redeploy** button.

    ![redeploy-api](https://docs.wso2.com/download/attachments/150027328/RedeployAPI.png?version=1&modificationDate=1603182015000&api=v2)
