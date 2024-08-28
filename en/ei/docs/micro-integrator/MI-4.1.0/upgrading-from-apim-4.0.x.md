# Upgrading from WSO2 API-M 4.0.0 to WSO2 API-M 4.1.0

This guide explains the recommended strategy for upgrading from the Micro Integrator of WSO2 API-M 4.0.0 to the Micro Integrator of WSO2 API-M 4.1.0. 

> **Note**
> Because there aren't any database changes between the Micro Integrators of API-M 4.0.0 and API-M 4.1.0, upgrading involves moving (migrating) all your artifacts and configurations from API-M 4.0.0 to API-M 4.1.0.

### Setting up

-	Make a backup of the databases used by the current API-M 4.0.0 deployment. This backup is necessary in case the migration causes any issues in the existing database.
-	[Download and install](https://apim.docs.wso2.com/en/4.1.0/install-and-setup/install/installing-the-product/installing-mi) the latest Micro Integrator in your environment:

	> **Tip**
	>
	> The home directory of your Micro Integrator will be referred to as `<MI_HOME>` from hereon.

-	Use [WSO2 Updates](https://updates.docs.wso2.com/en/latest/updates/overview/) to get the latest available updates for your Micro Integrator distribution.

	 > **Note**
	 > 
	 > Note that you need a valid [WSO2 subscription](https://wso2.com/subscription) to use updates in a production environment.

### Migrating the user store

If you are using an **LDAP user store** with API-M 4.0.0, you can simply connect the same to the Micro Integrator of API-M 4.1.0 by updating the configuration details in the Micro Integrator's `deployment.toml` file. 

If you are using a **JDBC user store** with API-M 4.0.0, you need to first update the database before connecting the same to APIM 4.1.0.

Follow the steps given below.

#### Connect to the user store

To connect the Micro Integrator to the primary user store:

-	[configuring an LDAP user store](https://apim.docs.wso2.com/en/4.1.0/install-and-setup/setup/mi-setup/user_stores/setting_up_a_userstore/#configuring-an-ldap-user-store) for the Micro Integrator in API-M 4.1.0.
-	[configuring an RDBMS user store](https://apim.docs.wso2.com/en/4.1.0/install-and-setup/setup/mi-setup/user_stores/setting_up_a_userstore/#configuring-an-rdbms-user-store) for the Micro Integrator in API-M 4.1.0.

### Migrating secondary user stores

Copy the contents inside the `<MI_HOME>/repository/deployment/server/userstores` folder in the Micro Integrator of API-M 4.0.0 to the same folder in API-M 4.1.0.

### Migrating the registry

The Micro Integrator uses a [file-based registry](https://apim.docs.wso2.com/en/4.1.0/install-and-setup/setup/mi-setup/deployment/file_based_registry). You can directly migrate the artifacts to the Micro Integrator of API-M 4.1.0 by copying the carbon applications from the `<MI_HOME>/repository/deployment/server/carbonapps` folder in the Micro Integrator of API-M 4.0.0 to the same folder in API-M 4.1.0. 

### Migrating artifacts

Copy the contents inside the `<MI_HOME>/repository/deployment` folder in the Micro Integrator of API-M 4.0.0 to the same folder in API-M 4.1.0.

### Migrating custom components

Copy the jars inside the `<MI_HOME>/dropins` folder in the Micro Integrator of API-M 4.0.0 to the same folder in API-M 4.1.0. The custom JARs can be copied to the `<MI_HOME>/lib` folder in API-M 4.1.0.

### Migrating keystores

Copy the JKS files from the `<MI_HOME>/repository/resources/security` folder in the Micro Integrator of API-M 4.0.0 to the same folder in API-M 4.1.0.

### Migrating configurations

Copy the configurations in the `deployment.toml` file of the Micro Integrator of API-M 4.0.0 (such as database, transport, datasource configurations, etc.) to the `deployment.toml` file of the Micro Integrator in API-M 4.1.0.

### Migrating Hl7 Transport

HL7 transport is not shipped by default in the API-M 4.1.0 Micro Integrator distribution. Therefore, the jars need to be added to the Micro Integrator server manually. See [Configuring the HL7 transport](https://apim.docs.wso2.com/en/4.1.0/install-and-setup/setup/mi-setup/transport_configurations/configuring-transports/#configuring-the-hl7-transport) for details.
