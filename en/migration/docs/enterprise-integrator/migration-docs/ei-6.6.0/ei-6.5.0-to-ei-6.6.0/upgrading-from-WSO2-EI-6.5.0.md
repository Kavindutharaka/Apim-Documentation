# Upgrading from WSO2 EI 6.5.0

This page walks you through the process of upgrading to WSO2 Enterprise Integrator (WSO2 EI) 6.6.0 from WSO2 EI 6.5.0. This will cover the steps for upgrading all of the following profiles in WSO2 EI:

-   **ESB** profile
-   **Message Broker** profile
-   **Business Process** profile
-   **Analytics** profile

>**Info**
>
> - For information on what is new in this release and why you should upgrade, see [About this Release](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6520843/About+this+Release). 
> - For more information on ports, see [Default Ports of WSO2 Enterprise Integrator](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6522396/Default+Ports+of+WSO2+Enterprise+Integrator).

See the following topics for details:

- [Preparing to upgrade](#preparing-to-upgrade)  
- [ESB profile](#esb-profile)
  - [Upgrading the databases](#upgrading-the-databases)
    - [Update the database structure](#update-the-database-structure) 
    - [Update the data](#update-the-data)
  - [Migrating configurations of the ESB profile](#migrating-configurations-of-the-esb-profile)
  - [Migrating artifacts of the ESB profile](#migrating-artifacts-of-the-esb-profile)
- [Analytics profile](#analytics-profile)
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

- Create a backup of the databases in your WSO2 EI 6.5.0 instance.
- Copy the `<EI_6.5.0_HOME>` directory to back up the product configurations.
- Go to the [WSO2 Integration website](https://wso2.com/micro-integrator/) and download WSO2 EI 6.6.0.
- [Install](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6520947/Installation+Guide) WSO2 EI 6.6.0.
  
>**Info**
> 
>The downtime is limited to the time taken for switching databases in the production environment.

## ESB profile

Follow the instructions given below to upgrade the ESB profile from WSO2 EI 6.5.0 to WSO2 EI 6.6.0.

### Upgrading the databases

You can use the same [databases](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6520955/Product+Administration#ProductAdministration-databases) that you used for the ESB profile of WSO2 EI 6.5.0 with WSO2 EI 6.6.0. However, you need to first apply the following updates.

#### Update the database structure

There may be changes in the database structure (schema) that is used in EI 6.6.0. To update the database schema:

1. Navigate to the database migration scripts, which you received from WSO2 Support.
2. Unzip the file and select the script relevant to your database type.
3. Connect to the database and run the script.

Your database schema is now updated for EI 6.6.0.

#### Update the data

You need to remove any instances of [Message Processor Tasks](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6521509/Message+Processors) that were stored in the registry database by WSO2 EI 6.5.0.

>**Info**
>
> WSO2 EI 6.6.0 requires [Message Processor Tasks](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6521509/Message+Processors) to be stored in the registry using a **new** naming convention. The naming convention has changed from `TASK_PREFIX + messageProcessorName + taskNumber` (in WSO2 EI 6.5.0) to `TASK_PREFIX + messageProcessorName + SYMBOL_UNDERSCORE + taskNumber` (in WSO2 EI 6.6.0). 
> 
> When you run the following migration client, the existing **Task** references in the registry will be removed. Later in this migration guide, when you [migrate the integration artifacts](#migrating-artifacts-of-the-esb-profile) from your EI 6.5.0 instance to EI 6.6.0, new records will be created in the registry with the new naming convention.

**Step 1: Set up the WSO2 EI 6.6.0 server**

Apply the following updates to your EI 6.6.0 server.

Connect the ESB profile of EI 6.6.0 to your existing databases (which are used for registry data and user management data):

>1. Open the `master-datasources.xml` file (stored in the `<EI_6.6.0_HOME>/conf/datasources/` directory) and update the parameters given below.
>
>       >**Tip**
>       >
>       >By default, registry and user management data are stored in one database and is configured in the `master-datasources.xml` file. If you have separate databases for registry and user management data, you may need separate datasource configurations.
>
>      | **Element**                     | **Description**                             |
>      |---------------------------------|---------------------------------------------|
>      | **url**                         | The URL of the database.                    |
>      | **username** and **password**   | The name and password of the database user. |
>      | **driverClassName**             | The class name of the database driver.      |
>
>2. Open the `registry.xml` file (stored in the `<EI_6.6.0_HOME>/conf` directory) and specify the datasource name (as defined in step 'a').
>
>     ```
>     <dbConfig name="wso2registry">    
>         <dataSource>jdbc/MY_DATASOURCE_NAME</dataSource> 
>     </dbConfig>
>     ```
>    
>3. If a JDBC user store is used, open the `user-mgt.xml` file (stored in the `<EI_6.6.0_HOME>/conf/` directory), and update the following database connection parameters under the `<UserStoreManager class="org.wso2.carbon.user.core.jdbc.JDBCUserStoreManager">` section.
>
>       | **Element**                   | **Description**                             |
>       |-------------------------------|---------------------------------------------|
>       | **url**                       | The URL of the database.                    |
>       | **username** and **password** | The name and password of the database user. |
>       | **driverClassName**           | The class name of the database driver.      |
>
>4. Further, update the **system administrator configurations** and the **datasource name** in the `user-mgt.xml` file. See [Configuring a JDBC user store](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6522265/Configuring+a+JDBC+User+Store) for instructions.

**Step 2: Run the migration client**

Now, let's run the migration client from EI 6.6.0. This client changes any message processor data according to the new naming convention.

1. Create a folder named `migration` inside `<EI_6.6.0_HOME>`.
2. Copy the `migration-conf.properties` file, which you received from WSO2 Support, to the `<EI_6.6.0_HOME>/migration` folder and update the following properties:

   | **admin.user.name** | The user name of the [system administrator](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6522277/Configuring+the+System+Administrator). |
   |---------------------|------------------------------------------------------------------------------------------------------------------------|

   >**Note** 
   > 
   >You do not need to update the keystore-related properties given in the file.

3. Copy the migration JAR file, which you received from WSO2 Support, into the `<EI_6.6.0_HOME>/dropins/` directory.
4. Open a terminal and navigate to the `<EI_6.6.0_HOME>/bin/` directory.
5. Execute the product startup script with the `-Dmigrate.from.product.version=ei650` command as shown below.

   > **On MacOS/Linux/CentOS**
   > Open a terminal and execute the following command:
   >     ```
   >     sh integrator.sh -Dmigrate.from.product.version=ei650
   >     ```
   > 
   > **On Windows**
   > Open a terminal and execute the following command:
   >     ```
   >     integrator.bat -Dmigrate.from.product.version=ei650
   >     ```

6. Once the migration is successful, stop the server and delete the migration JAR (`org.wso2.carbon.ei.migration-6.6.0.jar`) from the `<EI_6.6.0_HOME>/dropins/` directory.

You can now migrate the configurations and artifacts for the ESB profile as explained below and start the ESB profile.

### Migrating configurations of the ESB profile

>**Info**
>
> Do not copy **configuration files** directly between servers. Instead, [update the files manually](#updating-the-configuration-files-manually).

To migrate all the required folders, files, libraries, etc. from WSO2 EI 6.5.0 to WSO2 EI 6.6.0:

1. Copy the database connector JAR files stored in the `<EI_6.5.0_HOME>/lib`  directory to the same directory in WSO2 EI 6.6.0.
2. Copy the keystores and truststores used in the ESB profile of WSO2 EI 6.5.0 from the `<EI_6.5.0_HOME>/repository/resources/security` directory to the same directory in WSO2 EI 6.6.0.
3. If you have secondary user stores created for the ESB profile of WSO2 EI 6.5.0, you need to copy the 'userstore' folder in the `<EI_6.5.0_HOME>/repository/deployment/server/` directory to the same directory in WSO2 EI 6.6.0.
4. If there are any third-party libraries used with WSO2 EI 6.5.0 that you want to migrate, copy the relevant libraries from WSO2 EI 6.5.0 to WSO2 EI 6.6.0:
   - If you have used JMS libraries, JDBC libraries, etc., copy the contents from the `<EI_6.5.0_HOME>/lib` directory to the same directory in WSO2 EI 6.6.0.
   - If you have used OSGi bundles such as SVN kit etc., copy the contents from the `<EI_6.5.0_HOME>/dropins` directory to the same directory in WSO2 EI 6.6.0.

#### Updating the configuration files manually

To migrate the configurations from WSO2 EI 6.5.0 to WSO2 EI 6.6.0:

1. Go to the `<EI_6.6.0_HOME>/conf/datasources` directory and update the Carbon datasource configuration in the `master-datasources.xml` file. For instructions, see [Changing the Carbon Database](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6522227/Changing+the+Carbon+Database) and select your database type.
2. Go to the `<EI_6.6.0_HOME>/conf` directory and update the datasource references in the `user-mgt.xml` and `registry.xml` files to match the updated configurations in the `master-datasources.xml` file. The instructions are available in [Changing the Carbon Database](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6522227/Changing+the+Carbon+Database).
3. Check for any other configurations that were done for WSO2 EI 6.5.0 based on your solution, and update the configuration files in WSO2 EI 6.6.0 accordingly. For example, check the configurations related to external user stores, caching, mounting, transports, etc.
4. See the instructions on [migrating **log4j** configurations](#migrating-log4j-configurations) for the ESB profile.

>**Info:**
> 
>WSO2 EI no longer packs the smb provider by default. If you need to use the VFS SMB feature, you can download the `jcifs-1.3.17.jar` from [here](http://central.maven.org/maven2/jcifs/jcifs/1.3.17/jcifs-1.3.17.jar) and then place it in `<EI_6.6.0_HOME/lib>` directory. Please note that (since the above library is licensed under LGPL version 2.1) by downloading and installing the library you have to comply with the terms of LGPL version 2.1 and its restrictions as found in [this page](https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html).

### Migrating artifacts of the ESB profile

You should manually deploy the Composite Application Archive (C-APP) files that you have in WSO2 EI 6.5.0 to WSO2 EI 6.6.0.

>**Warning**
>
> If you have a class mediator packed in a CAR, all the artifacts using that mediator should also be included in the same CAR.

- To migrate mediation artifacts including message flow configurations, copy the required Synapse artifacts from the `<EI_6.5.0_HOME>/repository/deployment/server/synapse-configs/default` directory to the same directory in WSO2 EI 6.6.0.
- To migrate connector artifacts:
    - Create a folder named synapse-libs in the `<EI_6.6.0_HOME>/repository/deployment/server/synapse-configs/default/` directory of WSO2 EI 6.6.0, and copy the JARs from the directory by the same name in WSO2 EI 6.5.0. Note that this directory will not exist in your WSO2 EI 6.5.0 distribution if no connectors are used.
    - Copy the JARs from the `<EI_6.5.0_HOME>/repository/deployment/server/synapse-configs/default/imports` directory to the same directory in WSO2 EI 6.6.0.
- To migrate the data service artifacts, copy the `<EI_6.5.0_HOME>/repository/deployment/server/dataservices` directory to the same directory in WSO2 EI 6.6.0.
- If you have custom artifacts created in the `<EI_6.5.0_HOME>/repository/deployment/server/` directory, copy them to the same directory in WSO2 EI 6.6.0.
- If multitenancy is used, copy the tenant artifacts from the `<EI_6.5.0_HOME>/repository/tenants` directory to the same directory in WSO2 EI 6.6.0.

## Analytics profile

If you have configured EI 6.5.0 to publish ESB data to the Analytics profile, you need to enable the same in EI 6.6.0. To do this, follow the instructions in [Publishing ESB Data to Analytics](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6521721/Publishing+ESB+Data+to+Analytics).

>**Note:**
> 
>From EI 6.6.0 onwards, you need to configure the `<EI_HOME>/conf/carbon.xml` file to enable the ESB server to publish statistics to the Analytics profile, whereas in the EI 6.5.0 and older versions you need to configure the `<EI_HOME>/repository/deployment/server/eventpublishers/MessageFlowConfigurationPublisher.xml` and `<EI_HOME>/repository/deployment/server/eventpublishers/MessageFlowStatisticsPublisher.xml` files instead.

## Message Broker profile

Follow the instructions given below to upgrade the Message Broker profile from WSO2 EI 6.5.0 to WSO2 EI 6.6.0.

### Migrating configurations of the Message Broker profile

Do not copy **configuration files** directly between servers. Instead, [update the files manually](#updating-the-configuration-files-manually). 

To migrate all the required folders, files, libraries, etc. from WSO2 EI 6.5.0 to WSO2 EI 6.6.0:

1. Copy the database connector JAR files stored in the `<EI_6.5.0_HOME>/lib`  directory to the same directory WSO2 EI 6.6.0.
2. Copy the keystores and truststores used in the Message Broker profile of WSO2 EI 6.5.0 from the `<EI_6.5.0_HOME>/wso2/broker/repository/resources/security` directory to the same directory in WSO2 EI 6.6.0.
3. If you have secondary user stores created for the Message Broker profile of WSO2 EI 6.5.0, you need to copy the `userstore` folder in the `<EI_6.5.0_HOME>/wso2/broker/repository/deployment/server/` directory to the same directory in WSO2 EI 6.6.0.

To migrate the configurations from WSO2 EI 6.5.0 to WSO2 EI 6.6.0:

1. Update the configuration files with information of the migrated keystores and truststores. For instructions, see [Configuring Keystores in WSO2 products](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6522317/Configuring+Keystores+in+WSO2+Products).
2. Go to the `<EI_6.6.0_HOME>/wso2/broker/conf/datasources` directory and update the Carbon datasource configuration in the `master-datasources.xml` file. See [Changing the Carbon Database](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6522227/Changing+the+Carbon+Database) for instructions.
3. Update the configurations related to the broker-specific database in the `master-datasources.xml` file and other related configurations files. See [Changing the Carbon Database](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6522227/Changing+the+Carbon+Database) for instructions.
4. Go to the `<EI_6.6.0_HOME>/wso2/broker/conf` directory and update the datasource references in the `user-mgt.xml` and `registry.xml` files to match the updated configurations in the `master-datasources.xml` file. The instructions are available in [Changing the Carbon Database](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6522227/Changing+the+Carbon+Database).

5. Check for any further configurations that were done for the Message Broker profile in WSO2 EI 6.5.0 based on your solution. For example, check and update the following configurations in the Message Broker profile of WSO2 EI 6.6.0:
   1. `broker.xml`
   2. `metrics.xml`
   3. `metrics-properties.xml`
   4. `messaging-event-broker.xml`
6. Check configurations related to external user stores, caching, mounting, transports etc.
7. See the instructions on [migrating **log4j** configurations](#migrating-log4j-configurations) for the Message Broker profile.

### Migrating artifacts of the Message Broker profile

If multitenancy is used, copy the tenant artifacts from the `<EI_6.5.0_HOME>/wso2/broker/repository/tenants` directory to the same directory in WSO2 EI 6.6.0.

## Business Process profile

Follow the instructions given below to upgrade the Business Process profile from WSO2 EI 6.5.0 to WSO2 EI 6.6.0.

### Migrating configurations of the Business Process profile

Do not copy **configuration files** directly between servers. Instead, [update the files manually](#updating-the-configuration-files-manually). 

To migrate all the required folders, files, libraries, etc. from WSO2 EI 6.5.0 to WSO2 EI 6.6.0:

1. Copy the database connector JAR files stored in the `<EI_6.5.0_HOME>/lib` directory to the same directory in WSO2 EI 6.6.0. For example, the JAR for the Oracle database (`ojdbc7.jar`) can be copied.
2. Copy the keystores and truststores used in the Business Process profile of WSO2 EI 6.5.0 from the `<EI_6.5.0_HOME>/wso2/business-process/repository/resources/security` directory to the same directory in WSO2 EI 6.6.0.
3. If you have secondary user stores created for the Business Process profile of WSO2 EI 6.5.0, you need to copy the `userstore` folder in the `<EI_6.5.0_HOME>/wso2/business-process/repository/deployment/server/` directory to the same directory in WSO2 EI 6.6.0.

To migrate the configurations from WSO2 EI 6.5.0 to WSO2 EI 6.6.0:

1. Update the configuration files with information of the migrated keystores and truststores. For more information, see [Configuring Keystores in WSO2 products](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6522317/Configuring+Keystores+in+WSO2+Products).
2. Go to the `<EI_6.6.0_HOME>/wso2/business-process/conf/datasources` directory and update the Carbon datasource configuration in the `master-datasources.xml` file. For instructions, see [Changing the Carbon Database](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6522227/Changing+the+Carbon+Database) and select your database type.
3. Go to the `<EI_6.6.0_HOME>/wso2/business-process/conf` directory and update the datasource references in the `user-mgt.xml` and `registry.xml` files to match the updated configurations in the `master-datasources.xml` file. The instructions are available in [Changing the Carbon Database](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6522227/Changing+the+Carbon+Database).
4. Go to the `<EI_6.6.0_HOME>/wso2/business-process/conf/datasources` directory and update the files relevant to your BPMN/BPEL database:
   - If you are using BPMN, update the `activiti-datasources.xml` file with the datasource connection details.
   - If you are using BPEL, update the `bps-datasources.xml` file with the datasource connection details.

   For instructions, see [Changing the Default Databases for BPMN and BPEL](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6521091/Changing+the+Default+Databases+for+BPMN+and+BPEL).

5. Open the `<EI_6.6.0_HOME>/wso2/business-process/conf/humantask.xml` file and change `GenerateDdl` to `false`. You can see the deployed human task packages with the version in the console. A migration success message is printed once the migration completes successfully.

   ```
   <GenerateDdl>false</GenerateDdl>
   ```

6. Check for any further configurations that were done for the Business Process profile of WSO2 EI 6.5.0 based on your solution. For example, check and update the following configurations in WSO2 EI 6.6.0:
     1. `humantask.xml`
     2. `axis2.xml`
     3. `bps.xml` 
     4. `Activiti.xml` 
     5. `Tenant-mgt.xml` 
     6. `b4p-coordination-config.xml` 
     7. `process-cleanup.properties`
7. Check the configurations related to external user stores, caching, mounting, transports, etc.

8. See the instructions on [migrating **log4j** configurations](#migrating-log4j-configurations) for the Business Process profile.

### Migrating artifacts of the Business Process profile

Follow the steps given below:

- Copy the `BPEL.zip` packages in the `<EI_6.5.0_HOME>/wso2/business-process/repository/deployment/server/bpel` directory to the same directory in WSO2 EI 6.6.0.
- Copy the `BPMN.bar` packages in the `<EI_6.5.0_HOME>/wso2/business-process/repository/deployment/server/bpmn` directory to the same directory in WSO2 EI 6.6.0.
- Copy the `humantask.zip` packages in the `<EI_6.5.0_HOME>/wso2/business-process/repository/deployment/server/humantasks` directory to the same directory in WSO2 EI 6.6.0.
- If you have custom artifacts created in the `<EI_6.5.0_HOME>/wso2/business-process/repository/deployment/server/` directory, copy them to the same directory in WSO2 EI 6.6.0.
- If multitenancy is used, copy the tenant artifacts from the `<EI_6.5.0_HOME>/wso2/business-process/repository/tenants` directory to the same directory in WSO2 EI 6.6.0.

## Migrating Log4j configurations

>**Note:**
> 
>All profiles of WSO2 EI 6.6.0 use **log4j2** instead of **log4j**. Therefore, the following configurations apply to all profiles of WSO2 EI.

WSO2 EI 6.6.0 is based on Carbon Kernel 4.5.0, which introduces **log4j2**. Also, the **carbon.logging** jar is not packed with the EI 6.6.0 distribution and the **pax-logging-api** is used instead.

Follow the instructions given below to migrate from **log4j** (in WSO2 EI 6.5.0) to **log4j2** (in WSO2 EI 6.6.0).

1. If you have used a custom log4j component in EI 6.5.0, apply the following changes to your component:

    1. Replace carbon logging or commons.logging dependencies with pax-logging dependency as shown below.
       
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
   
    2. If log4j dependency is directly used, apply one of the options given below.

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
       
       Replace the log4j dependency with pax-logging dependency and rewrite the loggers using commons.logging accordingly.
       
    3. If commons.logging is imported using Import-Package add the version range.
       
       ```
       org.apache.commons.logging;
       version="${commons.logging.version.range}" 
       <commons.logging.version.range>[1.2.0,2.0.0)</commons.logging.version.range>
       ```
   
2. Follow the [instructions on configuring **log4j2**](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6521063/Configuring+Log4j2+Properties) to register the Appenders and Loggers.

### Starting the profiles

You can now start the WSO2 EI 6.6.0 product. For instructions on starting each of the profiles in the product, see [Running the Product](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6520949/Running+the+Product).
