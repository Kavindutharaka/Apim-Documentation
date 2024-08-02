# Upgrading from WSO2 EI 6.4.0

This page walks you through the process of upgrading to WSO2 Enterprise Integrator (WSO2 EI) 6.5.0 from WSO2 EI 6.4.0. This will cover the steps for upgrading all of the following profiles in WSO2 EI:

- ESB profile
- Message Broker profile 
- Business Process profile 
- Analytics profile

> **Before you begin**
> 
> Note the following:
> 
> - If you are upgrading from a version older than WSO2 EI 6.4.0, you should first upgrade to WSO2 EI 6.4.0, and then upgrade to WSO2 EI 6.5.0.
> - For information on what is new in this release and why you should upgrade, see [About this Release](https://wso2docs.atlassian.net/wiki/spaces/EI650/pages/35553285/About+this+Release).
> - For more information on ports, see [Default ports of WSO2 Products](https://wso2docs.atlassian.net/wiki/spaces/ADMIN44x/pages/6684816/Default+Ports+of+WSO2+Products). The default ports in WSO2 EI are listed under Enterprise Integrator.

See the following topics for details:
- Preparing to upgrade 
- Upgrading the databases 
- ESB profile
  - Migrating configurations of the ESB profile
  - Migrating artifacts of the ESB profile 
- Message Broker profile
  - Migrating configurations of the Message Broker profile
  - Migrating artifacts of the Message Broker profile 
- Business Process profile
  - Migrating configurations of the Business Process profile
  - Migrating artifacts of the Business Process profile 
- Analytics profile
- Starting the profiles

## Preparing to upgrade

The following prerequisites must be completed before upgrading:

- Create a backup of the databases in your WSO2 EI 6.4.0 instance.
- Copy the `<EI_6.4.0_HOME>` directory to back up the product configurations. 
- Download the product installer from [here](https://wso2.com/micro-integrator/), and install WSO2 EI 6.5.0.

  Let's call the installation location of your product the `<EI_HOME>` directory.

  If you installed the product using the installer, this is located in a place specific to your OS as shown below:

  | OS      | Home directory                                      |
  |---------|-----------------------------------------------------|
  | MacOS   | `/Library/WSO2/EnterpriseIntegrator/6.5.0`          |
  | Windows | `C:\Program Files\WSO2\EnterpriseIntegrator\6.5.0\` |
  | Ubuntu  | `/usr/lib/wso2/EnterpriseIntegrator/6.5.0`          |
  | CentOS  | `/usr/lib64/EnterpriseIntegrator/6.5.0`             |

>**Info**
>
>The downtime is limited to the time taken for switching databases in the production environment.

## Upgrading the databases

You can use the same [databases](https://wso2docs.atlassian.net/wiki/spaces/EI650/pages/35553781/Product+Administration) that you used for WSO2 EI 6.4.0 with WSO2 EI 6.5.0.

## ESB profile

Follow the instructions given below to upgrade the ESB profile from WSO2 EI 6.4.0 to WSO2 EI 6.5.0.

### Migrating configurations of the ESB profile

> **Warning**
> 
> Do not copy configuration files directly between servers. Instead, update the files manually.

To migrate all the required folders, files, libraries, etc. from WSO2 EI 6.4.0 to WSO2 EI 6.5.0:
1. Copy the database connector JAR files stored in the `<EI_6.4.0_HOME>/lib` directory to the same directory in WSO2 EI 6.5.0.
2. Copy the keystores and truststores used in the ESB profile of WSO2 EI 6.4.0 from the `<EI_6.4.0_HOME>/repository/resources/security` directory to the same directory in WSO2 EI 6.5.0.
3. If you have secondary user stores created for the ESB profile of WSO2 EI 6.4.0, you need to copy the `userstore` folder in the `<EI_6.4.0_HOME>/repository/deployment/server/` directory to the same directory in WSO2 EI 6.5.0.
4. If there are any third-party libraries used with WSO2 EI 6.4.0 that you want to migrate, copy the relevant libraries from WSO2 EI 6.4.0 to WSO2 EI 6.5.0:
   - If you have used JMS libraries, JDBC libraries, etc., copy the contents from the `<EI_6.4.0_HOME>/lib` directory to the same directory in WSO2 EI 6.5.0.
   - If you have used OSGi bundles such as SVN kit etc., copy the contents from the `<EI_6.4.0_HOME>/dropins` directory to the same directory in WSO2 EI 6.5.0. 

To migrate the configurations from WSO2 EI 6.4.0 to WSO2 EI 6.5.0:

1. Update the configuration files with information of the migrated keystores and truststores. For instructions, see [Configuring Keystores in WSO2 products](https://wso2docs.atlassian.net/wiki/spaces/ADMIN44x/pages/6684752/Configuring+Keystores+in+WSO2+Products).
2. Go to the `<EI_HOME>/conf/datasources` directory and update the Carbon datasource configuration in the `master-datasources.xml` file. For instructions, see [Changing the Carbon Database](https://wso2docs.atlassian.net/wiki/spaces/ADMIN44x/pages/6685361/Changing+the+Carbon+Database) and select your database type.
3. Go to the `<EI_HOME>/conf` directory and update the datasource references in the `user-mgt.xml` and `registry.xml` files to match the updated configurations in the `master-datasources.xml` file. The instructions are available in [Changing the Carbon Database](https://wso2docs.atlassian.net/wiki/spaces/ADMIN44x/pages/6685361/Changing+the+Carbon+Database).
4. Check for any other configurations that were done for WSO2 EI 6.4.0 based on your solution, and update the configuration files in WSO2 EI 6.5.0 accordingly. For example, check the configurations related to external user stores, caching, mounting, transports, etc.

### Migrating artifacts of the ESB profile

You should manually deploy the Composite Application Archive (C-APP) files that you have in WSO2 EI 6.4.0 to WSO2 EI 6.5.0.

- To migrate mediation artifacts including message flow configurations, copy the required Synapse artifacts from the `<EI_6.4.0_HOME>/repository/deployment/server/synapse-configs/default` directory to the same directory in WSO2 EI 6.5.0.
- To migrate connector artifacts:
   - Create a folder named synapse-libs in the `<EI_HOME>/repository/deployment/server/synapse-configs/default/` directory of WSO2 EI 6.5.0, and copy the JARs from the directory by the same name in WSO2 EI 6.4.0. Note that this directory will not exist in your WSO2 EI 6.4.0 distribution if no connectors are used.
   - Copy the JARs from the `<EI_6.4.0_HOME>/repository/deployment/server/synapse-configs/default/imports` directory to the same directory in WSO2 EI 6.5.0.
- To migrate the data service artifacts, copy the `<EI_6.4.0_HOME>/repository/deployment/server/dataservices` directory to the same directory in WSO2 EI 6.5.0.
- If you have custom artifacts created in the `<EI_6.4.0_HOME>/repository/deployment/server/` directory, copy them to the same directory in WSO2 EI 6.5.0.
- If multitenancy is used, copy the tenant artifacts from the `<EI_6.4.0_HOME>/repository/tenants` directory to the same directory in WSO2 EI 6.5.0:

## Message Broker profile

Follow the instructions given below to upgrade the Message Broker profile from WSO2 EI 6.4.0 to WSO2 EI 6.5.0.

### Migrating configurations of the Message Broker profile

> **Warning**
> 
> Do not copy configuration files directly between servers. Instead, update the files manually.

To migrate all the required folders, files, libraries, etc. from WSO2 EI 6.4.0 to WSO2 EI 6.5.0:

1. Copy the database connector JAR files stored in the `<EI_6.4.0_HOME>/lib` directory to the same directory WSO2 EI 6.5.0.
2. Copy the keystores and truststores used in the Message Broker profile of WSO2 EI 6.4.0 from the `<EI_6.4.0_HOME>/wso2/broker/repository/resources/security` directory to the same directory in WSO2 EI 6.5.0.
3. If you have secondary user stores created for the Message Broker profile of WSO2 EI 6.4.0, you need to copy the 'userstore' folder in the <EI_6.4.0_HOME>/wso2/broker/repository/deployment/server/ directory to the same directory in WSO2 EI 6.5.0.

To migrate the configurations from WSO2 EI 6.4.0 to WSO2 EI 6.5.0:

1. Update the configuration files with information of the migrated keystores and truststores. For instructions, see [Configuring Keystores in WSO2 products](https://wso2docs.atlassian.net/wiki/spaces/ADMIN44x/pages/6684752/Configuring+Keystores+in+WSO2+Products).
2. Go to the `<EI_HOME>/wso2/broker/conf/datasources` directory and update the Carbon datasource configuration in the `master-datasources.xml` file. See [Changing the Carbon Database](https://wso2docs.atlassian.net/wiki/spaces/ADMIN44x/pages/6685361/Changing+the+Carbon+Database) for instructions.
3. Update the configurations related to the broker-specific database in the `master-datasources.xml` file and other related configurations files. See [Changing the Default Broker Database](https://wso2docs.atlassian.net/wiki/spaces/EI650/pages/35553859/Changing+the+Default+Broker+Database) for instructions.
4. Go to the `<EI_HOME>/wso2/broker/conf` directory and update the datasource references in the `user-mgt.xml` and `registry.xml` files to match the updated configurations in the `master-datasources.xml` file. The instructions are available in [Changing the Carbon Database](https://wso2docs.atlassian.net/wiki/spaces/ADMIN44x/pages/6685361/Changing+the+Carbon+Database).
5. Check for any further configurations that were done for the Message Broker profile in WSO2 EI 6.4.0 based on your solution. For example, check and update the following configurations in the Message Broker profile of WSO2 EI 6.5.0:
   1. `broker.xml`
   2. `metrics.xml`
   3. `metrics-properties.xml`
   4. `messaging-event-broker.xml`
6. Check configurations related to external user stores, caching, mounting, transports etc.

### Migrating artifacts of the Message Broker profile

If multitenancy is used, copy the tenant artifacts from the `<EI_6.4.0_HOME>/wso2/broker/repository/tenants` directory to the same directory in WSO2 EI 6.5.0.

## Business Process profile

Follow the instructions given below to upgrade the Business Process profile from WSO2 EI 6.4.0 to WSO2 EI 6.5.0.

### Migrating configurations of the Business Process profile

> **Warning**
> 
> Do not copy configuration files directly between servers. Instead, update the files manually.

To migrate all the required folders, files, libraries, etc. from WSO2 EI 6.4.0 to WSO2 EI 6.5.0:

1. Copy the database connector JAR files stored in the `<EI_6.4.0_HOME>/lib` directory to the same directory in WSO2 EI 6.5.0. For example, the JAR for the Oracle database (`ojdbc7.jar`) can be copied.
2. Copy the keystores and truststores used in the Business Process profile of WSO2 EI 6.4.0 from the `<EI_6.4.0_HOME>/wso2/business- process/repository/resources/security` directory to the same directory in WSO2 EI 6.5.0.
3. If you have secondary user stores created for the Business Process profile of WSO2 EI 6.4.0, you need to copy the `userstore` folder in the `<EI_6 .4.0_HOME>/wso2/business-process/repository/deployment/server/` directory to the same directory in WSO2 EI 6.5.0.

To migrate the configurations from WSO2 EI 6.4.0 to WSO2 EI 6.5.0:

1. Update the configuration files with information of the migrated keystores and truststores. For more information, see [Configuring Keystores in WSO2 products](https://wso2docs.atlassian.net/wiki/spaces/ADMIN44x/pages/6684752/Configuring+Keystores+in+WSO2+Products).
2. Go to the `<EI_HOME>/wso2/business-process/conf/datasources` directory and update the Carbon datasource configuration in the `master-datasources.xml` file. For instructions, see [Changing the Carbon Database](https://wso2docs.atlassian.net/wiki/spaces/ADMIN44x/pages/6685361/Changing+the+Carbon+Database) and select your database type.
3. Go to the `<EI_HOME>/wso2/business-process/conf` directory and update the datasource references in the `user-mgt.xml` and `registry .xml` files to match the updated configurations in the `master-datasources.xml` file. The instructions are available in [Changing the Carbon Database](https://wso2docs.atlassian.net/wiki/spaces/ADMIN44x/pages/6685361/Changing+the+Carbon+Database).
4. Go to the `<EI_HOME>/wso2/business-process/conf/datasources` directory and update the files relevant to your BPMN/BPEL database: If you are using BPMN, update the `activiti-datasources.xml` file with the datasource connection details.
   If you are using BPEL, update the `bps-datasources.xml` file with the datasource connection details.
   For instructions, see [Changing the Default Databases for BPMN and BPEL](https://wso2docs.atlassian.net/wiki/spaces/EI650/pages/35553907/Changing+the+Default+Databases+for+BPMN+and+BPEL).
5. Open the `<EI_HOME>/wso2/business-process/conf/humantask.xml` file and change `GenerateDdl` to `false`. You can see the deployed human task packages with the version in the console. A migration success message is printed once the migration completes successfully.

   ```
   <GenerateDdl>false</GenerateDdl>
   ```

6. Check for any further configurations that were done for the Business Process profile of WSO2 EI 6.4.0 based on your solution. For example, check and update the following configurations in WSO2 EI 6.5.0:
   1. `humantask.xml` 
   2. `axis2.xml`
   3. `bps.xml`
   4. `Activiti.xml` 
   5. `Tenant-mgt.xml`
   6. `b4p-coordination-config.xml`
   7. `process-cleanup.properties`

7. Check the configurations related to external user stores, caching, mounting, transports, etc.

### Migrating artifacts of the Business Process profile

Follow the steps given below:

- Copy the `BPEL.zip` packages in the `<EI_6.4.0_HOME>/wso2/business-process/repository/deployment/server/bpel` directory to the same directory in WSO2 EI 6.5.0.
- Copy the `BPMN.bar` packages in the `<EI_6.4.0_HOME>/wso2/business-process/repository/deployment/server/bpmn` directory to the same directory in WSO2 EI 6.5.0.
- Copy the `humantask.zip` packages in the `<EI_6.4.0_HOME>/wso2/business-process/repository/deployment/server/humantasks` directory to the same directory in WSO2 EI 6.5.0.
- If you have custom artifacts created in the `<EI_6.4.0_HOME>/wso2/business-process/repository/deployment/server/` directory, copy them to the same directory in WSO2 EI 6.5.0.
- If multitenancy is used, copy the tenant artifacts from the `<EI_6.4.0_HOME>/wso2/business-process/repository/tenants` directory to the same directory in WSO2 EI 6.5.0.

## Analytics profile
If you have configured EI 6.4.0 to publish ESB data to the Analytics profile, you need to enable the same in EI 6.5.0. To do this, follow the instructions in [Publishing ESB Data to the Analytics Profile](https://wso2docs.atlassian.net/wiki/spaces/EI650/pages/35553779/Publishing+ESB+Data+to+the+Analytics+Profile).
 
> **Info:**
> 
> Note that from EI 6.5.0 onwards, you need to configure the `<EI_HOME>/conf/carbon.xml` file to enable the ESB server to publish statistics to the Analytics profile, whereas in the EI 6.4.0 and older versions you need to configure the `<EI_HOME>/repository/deployment/server/eventpublishers/MessageFlowConfigurationPublisher.xml` and `<EI_HOME>/repository/deployment/server/eventpublishers/MessageFlowStatisticsPublisher.xml` files instead.

## Starting the profiles
You can now start the WSO2 EI 6.5.0 product. For instructions on starting each of the profiles in the product, see [Running the Product](https://wso2docs.atlassian.net/wiki/spaces/EI650/pages/35553729/Running+the+Product).
