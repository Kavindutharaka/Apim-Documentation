# Upgrading from WSO2 ESB 4.9.0 to 5.0.0

This page walks you through the process of upgrading to ESB 5.0.0 from ESB 4.9.0.

> If you are upgrading from a version older than ESB 4.9.0, you will need to first upgrade to ESB 4.9.0 and then upgrade to ESB 5.0.0.

From WSO2 ESB 5.0.0 onwards, it does not support processing any mediators added after the send mediator in a given sequence because it may lead to erroneous behaviors when the message stream is consumed by the send mediator in passthrough scenarios. Therefore, if you have sequences with mediators after the send mediator, you need to change those sequences to have the send mediator inside a clone mediator, thereby, it will clone the message and process it separately. For example, see below.

```
<clone sequential="true">
    <target>
         <sequence>
              <send>
                   <endpoint key="ABC"/>
               </send>
         </sequence>
     </target>
     <target>
         <sequence>
             <switch xmlns:ns="http://org.apache.synapse/xsd" source="get-property('XYZ')">
                  <case regex="CASE1 ">
                       <log level="custom">
                           <property name="#### CASE ####" value="IN CASE1"/>
                       </log>
                       <sequence key="TEST.PQR "/>
                        <drop/>
                     </case>
                     <default>
                        <log level="custom">
                           <property name="#### DEFAULT ####" value="IN DEFAULT"/>
                        </log>
                        <drop/>
                     </default>
                  </switch>
           </sequence>
     </target>
</clone>
```

