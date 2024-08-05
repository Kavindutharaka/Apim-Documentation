# Upgrading from WSO2 EI 6.3.0

This page walks you through the process of upgrading to WSO2 Enterprise Integrator (EI) 6.6.0 from WSO2 EI 6.3.0. This covers the steps for upgrading all of the following profiles in WSO2 EI:

>**Info**
>
> -  For information on what is new in this release and why you should upgrade, see [About this Release](https://docs.wso2.com/display/EI660/About+this+Release).
> -  For more information on ports, see [Default Ports of WSO2 Enterprise Integrator](https://docs.wso2.com/display/EI660/Default+Ports+of+WSO2+Enterprise+Integrator).

-   **ESB** profile
-   **Message Broker** profile
-   **Business Process** profile
-   **Analytics** profile

See the following topics for details:

- [Upgrading from WSO2 EI 6.3.0](#upgrading-from-wso2-ei-630)
  - [Preparing to upgrade](#preparing-to-upgrade)
  - [ESB profile](#esb-profile)
    - [Upgrading the databases](#upgrading-the-databases)
      - [Update the database structure ](#update-the-database-structure)
      - [Update the data](#update-the-data)
    - [Migrating configurations of the ESB profile](#migrating-configurations-of-the-esb-profile)
      - [Updating the configuration files manually](#updating-the-configuration-files-manually)
    - [Migrating artifacts of the ESB profile](#migrating-artifacts-of-the-esb-profile)
  - [Analytics profile](#analytics-profile)
    - [Upgrading the databases and migrating analytics-related data](#upgrading-the-databases-and-migrating-analytics-related-data)
    - [Migrating custom deployable artifacts](#migrating-custom-deployable-artifacts)
    - [Testing the migration](#testing-the-migration)
  - [Message Broker profile](#message-broker-profile)
    - [Migrating configurations of the Message Broker profile](#migrating-configurations-of-the-message-broker-profile)
    - [Migrating artifacts of the Message Broker profile](#migrating-artifacts-of-the-message-broker-profile)
  - [Business Process profile](#business-process-profile)
    - [Migrating configurations of the Business Process profile](#migrating-configurations-of-the-business-process-profile)
    - [Migrating artifacts of the Business Process profile](#migrating-artifacts-of-the-business-process-profile)
  - [Migrating Log4j configurations](#migrating-log4j-configurations)
  - [Starting the profiles](#starting-the-profiles)


## Preparing to upgrade

The following prerequisites must be completed before upgrading:

-   Create a backup of the databases in your WSO2 EI 6.3.0 instance.
-   Copy the `<EI_6.3.0_HOME>` directory to back up the product
    configurations.
-   Go to the [WSO2 Integration website](http://wso2.com/integration/)
    and download WSO2 EI 6.6.0.
-   Install WSO2 EI 6.6.0.

>**Info**
>
>The downtime is limited to the time taken for switching databases in the production environment.

## ESB profile

Follow the instructions given below to upgrade the ESB profile from EI 6.3.0 to EI 6.6.0.

### Upgrading the databases

You can use the same  databases  that you used for the ESB profile of EI 6.3.0 with EI 6.6.0. However, you need to apply the following updates.

#### Update the database structure 

There may be changes in the database structure (schema) that is used in EI 6.6.0. To update the database schema:

1.  Navigate to the database migration scripts, which you received from WSO2 Support.
2.  Unzip the downloaded file and s elect the script relevant to your database type.
3.  Connect to the database and run the script.

Your database schema is now updated for EI 6.6.0.

#### Update the data

You need to remove any instances of [Message Processor Tasks](https://docs.wso2.com/display/EI660/Message+Processors+) that
were stored in the registry database by EI 6.3.0.

>**Info**
>
>EI 6.6.0 requires Message Processor Tasks to be stored in the registry using a **new** naming convention. The naming convention has changed from `TASK_PREFIX` + `messageProcessorName` + `taskNumber` (in EI 6.3.0) to `TASK_PREFIX` + `messageProcessorName` + `SYMBOL_UNDERSCORE` + `taskNumber` (in EI 6.6.0).
>
>When you run the migration client, the existing **Task** references in the registry will be removed. Later in this migration guide, when you [migrate the integration artifacts](https://docs.wso2.com/display/EI660/Upgrading+from+WSO2+EI+6.5.0#UpgradingfromWSO2EI6.5.0-MigratingartifactsoftheESBprofile) from your EI 6.3.0 instance to EI 6.6.0, new records will be created in the registry with the new naming convention.

**Step 1: Set up the WSO2 EI 6.6.0 server**

Apply the following updates to your EI 6.6.0 server.

Connect the ESB profile of EI 6.6.0 to your existing databases (which are used for registry data and user management data):

>**Connecting to the database**
>
>1.  Open the `master-datasources.xml` file (stored in the `<EI_6.6.0_HOME>/conf/datasources/` directory) and update the parameters given below.
>
>       >**Tip**
>       >
>       >By default, registry and user management data are stored in one database and is configured in the `master-datasources.xml` file. If you have separate databases for registry and user management data, you may need separate datasource configurations.
>
>     | **Element** | **Description** |
>     |---|---|
>     | **url** | The URL of the database. |
>     | **username and password** | The name and password of the database user. |
>     | **driverClassName** | The class name of the database driver. |
>
>2.  Open the `registry.xml` file (stored in the `<EI_6.6.0_HOME>/conf` directory) and specify the datasource name (as defined in step \'a\').
>
>     ```
>     <dbConfig name="wso2registry">   
>         <dataSource>jdbc/MY_DATASOURCE_NAME</dataSource>
>     </dbConfig>
>     ```
>
>3.  If a JDBC user store is used, open the `user-mgt.xml` file (stored in the `<EI_6.6.0_HOME>/conf/` directory), and update the following database connection parameters under the `<UserStoreManager class="org.wso2.carbon.user.core.jdbc.JDBCUserStoreManager">` section.
>
>     **Element** | **Description** 
>     ---|---
>     **url** | The URL of the database. 
>     **username and password** | The name and password of the database user. 
>     **driverClassName** | The class name of the database driver. 
>
>4.  Further, update the **system administrator configurations** and the **datasource name** in the `user-mgt.xml` file. See [Configuring a JDBC user store](https://docs.wso2.com/display/EI660/Configuring+a+JDBC+User+Store) for instructions.


**Step 2: Run the migration client**

Now, let's run the migration client from EI 6.6.0. This client changes any message processor data according to the new naming convention.

1.  Create a folder named `migration` inside `<EI_6.6.0_HOME>`.

2.  Copy the `migration-conf.properties` file, which you received from WSO2 Support, to the `<EI_6.6.0_HOME>/migration` folder and update the following properties.

      --------------------- --------------------------------------------------------
      **admin.user.name**   The user name of the system administrator.

      --------------------- --------------------------------------------------------

    **Note** that you do not need to update the keystore-related properties given in the file.

1.  Copy the migration JAR file, which you received from WSO2 Support, into the `<EI_6.6.0_HOME>/dropins/` directory.

1.  Open a terminal and navigate to the `<EI_6.6.0_HOME>/bin/` directory.

2.  Execute the product startup script with the `-Dmigrate.from.product.version=ei630` command as shown below.

    **On MacOS/Linux/CentOS**

    Open a terminal and execute the following command:

    ```
    sh integrator.sh -Dmigrate.from.product.version=ei630
    ```
    
    **On Windows**

    Open a terminal and execute the following command:

    ```
    integrator.bat -Dmigrate.from.product.version=ei630
    ```

3.  Once the migration is successful, stop the server and delete the migration JAR (`org.wso2.carbon.ei.migration-6.6.0.jar)` from the `<EI_6.6.0_HOME>/dropins/` directory.

You can now migrate the configurations and artifacts for the ESB profile as explained below and start the ESB profile.

### Migrating configurations of the ESB profile

>**Info**
>
>Do not copy **configuration files** directly between servers. Instead, [update the files manually](https://docs.wso2.com/display/EI660/Upgrading+from+WSO2+EI+6.3.0#updating-the-configuration-files-manually).

To migrate all the required folders, files, libraries, etc. from EI
6.3.0 to EI 6.6.0:

1.  Copy the database connector JAR files stored in
    the `<EI_6.3.0_HOME>/lib` directory to the same directory in EI 6.6.0.

2.  Copy the keystores and truststores used in the ESB profile of WSO2 EI 6.5.0 from the `<EI_6.3.0_HOME>/repository/resources/security` directory to the same directory in WSO2 EI 6.3.0. 

3.  If you have secondary user stores created for the ESB profile of EI 6.3.0, you need to copy the \'userstore\' folder in
    the `<EI_6.3.0_HOME>/repository/deployment/server/` directory to the same directory in EI 6.6.0.

4.  If there are any third-party libraries used with EI 6.3.0 that you want to migrate, copy the relevant libraries from EI 6.3.0 to EI 6.6.0:
    -   If you have used JMS libraries, JDBC libraries, etc., copy the contents from the `<EI_6.3.0_HOME>/lib` directory to the same
        directory in EI 6.6.0.
    -   If you have used OSGi bundles such as SVN kit etc., copy the contents from the `<EI_6.3.0_HOME>/dropins` directory to the same directory in EI 6.6.0.

#### Updating the configuration files manually
To migrate the configurations from EI 6.3.0 to EI 6.6.0:

1.  Go to the `<EI_6.6.0_HOME>/conf/datasources` directory and update the Carbon datasource configuration in
    the `master-datasources.xml` file. The instructions are available in.

2.  Go to the `<EI_6.6.0_HOME>/conf` directory and update the datasource references in the `user-mgt.xml` and `registry.xml` files to match the updated configurations in the `master-datasources.xml` file. The instructions are available in.

3.  Check for any other configurations that were done for EI 6.3.0 based on your solution, and update the configuration files in EI 6.6.0 accordingly. For example, check the configurations related to external user stores, caching, mounting, transports, etc.

4.  See the instructions on [migrating **log4j** configurations](https://docs.wso2.com/display/EI660/Upgrading+from+WSO2+EI+6.3.0#UpgradingfromWSO2EI6.3.0-MigratingLog4jconfigurationsMigrating) configurations of the Message Broker profile) for the ESB profile.

> **Info**
>
>WSO2 EI no longer packs the smb provider by default. If you need to use the VFS SMB feature, you can download the  jcifs-1.3.17.jar from [here](http://central.maven.org/maven2/jcifs/jcifs/1.3.17/jcifs-1.3.17.jar) and then place it in `<EI_6.6.0_HOME>/lib` directory. Please note that (since the above library is licensed under LGPL version 2.1) by downloading and installing the library you have to comply with the terms of LGPL version 2.1 and its restrictions as found in [this page](https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html).

### Migrating artifacts of the ESB profile

You should manually deploy the Composite Application Archive (C-APP) files that you have in EI 6.3.0 to EI 6.6.0.

> **Warning**
>
>If you have a class mediator packed in a CAR, all the artifacts using that mediator should also be included in the same CAR.

-   To migrate mediation artifacts including message flow configurations, copy the required Synapse artifacts from the `<EI_6.3.0_HOME>/repository/deployment/server/synapse-configs/default` directory to the same directory in EI 6.6.0.
-   To migrate connector artifacts:  
    -  Create a folder named synapse-libs in the `<EI_6.6.0_HOME>/repository/deployment/server/synapse-configs/default/` directory of EI 6.6.0, and copy the JARs from the directory by the same name in EI 6.3.0. Note that this directory will not exist in your EI 6.3.0 distribution if no connectors are used.
    - Copy the JARs from the `<EI_6.3.0_HOME>/repository/deployment/server/synapse-configs/default/imports` directory to the same directory in EI 6.6.0.
-   To migrate the data service artifacts, copy the `<EI_6.3.0_HOME>/repository/deployment/server/dataservices`
    directory to the same directory in EI 6.6.0.
-   If you have custom artifacts created in the `<EI_6.3.0_HOME>/repository/deployment/server/` directory, copy them to the same directory in EI 6.6.0.
-   If multitenancy is used, copy the tenant artifacts from the `<EI_6.3.0_HOME>/repository/tenants` directory to the same
    directory in EI 6.6.0.

## Analytics profile

In EI 6.3.0, the Analytics profile is based on [WSO2 Data Analytics Server](http://docs.wso2.com/data-analytics-server) (WSO2 DAS). In EI 6.6.0 and later versions, the Analytics profile is based on [WSO2 Stream Processor](http://docs.wso2.com/stream-processor) (WSO2 SP). Because of this change, you need to follow the instructions given below when migrating the Analytics profile from EI 6.3.0 to EI 6.6.0.

> **Info**
>
>WSO2 Data Analytics Server is the predecessor of WSO2 Stream Processor. Similar to WSO2 SP, WSO2 DAS processed events via an event flow that consisted of event streams, receivers, publishers, and execution plans. These elements of the event flow are defined separate from each other via the DAS Management Console. WSO2 SP defines the complete event flow within a single application created via a Siddhi file. The application is then deployed in a SP worker node and executed at runtime.
>
>In EI 6.6.0, the Siddhi application required to process EI statistics is already created and deployed in the SP-based EI Analytics profile. Similarly, datasources required for storing data are pre-configured. This setup functions the same way the pre-configured DAS artifacts functioned together in EI Analytics 6.6.0. Therefore, unless you have configured any custom DAS artifacts in your EI Analytics 6.3.0 setup, you do not need to migrate any artifacts. However, you need to setup the databases and migrate the analytics data that you have already saved in EI Analytics 6.3.0.

> **Warning**
>
>You cannot roll back the upgrade process. However, it is possible to restore a backup of the previous database so that you can restart the upgrade progress.

### Upgrading the databases and migrating analytics-related data

The default databases for the SP-based Analytics profile in EI 6.6.0 are available in the `<EI_6.6.0_HOME>/wso2/analytics/wso2/<PROFILE>/database` directory.
However, you need to create the same databases and tables that you currently have in the DAS-based  Analytics profile in EI 6.3.0, and then transfer the data that you have in EI 6.3.0.

Follow the steps given below.

1.  Fork the
    [wos2/product-ei](https://github.com/wso2/product-ei/tree/master/distribution/src/analytics/migration/migration-EI6.x.x-6.4.0/resources) repository.

2.  Then, download this repository from your fork.

    In the following steps, the directory that is downloaded into your machine is referred to as `<PROJECT_HOME>`.

3.  In your terminal, navigate to the `<PROJECT_HOME>/distribution/src/analytics/migration/migration-EI6.x.x-6.4.0/resources/mig-ei-analytics` sub directory and issue the following command.

    mvn clean install

    A new JAR named `migEI.one-jar.jar` is now created inside the `<PROJECT_HOME>/distribution/src/analytics/migration/migration-EI6.x.x-6.4.0/resources/mig-ei-analytics/target` directory. The dependencies of this JAR are also created within the same
    directory.

4.  Copy the `migEIAnalytics.bat` and `migEIAnalytics.sh` files from the `<PROJECT_HOME>/distribution/src/analytics/migration/migration-EI6.x.x-6.4.0/resources` directory to the `<PROJECT_HOME>/distribution/src/analytics/migration/migration-EI6.x.x-6.4.0/resources/mig-ei-analytics/target` directory.

1.  Navigate to the `<PROJECT_HOME>/distribution/src/analytics/migration/migration-EI6.x.x-6.4.0/resources/mig-ei-analytics/target` directory and execute the Analytics migration script:

    **On MacOS/Linux/CentOS** 
    ```
    sh migEIAnalytics.sh
    ```
    **On Windows**
    ```
    migEIAnalytics.bat
    ```

1.  As shown below, you must provide the database type.

    This should be the same database that is configured for EI Analytics 6.6.0.

    The system creates the tables related to EI Analytics in the database you specify.

1.  To run the Analytics profile of EI 6.3.0, open the terminal, navigate to the `<EI-6.3.0_HOME>/wso2/analytics/bin` directory, and
    issue the following command.

    **On MacOS/Linux/CentOS** sh wso2server.sh On
    Windows wso2server.bat

2.  To migrate data related to the Analytics profile, navigate to the `<PROJECT_HOME>/distribution/src/analytics/migration/migration-EI6.x.x-6.4.0/resources` directory and execute the `migEIAnalyticsSpark.sql` Spark script. As a result, the migrated data is stored in the RDBMS database that you specified in step 6.

### Migrating custom deployable artifacts

If you have created any custom DAS artifacts in your EI 6.3.0 Analytics profile, you need to add them in the EI 6.6.0 Analytics profile. For detailed instructions, see [WSO2 Stream Processor Documentation - Upgrading from a previous release - Deployable
artifacts](http://docs.wso2.com/stream-processor/Upgrading%20from%20a%20Previous%20Release#Artifacts).

### Testing the migration

To test whether the EI Analytics profile is successfully migrated, follow the steps below:

1.  To start the Analytics profile of EI 6.6.0, navigate to the `<EI-6.6.0_HOME>/wso2/analytics/bin` directory and execute the
    following command.

    **On MacOS/Linux/CentOS** 
    ```
    sh worker.sh
    ```
    
    **On Windows**
    ```
    worker.bat
    ```

1.  To view the migrated statistics, navigate to the `<EI-6.6.0_HOME>/wso2/analytics/bin` directory and execute the following command:

    **On MacOS/Linux/CentOS** 
    ```
    sh dashboard.sh
    ```
    **On Windows**
    ```
    dashboard.bat
    ```

Once you run one of these scripts, you can access the dashboard via the dashboard URL displayed in the terminal.

## Message Broker profile

Follow the instructions given below to upgrade the Message Broker
profile from EI 6.3.0 to EI 6.6.0.

### Migrating configurations of the Message Broker profile

Do not copy **configuration files** directly between servers. Instead, update the files manually.

To migrate all the required folders, files, libraries, etc. from EI 6.3.0 to EI 6.6.0:

1.  Copy the database connector JAR files stored in the `<EI_6.3.0_HOME>/lib`directory to the same directory EI 6.6.0.
2.  Copy the keystores and truststores used in the Message Broker profile of EI 6.3.0 from the `<EI_6.3.0_HOME>/wso2/broker/repository/resources/security` directory to the same directory in EI 6.6.0.
3.  If you have secondary user stores created for the Message Broker profile of EI 6.3.0, you need to copy the `userstore` folder in the `<EI_6.3.0_HOME>/wso2/broker/repository/deployment/server/` directory to the same directory in EI 6.6.0.

To migrate the configurations from EI 6.3.0 to EI 6.6.0:

1.  Update the configuration files with information of the migrated keystores and truststores. For instructions, see [Configuring Keystores in WSO2 products](https://docs.wso2.com/display/EI660/Configuring+Keystores+in+WSO2+Products).

1.  Go to the `<EI_6.6.0_HOME>/wso2/broker/conf/datasources` directory and update the Carbon datasource configuration in the `master-datasources.xml` file. The instructions are available
    in.

2.  Update the configurations related to the broker-specific database in the `master-datasources.xml` file and other related configurations files. See [Changing the Default Broker](https://docs.wso2.com/display/EI660/Changing+the+Default+Broker+Database+) for instructions.

1.  Go to the `<EI_6.6.0_HOME>/wso2/broker/conf` directory and update the datasource references in the `user-­mgt.xml` and `registry.xml` files to match the updated configurations in the `master­-datasources.xml` file.

2.  Check for any further configurations that were done for the Message Broker profile in EI 6.3.0 based on your solution. For example, check and update the following configurations in the Message Broker profile of EI 6.6.0:

    1.  `broker.xml`

    2.  `metrics.xml`

    3.  `metrics-properties.xml`

    4.  `messaging-event-broker.xml`

    5.  Check configurations related to external user stores, caching,
        mounting, transports etc.

3.  See the instructions on [migrating **log4j** configurations](https://docs.wso2.com/display/EI660/Upgrading+from+WSO2+EI+6.3.0#UpgradingfromWSO2EI6.3.0-MigratingLog4jconfigurations) for the Message Broker profile.

### Migrating artifacts of the Message Broker profile

If multitenancy is used, copy the tenant artifacts from the `<EI_6.3.0_HOME>/wso2/broker/repository/tenants` directory to
the same directory in EI 6.6.0.

## Business Process profile

Follow the instructions given below to upgrade the Business Process profile from EI 6.3.0 to EI 6.6.0.

### Migrating configurations of the Business Process profile

Do not copy **configuration files** directly between servers. Instead, update the files manually.

To migrate all the required folders, files, libraries, etc. from EI 6.3.0 to EI 6.6.0:

1.  Copy the database connector JAR files stored in the `<EI_6.3.0_HOME>/lib` directory to the same directory in EI
    6.6.0. For example, the JAR for the Oracle database (`ojdbc7.jar`) can be copied.

1.  Copy the keystores and truststores used in the Business Process profile of EI 6.3.0 from the `<EI_6.3.0_HOME>/wso2/business-process/repository/resources/security` directory to the same directory in EI 6.6.0.

1.  If you have secondary user stores created for the Business Process profile of EI 6.3.0, you need to copy the `userstore` folder in the `<EI_6.3.0_HOME>/wso2/business-process/repository/deployment/server/` directory to the same directory in EI 6.6.0.

updating_configs_bp To migrate the configurations from EI 6.3.0 to EI
6.6.0:

1.  Update the configuration files with information of the migrated keystores and truststores. For more information, see [Configuring Keystores in WSO2 products](https://docs.wso2.com/display/EI660/Configuring+Keystores+in+WSO2+Products).

1.  Go to the `<EI_6.6.0_HOME>/wso2/business-process/conf/datasources` directory and update the Carbon datasource configuration in the `master-datasources.xml` file. The instructions are available in.

1.  Go to the `<EI_6.6.0_HOME>/wso2/business-process/conf` directory and update the datasource references in the `user-­mgt.xml` and `registry.xml` files to match the updated configurations in the `master­-datasources.xml` file.

1.  Go to the `<EI_6.6.0_HOME>/wso2/business-process/conf/datasources` directory and update the files relevant to your BPMN/BPEL database: 
    -   If you are using BPMN, update the `activiti-datasources.xml` file with the datasource connection details.
    -   If you are using BPEL, update the `bps-datasources.xml` file with the datasource connection details.

    For instructions, see [Changing the Default Databases for BPMN and BPEL](https://docs.wso2.com/display/EI660/Changing+the+Default+Databases+for+BPMN+and+BPEL+).

1.  Open the `<EI_6.6.0_HOME>/wso2/business-process/conf/humantask.xml` file and change `GenerateDdl` to `false`. You can see the deployed human task packages with the version in the console. A migration success message is printed once the migration completes successfully.

    ```
    <GenerateDdl\>false</GenerateDdl\>
    ```

1.  Check for any further configurations that were done for the Business Process profile of EI 6.3.0 based on your solution. For example, check and update the following configurations in EI 6.6.0:

    1.  `humantask.xml`

    2.  `axis2.xml`

    3.  `bps.xml`

    4.  `Activiti.xml`

    5.  `Tenant-mgt.xml`

    6.  `b4p-coordination-config.xml`

    7.  `process-cleanup.properties`

    8.  Check the configurations related to external user stores,
        caching, mounting, transports, etc.

2.  See the instructions on [migrating **log4j** configurations](https://docs.wso2.com/display/EI660/Upgrading+from+WSO2+EI+6.3.0#UpgradingfromWSO2EI6.3.0-MigratingLog4jconfigurations) for the Business Process profile.

### Migrating artifacts of the Business Process profile

Follow the steps given below:

-   Copy the `BPEL.zip` packages in the `<EI_6.3.0_HOME>/wso2/business-process/repository/deployment/server/bpel` directory
    to the same directory in EI 6.6.0.

-   Copy the `BPMN.bar` packages in the `<EI_6.3.0_HOME>/wso2/business-process/repository/deployment/server/bpmn` directory
    to the same directory in EI 6.6.0.` `

-   Copy the `humantask.zip` packages in the `<EI_6.3.0_HOME>/wso2/business-process/repository/deployment/server/humantasks` directory
    to the same directory in EI 6.6.0.

-   If you have custom artifacts created in the `<EI_6.3.0_HOME>/wso2/business-process/repository/deployment/server/` directory,
    copy them to the same directory in EI 6.6.0.

-   If multitenancy is used, copy the tenant artifacts from the `<EI_6.3.0_HOME>/wso2/business-process/repository/tenants` directory
    to the same directory in EI 6.6.0.

## Migrating Log4j configurations

All profiles of EI 6.6.0 use **log4j2** instead of **log4j**. Therefore, the following configurations apply to all profiles of WSO2 EI.

EI 6.6.0 is based on Carbon Kernel 4.5.0, which introduces **log4j2**. Also, the **carbon.logging** jar is not packed with the EI 6.6.0 distribution and the **pax-logging-api** is used instead.

Follow the instructions given below to migrate from **log4j** (in EI 6.3.0) to **log4j2** (in EI 6.6.0).

1.  If you have used a custom log4j component in EI 6.3.0, apply the following changes to your component:

    1.  Replace carbon logging or  `commons.logging` dependencies with pax-logging dependency as shown below.

         ```
         <!-- Pax Logging -->
         <dependency>
            <groupId>org.ops4j.pax.logging</groupId>
            <artifactId>pax-logging-api</artifactId>
            <version>${pax.logging.api.version}</version>
         </dependency>
         
         <!-- Pax Logging Version -->
         <pax.logging.api.version>1.10.1</pax.logging.api.version>
         ```

    2.  If log4j dependency is directly used, apply one of the options given below.

         **Option 1**

         Replace the log4j dependency (shown below) with log4j2 and rewrite the loggers accordingly.

         ```
         <dependency>
            <groupId>org.ops4j.pax.logging</groupId>
            <artifactId>pax-logging-log4j2</artifactId>
            <version>${pax.logging.log4j2.version}</version>
         </dependency>
         ```
        
         **Option 2**

         Replace the log4j dependency with pax-logging dependency and rewrite the loggers using `commons.logging` accordingly.

    3.  If `commons.logging` is imported using Import-Package add the version range.

         ```
         org.apache.commons.logging;
         version="${commons.logging.version.range}" 
         <commons.logging.version.range>[1.2.0,2.0.0)</commons.logging.version.range>
         ```

2.  Follow the instructions on configuring **log4j2**  to register the Appenders and Loggers.

## Starting the profiles

You can now start the EI 6.6.0 product. For instructions on starting each of the profiles in the product, see [Running the Product](https://docs.wso2.com/display/EI660/Running+the+Product).

