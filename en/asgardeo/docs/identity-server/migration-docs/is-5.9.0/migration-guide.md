# Before you begin

This section walks you through the steps you need to follow to upgrade
WSO2 Identity Server to version 5.9.0. 

## Should I migrate?

WSO2 recommends upgrading to the latest version in order to ensure that
users receive the latest updates for the product.

-   For a high level overview of what has been added, changed, or
    deprecated in this release, see [About this
    release](https://is.docs.wso2.com/en/5.9.0/get-started/about-this-release).
-   For a detailed overview of behavioral changes in this release, see the
    **What Has Changed in IS 5.9.0** document.
    
## Prerequisites

1.  Review what has been changed in this release. For a detailed list of
    changes from 5.8.0 to 5.9.0, see the
    **What Has Changed in IS 5.9.0** document.

2.  Before you migrate, refer to the **Migration Process** document 
    to get an understanding on the migration process.

3.  This release is a WUM-only release. This means that there are no
    manual patches. You can use [WSO2 Update Manager](https://wso2.com/updates/wum)(WUM) to get any
    fixes or latest updates for this release.

    >   **Important**
    >
    >   If you are upgrading to use this version in your production
        environment, use WSO2 Update Manager to get the latest updates
        available for WSO2 IS 5.9.0. For more information on how to use WSO2
        Update Manager, see [Updating WSO2 Products](https://updates.docs.wso2.com/en/latest/).

4.  Take a backup of the existing database used by the current WSO2 Identity Server. 
    This backup is necessary in case the migration causes any issues in the existing database.

5.  Download WSO2 Identity Server 5.9.0 and unzip it in the `<NEW_IS_HOME>` directory.

6.  Next, refer to the **Preparing for migration** document.