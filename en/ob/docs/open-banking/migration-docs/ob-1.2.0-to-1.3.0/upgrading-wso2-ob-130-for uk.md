# Upgrade the Solution to 1.3.0 for UK

Follow the steps below to upgrade WSO2 Open Banking from 1.2.0 to 1.3.0.

## Step 1: Update your applications

In your new setup, update the following applications:

| In WSO2 API Manager          | In Key Manager                 |
| ---------------------------- | ------------------------------ |
| - API Store Jaggery App      | - Consent Revocations App      |
| - API Publisher Jaggery App  | - Authentication Endpoint App  |
| - API Admin Jaggery App      |                                |

## Step 2: Migrate your data to the new setup

After the applications are updated, point to your databases from the new setup.

> **Note**
> 
> If you want to configure the new setup with previously used databases, set up the `REGISTRY_DB` database separately.

1. Stop all Open Banking servers that are running.

2. Take a backup of `WSO2_CONSENT_DB`, which is configured in `<WSO2_OBKM_HOME>/repository/conf/datasources/open-banking-datasources.xml` as shown in the example below.

    ```
    <datasources>
           <datasource>
               <name>WSO2_CONSENT_DB</name>
               <description>The datasource used for registry and user manager</description>
               <jndiConfig>
                   <name>jdbc/WSO2ConsentDB</name>
               </jndiConfig>
               <definition type="RDBMS">
                   <configuration>
                       <url>jdbc:mysql://localhost:3306/openbank_consentdb_dev?autoReconnect=true&amp;useSSL=false</url>
    ```

   > **Info**
   > 
   >  - Note that the migration scripts are available in the data-migration   directory. By default, the consent database's name is given as    `openbank_consentdb` in the migration scripts. If your consent database's  name is different to that, replace `openbank_consentdb` with your database's     name in the migration scripts.
   >  - Note that the event-notification tables that existed in a separate database   in previous versions, were moved to the consent-db database.

3. Execute the SQL script in the `<WSO2_OBKM_HOME>/dbscripts/finance/openbanking.org.uk/migration-from-1.2.0/` against `WSO2_CONSENT_DB`. It changes the existing database according to the requirements of WSO2 Open Banking version 1.3.0.

   > **Note**
   > 
   > This step is needed only if your database is MySQL.

4. Execute the data migration script that is relevant to your database type in the `<WSO2_OBKM_HOME>/dbscripts/finance/openbanking.org.uk/migration-from-1.2.0/data-migration/ directory against WSO2_CONSENT_DB` to insert/ update existing data according to the requirements of WSO2 Open Banking version 1.3.0.

   > **Note**
   > 
   > Note that the migration scripts are compatible only with **Oracle 12c release   2 or newer**.

5. Create table `AM_API_CLIENT_CERTIFICATE` under the datasource `WSO2AM_DB` by executing the following configuration based on your database.

**MySQL**

```
CREATE TABLE IF NOT EXISTS `AM_API_CLIENT_CERTIFICATE` (
 `TENANT_ID` INT(11) NOT NULL,
 `ALIAS` VARCHAR(45) NOT NULL,
 `API_ID` INTEGER NOT NULL,
 `CERTIFICATE` BLOB NOT NULL,
 `REMOVED` BOOLEAN NOT NULL DEFAULT 0,
 `TIER_NAME` VARCHAR (512),
 FOREIGN KEY (API_ID) REFERENCES AM_API (API_ID) ON DELETE CASCADE ON UPDATE CASCADE,
 PRIMARY KEY (`ALIAS`, `TENANT_ID`, `REMOVED`)
) ENGINE=InnoDB;
```

**MSSQL**

```
IF NOT  EXISTS (SELECT * FROM SYS.OBJECTS WHERE OBJECT_ID = OBJECT_ID(N'[DBO].[AM_API_CLIENT_CERTIFICATE]') AND TYPE IN (N'U'))
CREATE TABLE AM_API_CLIENT_CERTIFICATE (
   TENANT_ID INTEGER NOT NULL,
   ALIAS VARCHAR(45) NOT NULL,
   API_ID INTEGER NOT NULL,
   CERTIFICATE VARBINARY(MAX) NOT NULL,
   REMOVED BIT NOT NULL DEFAULT 0,
   TIER_NAME VARCHAR(512),
   PRIMARY KEY (ALIAS, TENANT_ID, REMOVED),
   FOREIGN KEY (API_ID) REFERENCES AM_API(API_ID) ON DELETE CASCADE
);
```

**Oracle**

```
CREATE TABLE AM_API_CLIENT_CERTIFICATE (
 TENANT_ID INTEGER NOT NULL,
 ALIAS VARCHAR2(45) NOT NULL,
 API_ID INTEGER NOT NULL,
 CERTIFICATE BLOB NOT NULL,
 REMOVED INTEGER DEFAULT 0 NOT NULL,
 TIER_NAME VARCHAR2 (512),
 FOREIGN KEY (API_ID) REFERENCES AM_API (API_ID) ON DELETE CASCADE,
 PRIMARY KEY (ALIAS, TENANT_ID, REMOVED)
)
```