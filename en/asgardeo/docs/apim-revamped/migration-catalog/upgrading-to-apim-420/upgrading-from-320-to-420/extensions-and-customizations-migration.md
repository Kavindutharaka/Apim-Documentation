<small> 1. Config Migration > 2. Resource & Artifact Migration > [3. Extensions & Customizations Migration](./extensions-and-customizations-migration.md) > 4. Data Migration > 5. Server Startup </small>

# Extensions and Customizations Migration

Follow the steps below to migrate existing API Manager extensions and customizations from the current environment to API Manager 4.2.0.

## Prerequisites

1. Read the [Extensions and Customizations Migration Guidelines](../../../general-extensions-and-customizations.md).

2. Identify significant API alterations between API-M version 3.2.0 and API-M version 4.2.0. You may contact [WSO2 Support](https://support.wso2.com/jira/secure/Dashboard.jspa) for assistance.


## Steps for Customization & Extensions Migration

1. If you have manually added any custom OSGI bundles to the `<API-M_3.2.0_HOME>/repository/components/dropins` directory, copy those to the `<API-M_4.2.0_HOME>/repository/components/dropins` directory. 

    - If your customizations are already incorporated in the latest version, there is no need to relocate the bundles.
    - In case customizations are not available yet,
        - Initially, update the dependency version of the dependant WSO2 components and re-build the customized component.
        - If you have identified there are API changes, please update the custom code and re-build.

2. If you have manually added any JAR files to the `<API-M_3.2.0_HOME>/repository/components/lib` directory, copy those and paste them in the `<API-M_4.2.0_HOME>/repository/components/lib` directory.
   
   - If your customizations are already incorporated in the latest version, there is no need to relocate the bundles.
   - In case customizations are not available yet,
        - Initially, update the dependency version of the dependant WSO2 components and re-build the customized component.
        - If you have identified there are API changes, please update the custom code and re-build.

3. If you have added any UI customizations to API-M 3.2.0, you will have to add them again to API-M 4.2.0. You can reach [WSO2 Support](https://support.wso2.com/jira/secure/Dashboard.jspa) for assistance.

> **Important**
> 
> Note that at this point, we will not be able to migrate customizations related to tenants, as tenant directories are not created until after data migration. Therefore, you will need to move customizations/resources related to tenant directories after data migration, before server startup, as outlined later in [Server Startup Actions](server-startup-actions.md).

---
*At this point you should have only the data migration remaining. Please note, once you have completed all the steps up to data migration, before initiating the data migration process, it is recommended to test the new version with the configurations and customizations. Refer to [Planning the Update](../../../general-guidelines.md) section.*
