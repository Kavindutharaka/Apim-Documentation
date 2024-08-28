# Preparing for migration

This guide helps you in preparing for migration to IS 5.11.0.

For a high-level overview of what has been added, changed, or deprecated in this IS 5.11.0, see [About this release](https://is.docs.wso2.com/en/5.11.0/get-started/about-this-release).

> **Note**
> 
> In this section, `<OLD_IS_HOME>` is the directory that the current Identity Server resides in, and `<NEW_IS_HOME>` is the directory that WSO2 Identity Server 5.11.0 resides in.

> **Important**
>
> Before proceeding with the migration, change the following property to `false` in the `<IS_HOME>/repository/conf/deployment.toml` file.
>
> ```toml
> [super_admin]
> create_admin_account = false 
> ```

## Prerequisites

1. Review what has been changed in this release. For a detailed list of changes from 5.10.0 to 5.11.0, see the **What Has Changed in 5.11.0**.

2. Before you migrate, refer to the **Migration Process** document to understand the migration process.

3. You can use the [Update Management Tool](https://updates.docs.wso2.com/en/latest/)(UMT) to get any fixes or latest updates for this release.

4. Take a backup of the existing database used by the current WSO2 Identity Server. This backup is necessary if the migration causes any issues in the existing database.

5. Download WSO2 Identity Server 5.11.0 and unzip it in the `<NEW_IS_HOME>` directory.

6. Next, refer to the document on **Preparing for migration**.


## Groups and Roles Migration

With WSO2 Identity Server 5.11.0, groups and roles are separated. For more information, see the document on **What Has Changed in 5.11.0**.

## Migrating custom components

In WSO2 Identity Server 5.11.0, we have done a major upgrade to our kernel and our main components. Any custom OSGi bundles added manually should be recompiled with new dependency versions relevant to the new WSO2 IS version. All custom OSGI components reside in the `<OLD_IS_HOME>/repository/components/dropins` directory.

1. Get the source codes of the custom OSGI components located in the dropins directory.

2. Change the dependency versions in the relevant POM files according to the WSO2 IS version you are upgrading to and compile them. The compatible dependency versions can be found [here](https://github.com/wso2/product-is/blob/v5.11.0-rc1/pom.xml).

3. If you come across any compile time errors, refer to the WSO2 IS code base and make the necessary changes related to that particular component version.

4. Add the compiled JAR files to the `<NEW_IS_HOME>/repository/components/dropins` directory.

5. If there were any custom OSGI components in the `<OLD_IS_HOME>/repository/components/lib` directory, add newly compiled versions of those components to the `<NEW_IS_HOME>/repository/components/lib`  directory.

## Migrating the configurations

Refer to the relevant feature documents and the **What Has Changed in 5.11.0** document to do the configuration migration.

> **Info**
>
> If you have a WSO2 Subscription, it is highly recommended to reach [WSO2 Support](https://support.wso2.com/jira/secure/Dashboard.jspa) before attempting to proceed with the configuration migration.
