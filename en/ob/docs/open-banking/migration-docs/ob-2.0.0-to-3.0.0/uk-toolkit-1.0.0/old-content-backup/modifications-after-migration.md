# Modifications After Migration

This page explains the modifications that need to be performed after the upgrade/migration process.

1. Stop the servers if running.

2. Remove `com.wso2.openbanking.migration-1.0.0.jar` from the `IS_HOME>/repository/components/dropins` folder.

3. Remove `openbanking-migration-resources` folder from the `<IS_HOME>/repository/components/dropins` folder.

    > **Note:**
    >
    > Make sure to perform the following changes before starting with the Open Banking flows:
    >    1. Redeploy the APIs with the relevant insequence files supported in WSO2 Open Banking 3.0.0 UK Toolkit 1.0.0.
    >    2. Ensure the Production/Sandbox Endpoints of the published APIs are precise.
    >
    > - Follow the [Quick Start Guide - Tryout Flow of the UK Toolkit 1.0.0 documentation](https://uk.ob.docs.wso2.com/en/latest/get-started/try-out-flow/) for a sample tryout flow of the Account and Transaction API.
    > - Navigate to the **Tryout** section in the [UK Toolkit 1.0.0 documentation](https://uk.ob.docs.wso2.com/en/latest/try-out/dynamic-client-registration-flow/) for more information on API flows.

4. Restart the WSO2 Identity Server.

5. Restart the WSO2 API Manager Server. 
