# Datasource changes

>**Warning**
>
>The following datasource and database are renamed.
>- The `WSO2_CONSENT_DB` datasource is renamed as `WSO2_OPEN_BANKING_DB`.
>- The `openbank_consentdb` database is renamed as `openbank_openbankingdb`.


Update the `WSO2_CONSENT_DB` datasource values and set them to `WSO2_OPEN_BANKING_DB` in the following files:

- `<WSO2_OB_KM_HOME>/repository/conf/datasources/master-datasources.xml`
- `<WSO2_OB_KM_HOME>/repository/conf/finance/open-banking.xml`
- `<WSO2_OB_APIM_HOME>/repository/conf/datasources/master-datasources.xml`
- `<WSO2_OB_APIM_HOME>/repository/conf/finance/open-banking.xml`