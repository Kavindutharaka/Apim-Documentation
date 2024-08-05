# Data Migration On Different Environments

## Recommended Approach

**It's recommended to conduct the data migration on a separate virtual machine (VM)/ local machine regardless of your deployment environment**. Once the data migration is completed, you can direct the production environment deployment to the migrated data source.

The data migration process involves modifying existing databases to support the new API-M version. This is achieved by running a migration client through an API-M instance(All-in-One or Control-Plane instance). The migration client performs tasks such as creating new tables, altering existing ones, and transferring data between tables to ensure the database supports the new version. So, the primary requirement for data migration is access to the data source. The environment on which the migration client operates is not crucial, as the migration changes are directly applied to the database.

Therefore, we suggest conducting the data migration on a VM/local machine. This will enable you to perform the data migration seamlessly while following our documentation as provided.

## Alternate Approaches

- If you are unable to follow the previously mentioned approach and need to perform the **data migration directly on a K8s cluster**, you can do so using a single pod Deployment in K8s. However, this method is not straightforward. It involves creating custom product images with migration jars/ resources, and defining appropriate K8s Deployments. Moreover, this approach carries significant risks, as premature termination of pods conducting the data migration could potentially leave the database in a corrupted state. Therefore, if you intend to proceed with data migration on K8s, please contact [**WSO2 Support**]((https://support.wso2.com/jira/secure/Dashboard.jspa)) for assistance.

- If you are unable to follow the previously mentioned approach and need to perform the **data migration directly within Docker containers**, you can do so by configuring a Docker container environment. However, the specifics of this process may vary with your Docker environment. Therefore, if you intend to proceed with data migration within Docker containers, it is advisable to contact [**WSO2 Support**]((https://support.wso2.com/jira/secure/Dashboard.jspa)) for assistance.