The followings steps describe how you can upgrade data and configurations when upgrading from ESB 4.9.0 to ESB 5.0.0. For more information on release versions, see the [Release Matrix](https://wso2.com/products/carbon/release-matrix/).

> You cannot roll back the upgrade process. However, it is possible to restore a backup of the previous database so that you can restart the upgrade progress.

## Preparing to upgrade 

The following prerequisites must be completed before upgrading:

-   Create a backup of the [database](https://docs.wso2.com/display/ADMIN44x/Working+with+Databases) in your ESB instance.
-   Copy the <ESB_HOME> directory to back up the ESB product configurations.
Download ESB 5.0.0 from http://wso2.com/products/enterprise-service-bus/.

> **Note**
>
> The downtime is limited to the time taken for switching databases in the production environment

## Upgrading the database

The instructions in this section describe how you can perform a data migration to upgrade the 4.9.0 database for use in ESB 5.0.0.

> **Note**
>
> Before you upgrade to ESB 5.0.0, create a new database and restore the backup of the ESB 4.9.0 database in this new database.

It is not mandatory that you migrate the user management database when upgrading from ESB 4.9.0 to ESB 5.0.0.

<h3>If you choose to proceed without migrating:</h3>

> Set the following property to true in the `<ESB_5.0.0_HOME>/repository/conf/user-mgt.xml` file as shown below.
>
> `<Property name="isCascadeDeleteEnabled">true</Property>`

<h3>If you choose to migrate:</h3>

1.  Get the WSO2 Identity Server Migration Client provided by the WSO2 team. This client will migrate the user management database schemas that are used by WSO2 ESB. Unzip the downloaded file to the local file system, and you will have a directory named  wso2is-5.1.0-migration . Then do the following:

    >   The user management database is where information about the users and user roles are stored, e.g., login name, password, first name, last name, e-mail address, etc. The user management database of every Carbon based product is handled by a feature that comes with [WSO2 Identity Server](https://wso2.com/identity-server/). Therefore, to migrate the user management database schemas we have to use the WSO2 Identity Server Migration Client.

    1.  Copy the wso2is-5.1.0-migration/dbscripts/migration­-5.0.0_to_5.1.0 directory to the <ESB_5.0.0_HOME>/dbscripts directory.
    2.  Copy the wso2is-5.1.0-migration/dbscripts/identity/migration­-5.0.0SP1_to_5.1.0 directory and the wso2is-5.1.0-migration/dbscripts/identity/migration-5.0.0_to_5.0.0SP1 directory to the <ESB_5.0.0_HOME>/dbscripts/identity directory.
    3.  Copy the wso2is-5.1.0-migration/dropins/org.wso2.carbon.is.migrate.client-­5.1.0.jar file to the <ESB_5.0.0_HOME>/repository/components/dropins directory.

2.  Start WSO2 ESB 5.0.0 using the command line with the options given below in the following order:

    ```
    -Dmigrate -DmigrateUMDB -Dcomponent=identity
    -Dmigrate -DmigrateUMData -Dcomponent=identity
    ```

    >   There is a known issue where an exception is thrown when you run the -Dmigrate -DmigrateUMData -Dcomponent=identity command and this will be fixed soon. However, based on our testing this has no impact on the migration process.

This will carry out the migration of the user management database.

## Migrating the configuration files

> **Note**
>
> Configurations should not be copied directly between servers.

To connect ESB 5.0.0 to the upgraded database, configure the following files:

1.  Go to the <ESB_HOME>/repository/conf/datasources directory and update the master-datasources.xml file. See [Configuring master-datasources.xml](https://docs.wso2.com/display/ESB500/Configuring+master-datasources.xml).
2.  Go to the <ESB_HOME>/repository/conf directory and update the datasource references in the user-mgt.xml and registry.xml files to match the updated configurations in the  master-datasources.xml file that you made in the above step. See [Configuring user-mgt.xml](https://docs.wso2.com/display/ESB500/Configuring+user-mgt.xml) and [Configuring registry.xml](https://docs.wso2.com/display/ESB500/Configuring+registry.xml).

3.  Check for any other configurations that were done for ESB 4.9.0 based on your solution and update the configuration files in ESB 5.0.0 accordingly. For example, configurations related to external user stores, caching, mounting, transports, etc.

    > **Note**
    >
    > The following files have changed from ESB 4.9.0 to ESB 5.0.0:
    >
    > - axis2.xml
    > - axis2_nhttp.xml
    > - axis2_pt.xml
    > - tenant-axis2.xml
    > - cache.xml
    > - config-validation.xml
    > - logging-bridge.properties
    > - osgi-debug.option
    > - cloud-services-desc.xml
    > - authenticators.xml
    > - ciper-tool.properties
    > - catalina-server.xml
    > - carbon.xml
    > - identity.xml
    > - nhttp.properties
    > - passthru-http.properties
    > - synapse.properties
    > - user-mgt.xml

4.  If there are any third-party libraries used with ESB 4.9.0 that you want to migrate, copy the contents of the following directories as applicable from ESB 4.9.0 to ESB 5.0.0: 
    -   If you have used JMS libraries, JDBC libraries, etc., copy the contents of <ESB_HOME>/repository/components/lib
    -   If you have used OSGi bundles such as SVN kit, etc, copy the contents of <ESB_HOME>/repository/components/dropins

## Migrating artifacts

You should manually deploy Composite Application Archive (CAR) files that you have in ESB 4.9.0 to ESB 5.0.0. If you have a mediator packed in a CAR, all the artifacts using that mediator should also be included in the same CAR. See [Deploying Composite Applications](https://docs.wso2.com/display/ADMIN44x/Deploying+Composite+Applications+in+the+Server) in the Server in WSO2 Admin Guide for further details.

> **Note**
>
> To migrate deployment artifacts including ESB message flow configurations.
>
> -   Copy the required Synapse artifacts from the <ESB_HOME>/repository/deployment/server directory of ESB 4.9.0 to ESB 5.0.0. If you do not have axis2 modules or axis2 services, you can copy the required Synapse artifacts from the <ESB_HOME>/repository/deployment/server/synapse-configs/default directory of ESB 4.9.0 to ESB 5.0.0.
>> - If you have used the [Script mediator](https://docs.wso2.com/display/ESB500/Script+Mediator) within your synapse configuration with the setProperty() method, you will need to modify the configuration as described [here](https://docs.wso2.com/display/ESB500/Script+Mediator#ScriptMediator-setProperty).
>> - Ensure that there are no mediator configurations after [Send mediator](https://docs.wso2.com/display/ESB500/Send+Mediator) in the same sequence, because WSO2 ESB does not process them. Any mediator configuration after the Send mediator should go to the outSequence or receive sequence.
>
> - If multi-tenancy is used, copy the <ESB_HOME>/repository/tenants directory from ESB 4.9.0 to ESB 5.0.0.

> **Warning**
>
> The org.wso2.caching.digest.REQUESTHASHGenerator interface, which is supported by WSO2 ESB 4.9.0 is not supported by later versions. Therefore, change the artifacts to use the org.wso2.carbon.mediator.cache.digest.DOMHASHGenerator as the hash generator when migrating artifacts related to the Cache mediator from WSO2 ESB 4.9.0 to a later version.

> **Warning**
>
> Prior to copying the above folders, remove all secured services from the folder.
>
> With the removal of QoS features from the ESB management console, enabling security for services hosted in ESB has changed from ESB 4.9.0 onwards. You now need to secure your services using [ESB Tooling](https://docs.wso2.com/display/ESB500/WSO2+ESB+Tooling) before you can migrate them to ESB 5.0.0. 
>
> See [Applying Security to a Proxy Service](https://docs.wso2.com/display/ESB500/Applying+Security+to+a+Proxy+Service) for instructions on how to create secured services and deploy them in ESB.

## Testing the upgrade

Verify that all the required scenarios are working as expected in ESB 5.0.0. This confirms that the upgrade is successful.