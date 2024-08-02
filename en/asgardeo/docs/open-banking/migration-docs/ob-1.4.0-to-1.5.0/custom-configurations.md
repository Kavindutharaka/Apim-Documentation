# Custom configurations

Copy the following content from WSO2 Open Banking 1.4.0 to WSO2 Open Banking 1.5.0:

| Content                                    | Copy from                                                              | Copy to                                                                |
|--------------------------------------------|------------------------------------------------------------------------|------------------------------------------------------------------------|
| Synapse configurations                     | `<WSO2_OB_APIM_140_HOME>/repository/deployment/server/synapse-configs` | `<WSO2_OB_APIM_150_HOME>/repository/deployment/server/synapse-configs` |
| Custom configurations                      | `<WSO2_OB_KM_140_HOME>/repository/conf`                                | `<WSO2_OB_KM_150_HOME>/repository/conf`                                |
| Custom configurations                      | `<WSO2_OB_APIM_140_HOME>/repository/conf`                              | `<WSO2_OB_APIM_150_HOME>/repository/conf`                              |
| Custom OSGI bundles (manually added files) | `<WSO2_OB_KM_140_HOME>/repository/components/dropins`                  | `<WSO2_OB_KM_150_HOME>/repository/components/dropins`                  |
| Custom OSGI bundles (manually added files) | `<WSO2_OB_APIM_140_HOME>/repository/components/dropins`                | `<WSO2_OB_APIM_150_HOME>/repository/components/dropins`                |
| Custom JAR files (manually added files)    | `<WSO2_OB_KM_140_HOME>/repository/components/lib`                      | `<WSO2_OB_KM_150_HOME>/repository/components/lib`                      |
| Custom JAR files (manually added files)    | `<WSO2_OB_APIM_140_HOME>/repository/components/lib`                    | `<WSO2_OB_APIM_150_HOME>/repository/components/lib`                    |