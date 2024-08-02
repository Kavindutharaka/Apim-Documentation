# Upgrade WSO2 Open Banking from 2.0.0 to 3.0.0 - Introduction

WSO2 Open Banking Accelerator runs on top of WSO2 Identity Server and WSO2 API Manager which are referred to as base products.

Given below is the product compatibility matrix for WSO2 Open Banking. This matrix outlines the compatibility between the versions of WSO2 Open Banking solutions involved in this migration and the latest version of the base products they support.

| WSO2 Open Banking Version | Supported WSO2 Identity Server Version | Supported WSO2 API Manager Version |
|---------------------------|----------------------------------------|------------------------------------|
| 2.0.0                     | 5.10.0                                 | 3.1.0                              |
| 3.0.0                     | 6.1.0                                  | 4.2.0                              |

The following diagram explains the flow of upgrading the WSO2 Open Banking solution:

![migration-flow](https://uk.ob.docs.wso2.com/en/latest/assets/img/install-and-setup/upgrading-the-solution/migration-flow-v1.png)

**Step 1: Upgrade APIM 3.1.0 to APIM 3.2.0**


**Step 2: Upgrade IS 5.10.0 to IS 5.11.0**


**Step 3: Upgrade APIM 3.2.0 to APIM 4.0.0**


**Step 4: Upgrade IS 5.11.0 to IS 6.1.0**


**Step 5: Upgrade APIM 4.0.0 to APIM 4.2.0**


**Step 6: Migrate Open Banking DB**
This is the step where you migrate Open Banking data. This involves moving the data from your existing Open Banking platform to the new WSO2 Open Banking platform. This includes data such as customer accounts, transactions, and permissions.

**Step 7: Migrate Reporting Data**
Migrating Reporting Data involves moving the data from your existing reporting system to the new WSO2 Open Banking platform. This includes data such as reports, dashboards, and visualizations.




Follow the documents below in the given order:

1. Upgrading to WSO2 API Manager 3.2.0 (`upgrade-to-wso2-api-manager-3.2.0.md`)
2. Upgrading to WSO2 Identity Sever 5.11.0 (`upgrade-to-wso2-identity-server-5.11.0.md`)
3. Upgrading API Manager 3.2.0 to 4.0.0 (`upgrade-to-wso2-api-manager-4.0.0.md`)
4. Upgrade WSO2 API Manager from 4.0.0 to 4.2.0 and WSO2 Identity Server from 5.11.0 to 6.1.0 (`upgrade-api-manager-4.0.0-to-4.2.0-and-identity-server-5.11.0-to-6.1.0.md`)
5. Migrating Open Banking Data (`open-banking-data-migration.md`)
6. Migrating Reporting Data (`reporting-data-migration.md`)
7. Configuring After Migration (`modifications-after-migration.md`)

This section guides on how to upgrade your WSO2 Open Banking 2.0.0 setup to WSO2 Open Banking 3.0.0 (Accelerator Model). 

>**Note**
>
>    WSO2 Open Banking 2.0.0 is based on the WSO2 API Manager 3.1.0 and WSO2 Identity Server 5.10.0 products.

>**Tip**
>
>    - The DCR applications created in Open Banking 2.0.0 should not contain a SoftwareId/IssuerName that includes an
>      underscore **"_"**.
>    - If you have such DCR applications, before the migration process, rename the **Service Provider Name**
>      of each DCR application's Service Provider application by logging into `https://<IS_HOST>:9446/carbon`.
>    - In your Open Banking 2.0.0 database, check the column size of the following:
>
>        | Database          | Table       | Column| Data type | Size |
>        |-------------------|-------------|-------|-----------|------|
>        |`openbank_apimgtdb`|`SP_METADATA`|`VALUE`| `VARCHAR` | 4096 |
>
>        - If the column size is less than 4096, execute the following command against the `SP_METADATA` table:
>
>             ``` 
>             ALTER TABLE SP_METADATA MODIFY VALUE VARCHAR(4096); 
>             ```


Next, refer to the **Upgrading to WSO2 API Manager 3.2.0** (`upgrade-to-wso2-api-manager-3.2.0.md`) documentation.