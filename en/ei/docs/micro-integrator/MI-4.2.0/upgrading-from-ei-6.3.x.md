# Migrating from WSO2 EI 6.3.x to WSO2 API-M 4.2.0

This guide provides the recommended strategy for upgrading from the ESB profile of WSO2 EI 6.3.0 to the Micro Integrator of WSO2 API-M 4.2.0.

## Why upgrade to WSO2 API-M 4.2.0?

Listed below are some of the advantages of moving to API-M 4.2.0 from the ESB.

-	The Micro Integrator of API-M 4.2.0 is now the most improved version of the battle-tested WSO2 ESB runtime.

	> **Tip**
	>
	>	WSO2 ESB 5.0, the ESB profile of WSO2 EI 6.x, the Micro Integrator of WSO2 EI 7.x, as well as the Micro Integrator of WSO2 API-M 4.0.0 and WSO2 API-M 4.2.0 contains the same version of WSO2 ESB runtime. 

-	All the ESB runtimes of WSO2 can use the same developer tool ([WSO2 Integration Studio](https://apim.docs.wso2.com/en/4.2.0/integrate/develop/wso2-integration-studio)) for developing integrations. 

-	All the integration capabilities that you used in the ESB can be used in the Micro Integrator with minimal changes.

-	The Micro Integrator contains improvements to ease your product experience.

	> **Note**
	>
	>	The [Toml-based configuration strategy](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi) in API-M 4.2.0 replaces the XML configurations in previous versions of the ESB runtime. Some of the features are [removed from WSO2 Micro Integrator](https://apim.docs.wso2.com/en/4.2.0/get-started/about-this-release/#compare-this-release-with-previous-esbs) as they are not frequently used.  

Upgrading to WSO2 API-M 4.2.0 is recommended for the following requirements:

-	You need to expose integrations as managed APIs so that integration solutions can be managed and monetized in an API marketplace. 
-	You need to switch to a microservices architecture from the conventional centralized architecture.
-	You need a more lightweight, user-friendly version of the battle-tested WSO2 ESB.
-	You need a more lightweight, container-friendly runtime in a centralized architecture.
-	You need native support for Kubernetes.


## Before you begin

Note the following:

-	Ports are different in the Micro Integrator of API-M 4.2.0. Find out about [ports in the Micro Integrator](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/reference/default-product-ports/#micro-integrator-ports).
-	The Micro Integrator of API-M 4.2.0 contains changes that impact your migration process. Be sure to read the [Comparison: ESB vs the Micro Integrator](https://apim.docs.wso2.com/en/4.2.0/get-started/about-this-release/#compare-this-release-with-previous-esbs) before you start the migration.

-	Note that API-M 4.2.0 does not allow manual patches. You can use [WSO2 Updates](https://updates.docs.wso2.com/en/latest/updates/overview) to get the latest fixes or updates for this release.
-	The BPS profile does not exist in the latest version of MI and we recommend that you use an alternate product for complex long running processes they are running on BPS. Alternately, you can continue to use BPS until it reaches end-of-life.

## Migrating to the Micro Integrator

Follow the instructions below to start the migration!

### Setting up

-   Make a backup of the EI 6.3.0 distribution (`<EI_HOME>` folder) to back up the product configurations.
-   Make a backup of the database used by the current EI 6.3.0 deployment. This backup is necessary in case the migration causes any issues in the existing database.
-   [Download and install](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/install/installing-the-product/installing-mi) the latest Micro Integrator in your environment:

    > **Tip**
    >
    >    The home directory of your Micro Integrator will be referred to as `<MI_HOME>` from hereon.

-   Use [WSO2 Updates](https://updates.docs.wso2.com/en/latest/updates/overview/) to get the latest available updates for your Micro Integrator distribution.

    > **Info**
    >
    >    Note that you need a valid [WSO2 subscription](https://wso2.com/subscription) to use updates in a production environment.

### Migrating the user store

> **Before you begin**
>
>    Read about [users and roles in the Micro Integrator](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/mi-setup/user_stores/managing_users) and about how they function. Note the following important facts:
>
>    - Users in the Micro Intgrator are categorized as <b>admin</b> users and <b>non-admin</b> users.
>    - All admin users in your existing EI 6.3.0 user store will function as admin users in the Micro integrator.
>    - Tenant admins are no longer valid because the Micro Integrator does not support multitenancy.
>    - **Secondary** user stores are currently not supported in the Micro Integrator.

If you are using an **LDAP user store** with EI 6.2.0, you can simply connect the same to the Micro Integrator of API-M 4.2.0 by updating the configuration details in the Micro Integrator's `deployment.toml` file. 

If you are using a **JDBC user store** with EI 6.2.0, you need to first update the database before connecting the same to APIM 4.2.0.

Follow the steps given below.

#### Step 1 - Update the database structure

This step is applicable only if your user store is JDBC. 

There are changes in the database structure (schema) that is used in EI 6.3.0. To update the database schema:

1. Contact WSO2 Support to obtain the database migration scripts.

2. Unzip the file and select the script relevant to your database type.

3. Connect to the database and run the script.

Your database schema is now updated for APIM 4.2.0. Now you can update the configuration details in the Micro Integrator's `deployment.toml` file.

#### Step 2 - Connect to the user store

To connect the Micro Integrator to the primary user store:

1. Open the `deployment.toml` file of your Micro Integrator.

2. Note that you have the `[user_store]` section enabled by default.

    ```toml
    [user_store]
    type = "read_only_ldap"
    ```

3. See the instructions in the following sections:

    -   [Configuring an LDAP user store](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/mi-setup/user_stores/setting_up_a_userstore/#configuring-an-ldap-user-store) for the Micro Integrator in API-M 4.2.0.

    -   [Configuring an RDBMS user store](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/mi-setup/user_stores/setting_up_a_userstore/#configuring-an-rdbms-user-store) for the Micro Integrator in API-M 4.2.0.  

4. If your user store is an RDBMS, be sure to add the client JAR of your RDBMS to the `<MI_HOME>/lib` folder.

5. If your user store is an LDAP server, migrate the Carbon datasource as well. The Carbon datasource contains the hybrid roles and role allocation details for the LDAP.

    ```toml
    [user_store]
    connection_url = "ldap://localhost:10389"  
    connection_name = "uid=admin,ou=system"
    connection_password = "admin"  
    user_search_base = "ou=Users,dc=wso2,dc=org"
    type = "read_write_ldap"
    read_groups = true

    [[datasource]]
    id = "WSO2CarbonDB"
    url= "jdbc:mysql://localhost:3306/primaryDB"
    username="root"
    password="root"
    driver="com.mysql.jdbc.Driver"
    pool_options.maxActive=50
    pool_options.maxWait = 60000
    pool_options.testOnBorrow = true
    ```

See the instructions on [configuring a user store](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/mi-setup/user_stores/setting_up_a_userstore) for more information.

### Migrating secondary user stores

> **Before you begin**
>
>    - Users in the Micro Integrator are categorized as <b>admin</b> users and <b>non-admin</b> users.
>    - All the users added from secondary user stores are <b>non-admin</b> users.

To deploy secondary user stores in Micro Integrator

1. A primary user store should be configured. Refer
   [configuring an LDAP user store](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/mi-setup/user_stores/setting_up_a_userstore/#configuring-an-ldap-user-store)
2. User-core feature should be enabled (disabled by default).

To enable the user-core feature, change the following entry to **false** in micro-integrator.sh/micro-integrator.bat files as required.

```bash
-DNonUserCoreMode=true \
```

#### Step 1 - Update user store XML files

1. Locate existing user store definitions in `<EI_HOME>/repository/deployment/server/userstores` directory

2. Apply the following class name changes if applicable.

<table>
   <tr>
      <th>Old class</th>
      <th>New Class</th>
   </tr>
   <tr>
      <td>org.wso2.carbon.user.core.ldap.ReadWriteLDAPUserStoreManager</td>
      <td>
         org.wso2.micro.integrator.security.user.core.ldap.ReadWriteLDAPUserStoreManager
      </td>
   </tr>
   <tr>
      <td>org.wso2.carbon.user.core.jdbc.JDBCUserStoreManager</td>
      <td>
         org.wso2.micro.integrator.security.user.core.jdbc.JDBCUserStoreManager
      </td>
   </tr>
   <tr>
      <td>org.wso2.carbon.user.core.ldap.ReadOnlyLDAPUserStoreManager</td>
      <td>
         org.wso2.micro.integrator.security.user.core.ldap.ReadOnlyLDAPUserStoreManager
      </td>
   </tr>
   <tr>
       <td>org.wso2.carbon.user.core.ldap.ActiveDirectoryUserStoreManager</td>
       <td>
           org.wso2.micro.integrator.security.user.core.ldap.ActiveDirectoryUserStoreManager
       </td>
   </tr>
</table>

#### Step 2 - Deploying user stores in Micro Integrator

1. Create a new `userstores` directory in `<MI_HOME>/repository/deployment/server/` location.

2. Move all the modified user store xml files in step 1 to the above directory.

### Migrating the registry

### Migrating the registry

> **Info**
>
> **Before you begin**
>
> Note the following:
>
>	-	The Micro Integrator uses a [file-based registry](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/mi-setup/deployment/file_based_registry) instead of a database (which is used in your WSO2 EI version). 
>	-	Your WSO2 EI registry may have the following partitions: <b>Local</b>, <b>Config</b>, and <b>Gov</b>. However, you only need to migrate the <b>Config</b> and <b>Gov</b> registry partitions. See the instructions on configuring [registry partitions in the Micro Integrator](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/mi-setup/deployment/file_based_registry).
>	-	Message processor tasks stored in the registry should be stored with a new naming convention in the Micro Integrator. Therefore, all entries in the registry with the `MSMP` prefix (which correspond to message processor tasks) should not be migrated to the Micro Integrator. New entries will be automatically created when you start the Micro Integrator server.
>	-	If you have shared the registry of your WSO2 EI among multiple nodes, you can do the same for the file-based registry of the Micro Integrator. However, note that registry mounting/sharing is only required for [**persisting message processor states** among nodes of the Micro Integrator](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/mi-setup/deployment/deploying_wso2_ei/#registry-synchronization-sharing).
	
	
You can migrate the registry resources by using the **registry migration tool** as follows:

1. Save the tool (`registry-migration-service-1.0.0.jar`), which was provided by WSO2 Support, to a location on your computer.

2. Execute one of the commands given below to start the tool.

	-	To start the tool without a log file:

		```bash
		java -jar <path_to_jar>/registry-migration-service-1.0.0.jar
		```

	-	To start the tool with a log file:

		> **Tip**
		>
		>	Replace `<log_file_location>` with the location where you want the log file to be created.
		>
		```bash
		java -Dlog.file.location=<log_file_location> -jar <path_to_jar>/registry-migration-service-1.0.0.jar
		```

3. Specify the following input values to log in to your WSO2 EI server from the migration tool:

	<table>
		<tr>
			<th>
				Input Value
			</th>
			<th>
				Description
			</th>
		</tr>
		<tr>
			<td>
				EI Server URL 
			</td>
			<td>
				Specify the EI server URL with the servlet port. The default is <code>https://localhost:9443</code>.
			</td>
		</tr>
		<tr>
			<td>
				Internal Truststore Location of the EI Server
			</td>
			<td>
				Specify the location of the internal truststore used by the EI server.
			</td>
		</tr>
		<tr>
			<td>
				Internal Truststore Type of EI Server
			</td>
			<td>
				Specify the type of the internal Truststore used by the EI server. The default is <code>JKS</code>.
			</td>
		</tr>
		<tr>
			<td>
				Internal Truststore Password of EI Server
			</td>
			<td>
				Specify the password of the internal Truststore used by the EI server. The default is <code>wso2carbon</code>.
			</td>
		</tr>
		<tr>
			<td>
				Username of the EI Server
			</td>
			<td>
				<code>admin</code>.
			</td>
		</tr>
		<tr>
			<td>
				Password of the EI Server
			</td>
			<td>
				<code>admin</code>.
			</td>
		</tr>
	</table>

4.	Select one of the following options and proceed.

	<table>
		<tr>
			<th>
				Option
			</th>
			<th>
				Description
			</th>
		</tr>
		<tr>
			<td>
				Export as a Registry Resource Module
			</td>
			<td>
				<b>Recommended</b>. If you select this option, the registry resources are exported as a Registry Resources module, which you import to WSO2 Integration Studio. You can then create a CAR file by selecting resources from the registry resources module.
			</td>
		</tr>
		<tr>
			<td>
				Export as a Carbon Application
			</td>
			<td>
				If you select this option, the registry resources in your WSO2 EI instance are exported as a single CAR file, which you directly copy to your Micro Integrator distribution.
			</td>
		</tr>
	</table>

5.	Specify input values depending on which export option you selected.

	-	If you selected **Export as a Registry Resource Module**, follow the steps given below.

		1. Enter the following input values:

			<table>
				<tr>
					<th>
						Input Value
					</th>
					<th>
						Description
					</th>
				</tr>
				<tr>
					<td>
						Integration Project Name
					</td>
					<td>
						Specify the name of the Integration project.
					</td>
				</tr>
				<tr>
					<td>
						Project’s Group ID
					</td>
					<td>
						Specify the group ID of the integration project. The default value is <code>com.example</code>.
					</td>
				</tr>
				<tr>
					<td>
						Project’s Artifact ID
					</td>
					<td>
						Specify the artifact ID of the integration project. The default value is the integration project name.
					</td>
				</tr>
				<tr>
					<td>
						Project Version
					</td>
					<td>
						Specify the version of the integration project. The default value is <code>1.0.0</code>.
					</td>
				</tr>
				<tr>
					<td>
						Export Location
					</td>
					<td>
						Specify the location where the integration project should be created.
					</td>
				</tr>
			</table>

		2.	Verify the following:

			-	If the process is successful, the **Registry Resource Project** is created in the location you specified. 
			-	A summary report is created at the export location with file name: `registry_export_summary_<date>.txt`. This report explains whether the registry resource is successfully exported and also provides reasons in case the exprot fails.

		3. [Import the Registry Resource Project](https://apim.docs.wso2.com/en/4.2.0/integrate/develop/creating-artifacts/creating-registry-resources/#import-from-file-system) to the Registry Resources module in WSO2 Integration Studio.

		4.	Open the resource editor and make sure that the <b>media type</b> of the resource is set properly.
			
			![Registry Resource Editor](https://apim.docs.wso2.com/en/4.2.0/assets/img/integrate/migration/registry-resource-editor.png)

		5. Select the required resources from your registry resources project and export a CAR file.

	-	If you selected **Export as a Carbon Application**, enter the following input values:

		<table>
			<tr>
				<th>
					Input Value
				</th>
				<th>
					Description
				</th>
			</tr>
			<tr>
				<td>
					CAR File Name
				</td>
				<td>
					Specify the name of the Carbon application.
				</td>
			</tr>
			<tr>
				<td>
					CAR File Version
				</td>
				<td>
					Specify the version of the Carbon application. The default value is <code>1.0.0</code>.
				</td>
			</tr>
			<tr>
				<td>
					Export Location
				</td>
				<td>
					Specify the location where the CAR file should be created.
				</td>
			</tr>
		</table>

	You should now have a CAR file with the required registry resources.

6.	Copy the CAR file to the `<MI_HOME>/repository/deployment/server/carbonapps` folder.

### Migrating integration artifacts

> **Before you begin**
>
>    Note that the following changes are effective from EI 6.4.0 onwards. Therefore, if you are migrating from an EI version older than EI 6.4.0, you need to apply these changes to the artifacts before the migration.
>
>    -   If you have used the `$ctx` function inline (in the Payload Factory mediator) to get property values, you need to change this to the full XPath. The `$ctx` function or the `get-property()` function can be used inside the argument (args) tags to get property values.
>
>    -   The XSLT mediator writes response messages to the JSON stream. In ESB versions prior to EI 6.4.0, the XSLT mediator was not doing any changes to the JSON stream after message transformation.
>
>    -   There are validations affecting the <b>Enrich</b> mediator, which prevents the source and target in the message body.
>
>    -   If you have specified an XPath value in your mediation sequence, the response message generated by the ESB will include the element tags of your XPath value. For example, if your XPath value is "//faultdescription", the response message will be `<faultdescription>DESCRIPTION</faultdescription>`. If you want the response message to contain only the DESCRIPTION, you need to specify the XPath value as "//faultdescription/text()".
>
>    -   If you are using the MailTo transport to send emails through a mediation sequence, note that the email sender specified in the mediation sequence overrides the email sender configured in the Micro Integrator configurations.

The recommended way to create integration artifacts is to use [WSO2 Integration Studio](https://apim.docs.wso2.com/en/4.2.0/integrate/develop/wso2-integration-studio):

- If the artifacts are created in the recommended way, copy the CAR files inside `<EI_HOME>/repository/deployment/server/carbonapps` to the `<MI_HOME>/repository/deployment/server/carbonapps` folder.

    > **Changed package names**
    >
    >    Note that some of the class names of packages used inside your integration artifacts have changed in the Micro Integrator. 
    >
    >    For example, if you have used a <b>Token Store</b> when [applying security policy to a proxy service](https://apim.docs.wso2.com/en/4.2.0/integrate/develop/advanced-development/applying-security-to-a-proxy-service) in the ESB, the token store class has changed from `org.wso2.carbon.security.util.SecurityTokenStore` to `org.wso2.micro.integrator.security.extensions.SecurityTokenStore` in the Micro Integrator. 
    >
    >    Therefore, these artifacts have to be updated with the correct class name and packaged into a new CAR file before migration.

- If you have a custom mediator packed in a CAR, do one of the following:

    - Include all the artifacts (using that mediator) in the same CAR.

    - Alternatively, you can add the JAR of the mediator to the `<MI_HOME>/lib/dropins` folder so that it can be shared by artifacts in multiple CARs.

- If the artifacts are created using the management console of EI 6.3.0, you need to recreate them using WSO2 Integration Studio and package them as a composite application. See the instructions on [packaging artifacts](https://apim.docs.wso2.com/en/4.2.0/integrate/develop/packaging-artifacts).

> **Tip**
>
> For testing purposes, you can copy the artifacts to the same folder structure inside the `<MI_HOME>/repository/deployment/server/synapse-configs/default` directory.

### Migrating deployed Connectors

- If the connector is added to EI 6.3.0 via a composite application with the [Connector Exporter Project](https://apim.docs.wso2.com/en/4.2.0/integrate/develop/creating-artifacts/adding-connectors), the same can be used in the Micro Integrator seamlessly. Simply copy the CAR file in EI 6.3.0 to the `<MI_HOME>/repository/deployment/server/carbonapps` folder.

- If the connector is added to EI 6.3.0 via the management console, pack them using the [Connector Exporter Project](https://apim.docs.wso2.com/en/4.2.0/integrate/develop/creating-artifacts/adding-connectors) and deploy via a composite application in the Micro Integrator.

### Migrating custom components

Copy custom OSGI components in the `<EI_HOME>/dropins` folder to the `<MI_HOME>/dropins` folder. If you have custom JARs in the `<EI_HOME>/lib` directory, copy those components to the `<MI_HOME>/lib` folder.

> **Note**
>
>    -   To provide seamless integration with RabbitMQ, the Rabbitmq client lib is included in the Micro Integrator by default. Hence, you don't need to manually add any RabbitMQ components.
>
>    -   The Micro Integrator no longer contains the VFS/SMB provider by default. If you need to use the <b>VFS SMB</b> feature, download `jcifs-1.3.17.jar` and add it to the `<MI_HOME/lib` folder. Since this library is licensed under LGPL version 2.1, you have to comply with the [terms of LGPL version 2.1](https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html) and its restrictions.
>
>    -   If you used an <b>HL7 Message Store</b> (custom message store) implementation, note that the Micro Integrator does not support this functionality. See the list of [removed features](https://apim.docs.wso2.com/en/4.2.0/get-started/about-this-release/#features-removed) for details.

### Migrating tenants

Multitenancy within one JVM is not supported in the Micro Integrator. Therefore, if you used multiple tenants in your EI 6.3.0 deployment, you can replicate the setup by using separate Micro Integrator nodes.

### Migrating keystores
Copy the JKS files from the `<EI_HOME>/repository/resources/security` folder to the `<MI_HOME>/repository/resources/security` folder.

### Migrating configurations

> **Before you begin**
>
>    Note the following:
>
>    -   Configuration management was handled in EI 6.3.0 via multiple files such as `carbon.xml`, `synapse.properties`, and `axis2.xml`.
>    -   The Micro Integrator uses a new configuration model where most of the product configurations are managed by a single configuration file named `deployment.toml` (stored in the `<MI_HOME>/conf` directory).
>    -   Log configurations are managed with log4j2, which are configured in the `log4j2.properties` file. Prior to EI 6.6.0, all ESB versions use log4j instead of log4j2.
>    - Some mediators like In and Out Mediator have been deprecated and removed from more recent versions of the product.

The following sections of this document will guide you to migrate the product configurations including log4j.

#### Migrating to TOML configurations

> **Tip**
>
> If you have a [WSO2 subscription](https://wso2.com/subscription), it is highly recommended to contact WSO2 Support before attempting to proceed with the configuration migration.

Given below are the main configurations that have changed in the Micro integrator. Expand the sections to find the TOML configurations corresponding to the XML configurations.

**Clustering configurations**

In the Micro Integrator, you don't need to enable clustering as you did with previous EI versions. Instead, you need to configure all nodes in the cluster to coordinate through an RDBMS. Find out more about [cluster coordination](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/mi-setup/deployment/deploying_wso2_ei/#cluster-coordination).

```xml tab='XML configuration'
    <clustering class="org.wso2.carbon.core.clustering.hazelcast.HazelcastClusteringAgent"
                    enable="true">
    <parameter name="clusteringPattern">nonWorkerManager</parameter>
    </clustering>
```

```toml tab='TOML configuration'
    # Cluster coordination database connection.
    [[datasource]]
    id = "WSO2_COORDINATION_DB"
    url= "jdbc:mysql://localhost:3306/clusterdb"
    username="root"
    password="root"
    driver="com.mysql.jdbc.Driver"

    # Identifying nodes in the cluster.
    [cluster_config]
    node_id = "node-1"
```

Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/mi-setup/deployment/deploying_wso2_ei).

**Analytics configurations**

If you used EI Analytics with your ESB profile, you have configured the following to be able to publish statistics to the Analytics server.

-   `<EI_HOME>/repository/deployment/server/eventpublishers/MessageFlowConfigurationPublisher.xml`

-   `<EI_HOME>/repository/deployment/server/eventpublishers/MessageFlowStatisticsPublisher.xml`

If you are using EI Analytics with your new Micro Integrator solution, you can follow the instructions in [Setting up the EI Analytics Profile for Observability](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/mi-setup/observability/setting-up-classic-observability-deployment).

Given below are some of the most critical XML configuration files in the ESB profile of EI 6.3.0. Expand each section to find the TOML configurations corresponding to the XML configurations in the file.

**carbon.xml**

-   Hostname

    ```xml tab='XML configuration'
        <HostName>www.wso2.org</HostName>
    ```

    ```toml tab='TOML configuration'
        [server]
        hostname = "www.wso2.org"
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#deployment).

-   Port offset

    ```xml tab='XML configuration'
        <Ports>
            <Offset>1</Offset>
        </Ports>
    ```

    ```toml tab='TOML configuration'
        [server]
        offset  = 0
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#deployment).


-   Primary keystore

    ```xml tab='XML configuration'
        <Security>
            <KeyStore>            
                <Location>${carbon.home}/repository/resources/security/wso2carbon.jks</Location>
                <Type>JKS</Type>
                <Password>wso2carbon</Password>
                <KeyAlias>wso2carbon</KeyAlias>
                <KeyPassword>wso2carbon</KeyPassword>
            </KeyStore>
        </Security>
    ```

    ```toml tab='TOML configuration'
        [keystore.primary]
        file_name = "wso2carbon.jks"
        type = "JKS"
        password = "wso2carbon"
        alias = "wso2carbon"
        key_password = "wso2carbon"
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#primary-keystore).

-   Internal keystore

    ```xml tab='XML configuration'
        <InternalKeyStore>
             <Location>${carbon.home}/repository/resources/security/wso2carbon.jks</Location>
                <Type>JKS</Type>
                <Password>wso2carbon</Password>
                <KeyAlias>wso2carbon</KeyAlias>
               <KeyPassword>wso2carbon</KeyPassword>
        </InternalKeyStore>
    ```

    ```toml tab='TOML configuration'
        [keystore.internal]
        file_name = "wso2carbon.jks"
        type = "JKS"
        password = "wso2carbon"
        alias = "wso2carbon"
        key_password = "wso2carbon"
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#internal-keystore).

-   Truststore

    ```xml tab='XML configuration'
        <TrustStore>
            <Location>${carbon.home}/repository/resources/security/client-truststore.jks</Location>
            <Type>JKS</Type>
            <Password>wso2carbon</Password>
        </TrustStore>
    ```

    ```toml tab='TOML configuration'
        [truststore]
        file_name = "client-truststore.jks"  
        type = "JKS"                        
        password = "wso2carbon"            
        alias = "symmetric.key.value"      
        algorithm = "AES"
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#trust-store).


**user-mgt.xml**

-   Admin user

    ```xml tab='XML configuration'
        <Realm>
            <Configuration>
                <AdminRole>admin</AdminRole>
                <AdminUser>                
                    <UserName>admin</UserName>                
                    <Password>admin</Password>
                </AdminUser>
            </Configuration>
        </Realm>
    ```

    ```toml tab='TOML configuration'
        [super_admin]
        username = "admin"              # inferred
        password = "admin"              # inferred
        admin_role = "admin"            # inferred
    ```

-   User datasource

    ```xml tab='XML configuration'
        <Realm>
            <Configuration>
                 <Property name="isCascadeDeleteEnabled">true</Property>
                 <Property name="dataSource">jdbc/WSO2CarbonDB</Property>
            </Configuration>
        </Realm>
    ```

    ```toml tab='TOML configuration'
        [realm_manager]
        data_source = "WSO2CarbonDB"       
        properties.isCascadeDeleteEnabled = true   
    ```

-   LDAP userstore

    ```xml tab='XML configuration'
        <UserStoreManager class="org.wso2.carbon.user.core.ldap.ReadOnlyLDAPUserStoreManager">
            <Property name="TenantManager">org.wso2.carbon.user.core.tenant.CommonHybridLDAPTenantManager</Property>
            <Property name="ConnectionURL">ldap://localhost:10389</Property>
            <Property name="ConnectionName">uid=admin,ou=system</Property>
        </UserStoreManager>
    ```

    ```toml tab='TOML configuration'
        [internal_apis.file_user_store]
        enable = false

        [user_store]
        type = "read_only_ldap" # inferred default read_only_ldap # OR  read_write_ldap
        class = "org.wso2.micro.integrator.security.user.core.ldap.ReadOnlyLDAPUserStoreManager" # inferred
        connection_url = "ldap://localhost:10389"   #inferred
        connection_name = "uid=admin,ou=system"   #inferred
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#ldap-user-store).

-   JDBC userstore

    ```xml tab='XML configuration'
         <UserStoreManager class="org.wso2.carbon.user.core.jdbc.JDBCUserStoreManager">
            <Property name="TenantManager">org.wso2.carbon.user.core.tenant.JDBCTenantManager</Property>
         </UserStoreManager>
    ```

    ```toml tab='TOML configuration'
        [internal_apis.file_user_store]
        enable = false

        [user_store]
        class = "org.wso2.micro.integrator.security.user.core.jdbc.JDBCUserStoreManager"
        type = "database"
    ```

**master-datasource.xml**

Carbon database (`WSO2_CARBON_DB`).

```xml tab='XML configuration'
    <datasource>
        <name>WSO2_CARBON_DB</name>
        <description>The datasource used for registry and user manager</description>
        <jndiConfig>
            <name>jdbc/WSO2CarbonDB</name>
        </jndiConfig>
        <definition type="RDBMS">
            <configuration>
                <url>jdbc:h2:./repository/database/WSO2CARBON_DB;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=60000</url>
                <username>wso2carbon</username>
                <password>wso2carbon</password>
                <driverClassName>org.h2.Driver</driverClassName>
                <maxActive>50</maxActive>
                <maxWait>60000</maxWait>
                <testOnBorrow>true</testOnBorrow>
            </configuration>
        </definition>
    </datasource>
```

```toml tab='TOML configuration'
    [[datasource]]
    id = "WSO2_CARBON_DB"
    url= "jdbc:h2:./repository/database/WSO2CARBON_DB;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=60000"
    username="username"
    password="password"
    driver="org.h2.Driver"
    pool_options.maxActive=50
    pool_options.maxWait = 60000 # wait in milliseconds
    pool_options.testOnBorrow = true
```

Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#database-connection).


**axis2.xml**

-   Hot deployment

    ```xml tab='XML configuration'
        <parameter name="hotdeployment" locked="false">true</parameter>
    ```

    ```toml tab='TOML configuration'
        [server]
        hot_deployment = true
    ```

-   Enable MTOM

    ```xml tab='XML configuration'
        <parameter name="enableMTOM" locked="false">false</parameter>
    ```

    ```toml tab='TOML configuration'
        [server]
        enable_mtom = false
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#deployment).

-   Enable SWA

    ```xml tab='XML configuration'
        <parameter name="enableSwA" locked="false">false</parameter>
    ```

    ```toml tab='TOML configuration'
        [server]
        enable_swa = false
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#deployment).

-   Message formatters

    ```xml tab='XML configuration'
        <messageFormatters>
                <messageFormatter contentType="application/x-www-form-urlencoded"
                                  class="org.apache.synapse.commons.formatters.XFormURLEncodedFormatter"/>
                <messageFormatter contentType="multipart/form-data"
                                  class="org.apache.axis2.transport.http.MultipartFormDataFormatter"/>
                <messageFormatter contentType="application/xml"
                                  class="org.apache.axis2.transport.http.ApplicationXMLFormatter"/>
                <messageFormatter contentType="text/xml"
                                 class="org.apache.axis2.transport.http.SOAPMessageFormatter"/>
                <messageFormatter contentType="application/soap+xml"
                                 class="org.apache.axis2.transport.http.SOAPMessageFormatter"/>
                <messageFormatter contentType="text/plain"
                                 class="org.apache.axis2.format.PlainTextFormatter"/>
                <messageFormatter contentType="application/octet-stream"
                                  class="org.wso2.carbon.relay.ExpandingMessageFormatter"/>
                <messageFormatter contentType="application/json"
                                  class="org.wso2.carbon.integrator.core.json.JsonStreamFormatter"/>
        </messageFormatters>                         
    ```

    ```toml tab='TOML configuration'
        [message_formatters]
        form_urlencoded =  "org.apache.synapse.commons.formatters.XFormURLEncodedFormatter"
        multipart_form_data =  "org.apache.axis2.transport.http.MultipartFormDataFormatter"
        application_xml = "org.apache.axis2.transport.http.ApplicationXMLFormatter"
        text_xml = "org.apache.axis2.transport.http.SOAPMessageFormatter"
        soap_xml = "org.apache.axis2.transport.http.SOAPMessageFormatter"
        text_plain = "org.apache.axis2.format.PlainTextFormatter"
        application_json =  "org.wso2.micro.integrator.core.json.JsonStreamFormatter"
        octet_stream = "org.wso2.carbon.relay.ExpandingMessageFormatter"

        # Custom message formatters.
        [[custom_message_formatters]]
        content_type = "application/json/badgerfish"
        class = "org.apache.axis2.json.JSONBadgerfishMessageFormatter"
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#message-formatters-non-blocking-mode).

-   Message builders

    ```xml tab='XML configuration'
        <messageBuilders>
                <messageBuilder contentType="application/xml"
                                class="org.apache.axis2.builder.ApplicationXMLBuilder"/>
                <messageBuilder contentType="application/x-www-form-urlencoded"
                                class="org.apache.synapse.commons.builders.XFormURLEncodedBuilder"/>
                <messageBuilder contentType="multipart/form-data"
                                class="org.apache.axis2.builder.MultipartFormDataBuilder"/>
                <messageBuilder contentType="text/plain"
                                class="org.apache.axis2.format.PlainTextBuilder"/>
                <messageBuilder contentType="application/octet-stream"
                                class="org.wso2.carbon.relay.BinaryRelayBuilder"/>
                <messageBuilder contentType="application/json"
                                class="org.wso2.carbon.integrator.core.json.JsonStreamBuilder"/>
        </messageBuilders>                                               
    ```

    ```toml tab='TOML configuration'
        [message_builders]
        application_xml = "org.apache.axis2.builder.ApplicationXMLBuilder"
        form_urlencoded = "org.apache.synapse.commons.builders.XFormURLEncodedBuilder"
        multipart_form_data = "org.apache.axis2.builder.MultipartFormDataBuilder"
        text_plain = "org.apache.axis2.format.PlainTextBuilder"
        application_json = "org.wso2.micro.integrator.core.json.JsonStreamBuilder"
        octet_stream =  "org.wso2.carbon.relay.BinaryRelayBuilder"

        # Custom message builders
        [[custom_message_builders]]
        content_type = "application/json/badgerfish"
        class = "org.apache.axis2.json.JSONBadgerfishOMBuilder"
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#message-builders-non-blocking-mode).

-   HTTP transport receiver

    ```xml tab='XML configuration'
        <transportReceiver name="http" class="org.apache.synapse.transport.passthru.PassThroughHttpListener">
                <parameter name="port" locked="false">8280</parameter>
                <parameter name="non-blocking" locked="false">true</parameter>
                <parameter name="bind-address" locked="false">hostname or IP address</parameter>
                <parameter name="WSDLEPRPrefix" locked="false">https://apachehost:port/somepath</parameter>      
        </transportReceiver>                                             
    ```

    ```toml tab='TOML configuration'
        [transport.http]
        listener.enable = true                     
        listener.port = 8280    
        listener.wsdl_epr_prefix ="https://apachehost:port/somepath"
        listener.bind_address = "hostname or IP address"
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#https-transport-non-blocking-mode).

-   HTTPS transport receiver

    ```xml tab='XML configuration'
        <transportReceiver name="https" class="org.apache.synapse.transport.passthru.PassThroughHttpSSLListener">
            <parameter name="port" locked="false">8243</parameter>
            <parameter name="non-blocking" locked="false">true</parameter>
            <parameter name="HttpsProtocols">TLSv1,TLSv1.1,TLSv1.2</parameter>
            <parameter name="bind-address" locked="false">hostname or IP address</parameter>
            <parameter name="WSDLEPRPrefix" locked="false">https://apachehost:port/somepath</parameter>
            <parameter name="keystore" locked="false">
                <KeyStore>
                    <Location>repository/resources/security/wso2carbon.jks</Location>
                    <Type>JKS</Type>
                    <Password>wso2carbon</Password>
                    <KeyPassword>wso2carbon</KeyPassword>
                </KeyStore>
            </parameter>
            <parameter name="truststore" locked="false">
                <TrustStore>
                    <Location>repository/resources/security/client-truststore.jks</Location>
                    <Type>JKS</Type>
                    <Password>wso2carbon</Password>
                </TrustStore>
            </parameter>
        </transportReceiver>                                         
    ```

    ```toml tab='TOML configuration'
        [transport.http]
        listener.secured_enable = true              
        listener.secured_port = 8243        
        listener.secured_wsdl_epr_prefix = "https://apachehost:port/somepath"  
        listener.secured_bind_address = "hostname or IP address"
        listener.secured_protocols = "TLSv1,TLSv1.1,TLSv1.2"   
        listener.keystore.location ="repository/resources/security/wso2carbon.jks"
        listener.keystore.type = "JKS" listener.keystore.password = "wso2carbon"
        listener.keystore.key_password = "wso2carbon"
        listener.truststore.location = "repository/resources/security/client-truststore.jks"
        listener.truststore.type = "JKS" listener.truststore.password = "wso2carbon"
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#https-transport-non-blocking-mode).

-   VFS transport receiver

    ```xml tab='XML configuration'
        <transportReceiver name="vfs" class="org.apache.synapse.transport.vfs.VFSTransportListener"/>                                            
    ```

    ```toml tab='TOML configuration'
        [transport.vfs]
        listener.enable = true
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#vfs-transport).

-   Mailto transport receiver

    ```xml tab='XML configuration'
        <transportReceiver name="mailto" class="org.apache.axis2.transport.mail.MailTransportListener"/>    ```
    ```

    ```toml tab='TOML configuration'
        [transport.mail.listener]
        enable = true
        name = "mailto"
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#mail-transport-listener-non-blocking-mode).

-   JMS transport receiver

    ```xml tab='XML configuration'
        <transportReceiver name="jms" class="org.apache.axis2.transport.jms.JMSListener">
                <parameter name="myTopicConnectionFactory" locked="false">
                    <parameter name="java.naming.factory.initial" locked="false">org.apache.activemq.jndi.ActiveMQInitialContextFactory</parameter>
                    <parameter name="java.naming.provider.url" locked="false">tcp://localhost:61616</parameter>
                    <parameter name="transport.jms.ConnectionFactoryJNDIName" locked="false">TopicConnectionFactory</parameter>
                    <parameter name="transport.jms.ConnectionFactoryType" locked="false">topic</parameter>
                </parameter>
        </transportReceiver>
    ```

    ```toml tab='TOML configuration'
        [transport.jms]
        listener_enable = true

        [[transport.jms.listener]]
        name = "myTopicListener"
        parameter.initial_naming_factory = "org.apache.activemq.artemis.jndi.ActiveMQInitialContextFactory"
        parameter.provider_url = "tcp://localhost:61616"
        parameter.connection_factory_name = "TopicConnectionFactory"
        parameter.connection_factory_type = "topic" # [queue, topic]
        parameter.cache_level = "consumer"
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#jms-transport-listener-blocking-mode).

-   FIX transport receiver

    ```xml tab='XML configuration'
        <transportReceiver name="fix" class="org.apache.synapse.transport.fix.FIXTransportListener"/>
    ```

    ```toml tab='TOML configuration'
        [transport.fix]
        listener.enable = true
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#fix-transport).

-   RabbitMQ transport receiver

    ```xml tab='XML configuration'
        <transportReceiver name="rabbitmq" class="org.apache.axis2.transport.rabbitmq.RabbitMQListener">
                <parameter name="AMQPConnectionFactory" locked="false">
                    <parameter name="rabbitmq.server.host.name" locked="false">localhost</parameter>
                    <parameter name="rabbitmq.server.port" locked="false">5672</parameter>
                    <parameter name="rabbitmq.server.user.name" locked="false">guest</parameter>
                    <parameter name="rabbitmq.server.password" locked="false">guest</parameter>
                </parameter>
        </transportReceiver>
    ```

    ```toml tab='TOML configuration'
        [transport.rabbitmq]
        listener_enable = true

        [[transport.rabbitmq.listener]]
        name = "AMQPConnectionFactory"
        parameter.hostname = "localhost"
        parameter.port = 5672
        parameter.username = "guest"
        parameter.password = "guest"
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#rabbitmq-listener).

-   HL7 transport listener

    ```xml tab='XML configuration'
            <transportReceiver name="hl7" class="org.wso2.carbon.business.messaging.hl7.transport.HL7TransportListener">
                <parameter name="port">9292</parameter>
            </transportReceiver>
    ```

    ```toml tab='TOML configuration'
        [[custom_transport.listener]]
        class="org.wso2.micro.integrator.business.messaging.hl7.transport.HL7TransportListener"
        protocol = "hl7"
        parameter.'transport.hl7.TimeOut' = 10000
    ```

-   HTTP transport sender

    > **Warning**
    >
    > Do not duplicate the `[transport.http]` TOML header when you enable both the JMS listener and sender. Use the TOML header once and add both parameters (`listener_enabled` and `sender_enabled`).

    ```xml tab='XML configuration'
        <transportSender name="http" class="org.apache.synapse.transport.passthru.PassThroughHttpSender">
                <parameter name="non-blocking" locked="false">true</parameter>
         </transportSender>
    ```

    ```toml tab='TOML configuration'
        [transport.http]
        #listener_enable = true
        sender.enable = true
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#https-transport-non-blocking-mode).

-   HTTPS transport sender

    ```xml tab='XML configuration'
        <transportSender name="https" class="org.apache.synapse.transport.passthru.PassThroughHttpSSLSender">
                <parameter name="non-blocking" locked="false">true</parameter>
                <parameter name="keystore" locked="false">
                    <KeyStore>
                        <Location>repository/resources/security/wso2carbon.jks</Location>
                        <Type>JKS</Type>
                        <Password>wso2carbon</Password>
                        <KeyPassword>wso2carbon</KeyPassword>
                    </KeyStore>
                </parameter>
                <parameter name="truststore" locked="false">
                    <TrustStore>
                        <Location>repository/resources/security/client-truststore.jks</Location>
                        <Type>JKS</Type>
                        <Password>wso2carbon</Password>
                    </TrustStore>
                </parameter>
        </transportSender>
    ```

    ```toml tab='TOML configuration'
        [transport.http]
        sender.secured_enable = true
        sender.keystore.location ="repository/resources/security/wso2carbon.jks"
        sender.keystore.type = "JKS"
        sender.keystore.password = "wso2carbon"
        sender.keystore.key_password = "wso2carbon"
        sender.truststore.location = "repository/resources/security/client-truststore.jks"
        sender.truststore.type = "JKS"
        sender.truststore.password = "wso2carbon"
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#https-transport-non-blocking-mode).

-   VFS transport sender

    ```xml tab='XML configuration'
        <transportSender name="vfs" class="org.apache.synapse.transport.vfs.VFSTransportSender"/>
    ```

    ```toml tab='TOML configuration'
        [transport.vfs]
        sender.enable = true
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#vfs-transport).

-   VFS transport sender

    ```xml tab='XML configuration'
        <transportSender name="mailto" class="org.apache.axis2.transport.mail.MailTransportSender">
                <parameter name="mail.smtp.host">smtp.gmail.com</parameter>
                <parameter name="mail.smtp.port">587</parameter>
                <parameter name="mail.smtp.starttls.enable">true</parameter>
                <parameter name="mail.smtp.auth">true</parameter>
                <parameter name="mail.smtp.user">synapse.demo.0</parameter>
                <parameter name="mail.smtp.password">mailpassword</parameter>
                <parameter name="mail.smtp.from">synapse.demo.0@gmail.com</parameter>
        </transportSender>
    ```

    ```toml tab='TOML configuration'
        [[transport.mail.sender]]
        name = "mailto"
        parameter.hostname = "smtp.gmail.com"
        parameter.port = "587"
        parameter.enable_tls = true
        parameter.auth = true
        parameter.username = "synapse.demo.0"
        parameter.password = "mailpassword"
        parameter.from = "synapse.demo.0@gmail.com"
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#mail-transport-sender-non-blocking-mode).

-   FIX transport sender

    ```xml tab='XML configuration'
        <transportSender name="fix" class="org.apache.synapse.transport.fix.FIXTransportSender"/>
    ```

    ```toml tab='TOML configuration'
        [transport.fix]
        sender.enable = true
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#fix-transport).

-   RabbitMQ transport sender

    ```xml tab='XML configuration'
        <transportSender name="rabbitmq" class="org.apache.axis2.transport.rabbitmq.RabbitMQSender"/>
    ```

    ```toml tab='TOML configuration'
        [transport.rabbitmq]
        sender_enable = true
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#rabbitmq-sender).


-   JMS transport sender

    ```xml tab='XML configuration'
        <transportSender name="jms" class="org.apache.axis2.transport.jms.JMSSender"/>
    ```

    ```toml tab='TOML configuration'
        [transport.jms]
        sender_enable = true
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#jms-transport-sender-non-blocking-mode).

-   HL7 transport sender

    ```xml tab='XML configuration'
            <transportSender name="hl7" class="org.wso2.carbon.business.messaging.hl7.transport.HL7TransportSender">
            <!--parameter name="non-blocking">true</parameter-->
          </transportSender>
    ```

    ```toml tab='TOML configuration'
        [[custom_transport.sender]]
        class="org.wso2.micro.integrator.business.messaging.hl7.transport.HL7TransportSender"
        protocol = "hl7"
    ```

**synapse.properties**

Synapse thread pool properties:

```xml tab='XML configuration'
    synapse.threads.core = 20
    synapse.threads.max = 100
```

```toml tab='TOML configuration'
    [mediation]
    synapse.core_threads = 20
    synapse.max_threads = 100
```

Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#message-mediation).

**passthru-http.properties**

-   HTTP/S worker pool properties

    ```xml tab='XML configuration'
        worker_pool_size_core=400
        worker_pool_size_max=400
        worker_pool_queue_length=-1
    ```

    ```toml tab='TOML configuration'
        [transport.http]
        core_worker_pool_size = 400         # inferred default: 400
        max_worker_pool_size = 400          # inferred default: 400
        worker_pool_queue_length = -1
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#https-transport-non-blocking-mode).

-   Preserve headers

    ```xml tab='XML configuration'
        http.user.agent.preserve=false
        http.server.preserve=true
        http.headers.preserve=Content-Type
    ```

    ```toml tab='TOML configuration'
        [transport.http]
        preserve_http_user_agent = false
        preserve_http_server_name = true
        preserve_http_headers = ["Content-Type"]
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#https-transport-non-blocking-mode).

**jndi.properties**

-   JMS connection factory

    ```xml tab='XML configuration'
        connectionfactory.QueueConnectionFactory = amqp://admin:admin@clientID/carbon?brokerlist='tcp://localhost:5675'
        connectionfactory.TopicConnectionFactory = amqp://admin:admin@clientID/carbon?brokerlist='tcp://localhost:5675'
    ```

    ```toml tab='TOML configuration'
        [transport.jndi.connection_factories]
        'connectionfactory.QueueConnectionFactory' = "amqp://admin:admin@clientID/carbon?brokerlist='tcp://localhost:5675'"
        'connectionfactory.TopicConnectionFactory' = "amqp://admin:admin@clientID/carbon?brokerlist='tcp://localhost:5675'"
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#jndi-connection-factories).

-   JMS queue

    ```xml tab='XML configuration'
        queue.JMSMS=JMSMS
    ```

    ```toml tab='TOML configuration'
        [transport.jndi.queue]
        JMSMS = "JMSMS"
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#jndi-connection-factories).

-   JMS topic

    ```xml tab='XML configuration'
        topic.MyTopic = example.MyTopic
    ```

    ```toml tab='TOML configuration'
        [transport.jndi.topic]
        MyTopic = "example.MyTopic"
    ```

    Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi/#jndi-connection-factories).

**tasks-config.xml**

``xml tab='XML configuration'
    <taskServerCount>1</taskServerCount>
    <defaultLocationResolver>
        <locationResolverClass>org.wso2.carbon.ntask.core.impl.RoundRobinTaskLocationResolver</locationResolverClass>
    </defaultLocationResolver>      
```

```toml tab='TOML configuration'
    [task_handling]
    resolver_class = "org.wso2.micro.integrator.ntask.coordination.task.resolver.RoundRobinResolver"

    [[task_resolver]]
    task_server_count = "3"
```

Find more [parameters](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/mi-setup/deployment/deploying_wso2_ei).

The complete list of TOML configurations for the Micro Integrator are listed in the [product configuration catalog](https://apim.docs.wso2.com/en/4.2.0/reference/config-catalog-mi).

#### Migrating Log4j configurations

All ESB versions prior to EI 6.6.0 use <b>log4j</b>. In the Micro Integrator, the `carbon.logging.jar` file is not included and the `pax-logging-api` is used instead. With this upgrade, the log4j version is also updated to log4j2.

See the topics given below to configure log4j2 in the Micro Integrator.

-   [Log4j2 properties](https://apim.docs.wso2.com/en/4.2.0/observe/micro-integrator/classic-observability-logs/configuring-log4j2-properties)
-   [Correlation logs](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/mi-setup/observability)
-   [Wire logs](https://apim.docs.wso2.com/en/4.2.0/integrate/develop/using-wire-logs)
-   [Service-level logs](https://apim.docs.wso2.com/en/4.2.0/integrate/develop/monitoring-service-level-logs)
-   [REST API Access logs](https://apim.docs.wso2.com/en/4.2.0/integrate/develop/monitoring-api-level-logs)
-   [Managing Log Growth](https://apim.docs.wso2.com/en/4.2.0/administer/logging-and-monitoring/logging/managing-log-growth)

Follow the instructions given below if you have used a **custom log4j component** in your older EI version.

1.  Replace carbon logging or commons.logging dependencies with pax-logging dependency as shown below.

    ```xml
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

    -   Replace the log4j dependency (shown below) with log4j2 and rewrite the loggers accordingly.

        ```xml
            <dependency>
               <groupId>org.ops4j.pax.logging</groupId>
               <artifactId>pax-logging-log4j2</artifactId>
               <version>${pax.logging.log4j2.version}</version>
            </dependency>
        ```

    -   Replace the log4j dependency with pax-logging dependency and rewrite the loggers using commons.logging accordingly.

3.  If commons.logging is imported using Import-Package, add the version range.

    ```xml
        org.apache.commons.logging;
        version="${commons.logging.version.range}" 
        <commons.logging.version.range>[1.2.0,2.0.0)</commons.logging.version.range>
    ```

4.  Follow the instructions on [configuring log4j2](https://apim.docs.wso2.com/en/4.2.0/observe/micro-integrator/classic-observability-logs/configuring-log4j2-properties) to register the Appenders and Loggers.

### Migrating encrypted passwords

To migrate the encrypted passwords from EI 6.3.0, you need to first obtain the plain-text passwords. Once you have them, follow the normal procedure of encrypting secrets in the Micro Integrator for API-M 4.2.0. See [Encrypt Secrets](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/mi-setup/security/encrypting_plain_text) for instructions.

In case you need to obtain the plain-text passwords by decrypting the encrypted passwords in the EI 6.3.0, you can use the password decryption tool. Contact WSO2 Support if you do not have this file.

Follow the instructions given below to use the password decryption tool.

1. Contact WSO2 Support to obtain the tool.

2. Copy the `org.wso2.mi.migration-1.2.0.jar` into the `EI_HOME/dropins` folder in the server.

3. Create a directory named `migration` in `EI_HOME`.

4. Copy the migration-conf.properties file into the `migration` directory and update the following property. Contact WSO2 Support if you do not have this file.

    | Property         | Description   |
    | ---------------- | ------------- |
    | admin.user.name  | The user name of the system [administrator](https://docs.wso2.com/display/EI660/Configuring+the+System+Administrator). |

5. Start the server using the `migrate.from.product.version` system property as follows:

    ```bash tab='On Linux/Unix'
    sh integrator.sh -Dmigrate.from.product.version=ei
    ```

    ```bash tab='On Windows'
    integrator.bat -Dmigrate.from.product.version=ei
    ```

    > **Info**
    >
    >    Upon successful execution, the decrypted (plain-text) values in the `secure-vault.properties` and `cipher-text.properties` files will be written respectively to the `<EI_HOME>/migration/secure-vault-decrypted.properties` file and the `<EI_HOME>/migration/cipher-text-decrypted.properties` file in EI 6.3.0.

    The encrypted passwords are now decrypted and you have access to the plain-text password values.

6.  Use the plain-text passwords and follow the normal procedure of encrypting secrets in the Micro Integrator of API-M 4.2.0. See [Encrypting Secrets](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/mi-setup/security/encrypting_plain_text) for instructions.

### Migrating the Hl7 Transport

HL7 transport is not shipped by default in the API-M 4.2.0 Micro Integrator distribution. Therefore, the jars need to be added to the Micro Integrator server manually. See [Configuring the HL7 transport](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/mi-setup/transport_configurations/configuring-transports/#configuring-the-hl7-transport) for details.
