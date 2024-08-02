# WSO2 Open Banking UK (Upgrading from v3.1 to v3.1.1)

## `UK_CONSENT_REV` table

- The `UK_CONSENT_REV` table is altered to have an auto increment field as the new primary key instead of the complex primary key used in v1.3.0.
- Run the relevant database script in the `<WSO2_OB_KM_HOME>/dbscripts/finance/openbanking.org.uk/migration-from-1.3.0` directory against the `openbank_openbankingdb` database.

  > **For Oracle database:**
  > 
  > When dropping the constraints, if there is more than one `UK_CONSENT_REV` table, change the SQL query as below and execute. Update the `<ORACLE_USER>` placeholder with the current database user.
  > 
  >   ```
  >   SELECT * FROM all_constraints WHERE table_name = 'UK_CONSENT_REV' AND index_owner= '<ORACLE_USER>';
  >   ```

## `OB_DCR_DETAILS` table

The following changes are done to support [Dynamic Client Registration v3.2](https://docs.wso2.com/display/OB140/Dynamic+Client+Registration+v3.2).

- Run the relevant SQL migration script in the `<WSO2_OB_APIM_HOME>/dbscripts/finance/dynamic-client-registration/migration-3.1_to_3.2` directory, against the `openbank_openbankingdb` database. The SQL script modifies the `OB_DCR_DETAILS` table by adding the following columns:
    - `APPLICATION_ID`
    - `SOFTWARE_ID`
    - `CLID_ISSUED_AT`