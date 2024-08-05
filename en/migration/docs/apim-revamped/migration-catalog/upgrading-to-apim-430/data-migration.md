<small> 1. Config Migration > 2. Resource & Artifact Migration > 3. Extensions & Customizations Migration > [4. Data Migration](./data-migration.md) > 5. Server Startup </small>

# Data Migration

## Prerequisites

1. Follow the [Data Migration Guidelines](../../general-data-migration.md).
   
2. Check on the [Tested DBMS](https://apim.docs.wso2.com/en/4.3.0/install-and-setup/setup/reference/product-compatibility/#tested-dbmss) for API-M 4.3.0. Only those versions will be supported in migration as well. Therefore, if you are currently on an older database version, please migrate your database to the supported version first before proceeding with the migration.

## Step 1: Run the Database Scripts

From DB scripts included [here](../../../../../api-manager/migration-resources/apim-4.3.0-resources/), run the script corresponding to your DB type on the `apim_db` (database keeping specific API-M related data).

---
*By now, you should have completed all the main steps of the migration.*
