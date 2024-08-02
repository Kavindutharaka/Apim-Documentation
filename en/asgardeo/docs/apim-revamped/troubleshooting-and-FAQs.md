# Troubleshooting and FAQ
This document contains all the FAQs and general troubleshooting guidelines.


## Troubleshooting

1. Before running the **identity data migration** and **APIM data migration**, it is recommended to create database dumps. If this step fails, do not proceed with a corrupt database; instead, restore it to its previous state.

2. When running the **identity data migration**, if you encounter the following error message, follow the steps in this section. Note that this error could occur only if the identity tables contain a huge volume of data.
    
    Sample exception stack trace is given below.

    ```
    ERROR {org.wso2.carbon.registry.core.dataaccess.TransactionManager} -  Failed to start new registry transaction. {org.wso2.carbon.registry.core.dataaccess.TransactionManager} org.apache.tomcat.jdbc.pool.PoolExhaustedException: [pool-30-thread-11] Timeout: Pool empty. Unable to fetch a connection in 60 seconds, none available[size:50; busy:50; idle:0; lastwait:60000
    ```
    A.  Add the following property in `<API-M_HOME>/repository/conf/deployment.toml` to a higher value (eg 10)
    ```toml
    [indexing]
    frequency = 10
    ```
    
    B.  Re-run the command above. **Make sure to revert the change done 'A' after the migration is complete.**
