# Upgrading from WSO2 Data Services Server

This page walks you through the process of upgrading to WSO2 Enterprise Integrator (WSO2 EI) 6.6.0 from WSO2 Data Services Server (WSO2 DSS) 3.5.1.

> **Before you begin**
> 
> Note the following:
> 
> - If you are upgrading from a version older than WSO2 DSS 3.5.1, you should first upgrade to WSO2 DSS 3.5.1 and then upgrade to WSO2 EI 6.6.0.
> - For information on what is new in this release and why you should upgrade, see [About this Release](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6520843/About+this+Release).
> - For more information on ports, see [Default Ports of WSO2 Enterprise Integrator](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6522396/Default+Ports+of+WSO2+Enterprise+Integrator).
> - The distribution folder structure has changed from WSO2 DSS 3.5.1 to WSO2 EI 6.6.0.
>  
>  | Data Service Server 3.5.1                     | Enterprise Integrator 6.6.0  |
>  |-----------------------------------------------|------------------------------|
>  | `<DSS_HOME>/repository/conf`                  | `<EI_HOME>/conf`             |
>  | `<DSS_HOME>/repository/conf/axis2`            | `<EI_HOME>/conf/axis2`       |
>  | `<DSS_HOME>/repository/conf/datasources`      | `<EI_HOME>/conf/datasources` |
>  | `<DSS_HOME>/repository/components/dropins`    | `<EI_HOME>/dropins`          |
>  | `<DSS_HOME>/repository/components/extensions` | `<EI_HOME>/extensions`       |
>  | `<DSS_HOME>/repository/components/lib`        | `<EI_HOME>/lib`              |

See the following topics for instructions:

- Preparing to upgrade 
- Upgrading the database 
- Migrating configurations 
- Migrating artifacts 
- Starting the server

## Preparing to upgrade

The following prerequisites must be completed before upgrading:
- Create a backup of the databases in your WSO2 DSS 3.5.1 instance.
- Copy the `<DSS_HOME>` directory to back up the product configurations.
- Download the product installer from [here](https://wso2.com/micro-integrator/), and install WSO2 EI 6.6.0.

  Let's call the installation location of your product the `<EI_HOME>` directory. This is located in a place specific to your OS as shown below:
  
  | OS     | Home directory                                      |
  |--------|-----------------------------------------------------|
  | MacOS  | `/Library/WSO2/EnterpriseIntegrator/6.6.0`          |
  | Ubuntu | `C:\Program Files\WSO2\EnterpriseIntegrator\6.6.0\` |
  | Ubuntu | `/usr/lib/wso2/EnterpriseIntegrator/6.6.0`          |
  | CentOS | `/usr/lib64/EnterpriseIntegrator/6.6.0`             |
  
> **Info**
> 
> The downtime is limited to the time taken for switching databases in the production environment.

## Upgrading the database

In WSO2 EI 6.6.0, you can use the same [database](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6522193/Working+with+Databases) that you used for WSO2 DSS 3.5.1. Therefore, you can simply restore the backup of the existing databases to use with WSO2 EI 6.6.0.

## Migrating configurations

> **Warning**
> 
> Do not copy configuration files directly between servers. Instead, update the files manually.

To migrate all the required folders, files, libraries, etc. from WSO2 DSS 3.5.1 to WSO2 EI 6.6.0:

1. Copy the database connector JAR files stored in the `<DSS_HOME>/repository/components/lib` directory to the `<EI_HOME>/lib` directory.
2. Copy the keystores and truststores from the `<DSS_HOME>/repository/resources/security` directory to the `<EI_HOME>/repository/resources/security` directory in WSO2 EI 6.6.0.
3. If you have secondary user stores created for WSO2 DSS 3.5.1, you need to copy the 'userstore' folder in the `<DSS_HOME>/repository/deployment/server/` directory to the same directory in WSO2 EI 6.6.0.
4. If there are any third-party libraries used with WSO2 DSS 3.5.1 that you want to migrate, copy the relevant libraries to WSO2 EI 6.6.0:
   - If you have used JMS libraries, JDBC libraries, etc., copy the files from `<DSS_HOME>/repository/components/lib` directory to the `<EI_HOME>/lib` directory.
   - If you have used OSGi bundles such as SVN kit etc., copy the contents of `<DSS_HOME>/repository/components/dropins` director y to the `<EI_HOME>/dropins` directory.

To migrate the configuration files from WSO2 DSS 3.5.1 to WSO2 EI 6.6.0:

1. Update the configuration files with information of the migrated keystores and truststores. See [Configuring Keystores in WSO2 products](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6522317/Configuring+Keystores+in+WSO2+Products) for more information.
2. Go to the `<EI_HOME>/conf/datasources` directory and update the Carbon datasource configuration in the master-datasources.xml file with the details of the Carbon database. For instructions, see [Changing the Carbon Database](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6522227/Changing+the+Carbon+Database) and select your database type.
3. Go to the `<EI_HOME>/conf` directory and update the datasource references in the user-mgt.xml and registry.xml files to match the updated configurations in the `master-datasources.xml` file. The instructions are available in [Changing the Carbon Database](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6522227/Changing+the+Carbon+Database).
4. Check for any configurations that were done for WSO2 DSS 3.5.1 based on your solution. For example, update the following configurations in WSO2 EI 6.6.0 accordingly:

   a. `axis2.xml`
   b. `axis2_client.xml`
   c. `carbon.xml`

5. Check the configurations related to external user stores, caching, mounting, transports, etc.

WSO2 EI 6.6.0 is based on Carbon Kernel 4.5.0, which introduces log4j2. Also, the carbon.logging jar is not packed with the EI 6.6.0 distribution and the pax-logging-api is used instead. Follow the instructions given below to migrate from log4j (in WSO2 DSS 3.5.1) to log4j2 (in WSO2 EI 6.6.0).

1. If you have used a custom log4j component in WSO2 DSS 3.5.1, apply the following changes to your component:

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
   
   3. If `commons.logging` is imported using Import-Package add the version range.
   
      ```
      org.apache.commons.logging;
      version="${commons.logging.version.range}"
      <commons.logging.version.range>[1.2.0,2.0.0)</commons.logging.version.range>
      ```

2. Follow the [instructions on configuring log4j2](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6521063/Configuring+Log4j2+Properties) to register the Appenders and Loggers.

## Migrating artifacts

- To migrate the data service artifacts, copy the `<DSS_HOME>/repository/deployment/server/dataservices` directory of WSO2 DSS 3.5.1 to WSO2 EI 6.6.0.
- If you have custom artifacts created in the `<DSS_HOME>/repository/deployment/server/` directory, copy them to the same directory in WSO2 EI 6.6.0.
- If multitenancy is used, copy the tenant directory packages from the `<DSS_HOME>/repository/tenants` directory to the same directory in WSO2 EI 6.6.0.

## Starting the server

Once you have completed the migration, you can start the ESB profile of WSO2 EI. For details see [Running the Product](https://wso2docs.atlassian.net/wiki/spaces/EI660/pages/6520949/Running+the+Product).
