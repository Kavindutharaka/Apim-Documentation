# Application attribute changes

WSO2 Open Banking 1.5.0 supports both regulatory and non-regulatory APIs. To use this feature, you need to update the application attributes. Run the relevant migration script in the given locations against the `openbank_apimgtdb` database.

| **Database**        | **Script location**                                                   |
|---------------------|-----------------------------------------------------------------------|
| `openbank_apimgtdb` | `<WSO2_OB_KM_HOME>/dbscripts/finance/apimgt/migration-1.4.0_to_1.5.0` |