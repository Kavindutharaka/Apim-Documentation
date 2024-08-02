# Authentication Script

The `<WSO2_OB_APIM_140_HOME>/repository/conf/finance/common.auth.script.js` authentication script is introduced, with the latest release of the Transactional Risk Analysis (TRA) module. The script supports the following functionalities.

When the second factor is enabled:

- When TRA is enabled, the script executes the TRA functions and applies Strong Customer Authentication.
- Publishes authentication data for [Data Reporting](https://docs.wso2.com/display/OB140/PSD2+Data+Reporting).

> **Note**
> 
> If you have customized `<WSO2_OB_APIM_130_HOME>/repository/conf/finance/conditional.auth.script.js`, update your script with the new changes in the `common.auth.script.js`.

Run the relevant migration script, to store common.auth.script.js as the new conditional auth script against the existing service providers.

- The migration scripts are available in the `<WSO2_OB_KM_140_HOME>/dbscripts/finance/openbanking.org.uk/migration-from-1.3.0` directory.
- Select the script, according to your database.
- Update path to conditional auth script variable as follows:

  **MySQL**

    ```
    path to conditional auth script: The path to common.auth.script.js (including the filename).
    ```

  **MSSQL**

    ```
    path to conditional auth script: The path to common.auth.script.js (including the filename).
    ```

  **Oracle**

    ```
    path to conditional auth script: The path to common.auth.script.js (excluding the filename).
    ```

- Run the relevant script against the `openbank_apimgtdb` database.