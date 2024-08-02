# WSO2 Open Banking UK

1. Run the relevant database script in the given locations against the `openbank_openbankingdb` database.

| **Database**             | **Script location**                                                                |
|--------------------------|------------------------------------------------------------------------------------|
| `openbank_openbankingdb` | `<WSO2_OB_KM_HOME>/dbscripts/finance/openbanking.org.uk/migration-1.4.0_to_1.5.0/` |
| `openbank_openbankingdb` | `<WSO2_OB_KM_HOME>/dbscripts/finance/event-notification/migration-1.4.0_to_1.5.0/` |

2. To disable validating and signing payload for x-jws-signature header, set the following configuration to `false` in the `open-banking.xml` files.

- `<WSO2_OB_KM_HOME>/repository/conf/finance/open-banking.xml`
- `<WSO2_OB_APIM_HOME>/repository/conf/finance/open-banking.xml`

    ```
    <SigningConfiguration>
    <Enable>false</Enable>
    ```

3. Changes for Dynamic Client Registration:

     1. Add the following configurations for Dynamic Client Registration under `<Server>` tag and update them accordingly. Remove any DCR configurations within the `<UK>` tags. 

        **DCR v1.0.0**
     
        ```
           <DCR>
            <TokenAuthentication>
                <Method>private_key_jwt</Method>
                <Method>tls_client_auth</Method>
            </TokenAuthentication>
            <ConnectionTimeout>0</ConnectionTimeout>
            <ReadTimeout>0</ReadTimeout>
            <EndPointURL>
                <ServiceProviderCreation>/client-registration/v0.14/register</ServiceProviderCreation>
                <Application>/api/am/store/v0.14/applications</Application>
                <Token>/token</Token>
                <KeyGeneration>/api/am/store/v0.14/applications/generate-keys</KeyGeneration>
                <ApiSearch>/api/am/store/v0.14/apis</ApiSearch>
                <ApiSubscribe>/api/am/store/v0.14/subscriptions/multiple</ApiSubscribe>
            </EndPointURL>
            <EnableURIValidation>false</EnableURIValidation>
            <EnableHostNameValidation>false</EnableHostNameValidation>
            <APISubscriptions>
                <PISP>
                    <APIContext>/open-banking/v3.1/pisp</APIContext>
                    <APIContext>/open-banking/v3.0/pisp</APIContext>
                    <APIContext>/open-banking/v2.0/pisp</APIContext>
                </PISP>
                <AISP>
                    <APIContext>/open-banking/v3.1/aisp</APIContext>
                    <APIContext>/open-banking/v3.0/aisp</APIContext>
                    <APIContext>/open-banking/v2.0/aisp</APIContext>
                </AISP>
            </APISubscriptions>
            <UseSoftwareIdAsApplicationName>true</UseSoftwareIdAsApplicationName>
            <JwksUrlSandbox>https://keystore.openbankingtest.org.uk/keystore/openbanking.jwks</JwksUrlSandbox>
            <JwksUrlProduction>https://keystore.openbanking.org.uk/keystore/openbanking.jwks</JwksUrlProduction>
           </DCR>
        ```  
        **DCR v3.2**

        ```
        <DCR>
            <TokenAuthentication>
                <Method>private_key_jwt</Method>
                <Method>tls_client_auth</Method>
            </TokenAuthentication>
            <ConnectionTimeout>0</ConnectionTimeout>
            <ReadTimeout>0</ReadTimeout>
            <EnableURIValidation>false</EnableURIValidation>
            <EnableHostNameValidation>false</EnableHostNameValidation>
            <UseSoftwareIdAsApplicationName>true</UseSoftwareIdAsApplicationName>
            <JwksUrlSandbox>https://keystore.openbankingtest.org.uk/keystore/openbanking.jwks</JwksUrlSandbox>
            <JwksUrlProduction>https://keystore.openbanking.org.uk/keystore/openbanking.jwks</JwksUrlProduction>
        </DCR>
        ```

     2. Update the `<WSO2_OB_APIM_HOME>/repository/deployment/server/synapse-configs/default/sequences/<USERNAME>--DynamicClientRegistrationAPI_vv3.2--In.xml` file as follows: 
   
     - Replace `<header name="To" value="https://<WSO2_OB_APIM_HOST>:9443/ob-dynamic-client-registration"/>` property with the new `/dynamic-client-registration/common` endpoint.

       ```
       <header name="To" value="https://<WSO2_OB_APIM_HOST>:9443/dynamic-client-registration/common"/>
       ```
   
   3. Update the `ApplicationDeletion` executor value as follows. See [Dynamic Client Registration v3.2 - Configuring application deletion workflow](https://docs.wso2.com/display/OB150/Dynamic+Client+Registration+v3.2#DynamicClientRegistrationv3.2-Configuringapplicationdeletionworkflow), for more information.

       ```
       <ApplicationDeletion executor="com.wso2.finance.open.banking.application.deletion.workflow.impl.ApplicationDeletionWorkflow"/>
       ```

4. Go to the API Publisher (`https://<WSO2_OB_APIM_HOST>:9443/publisher`), add the following API properties to the already deployed APIs and republish them. For more information, see [Deploying APIs](https://docs.wso2.com/display/OB150/Deploying+APIs+for+UK#DeployingAPIsforUK-CreateandpublishanAPI)[for UK](https://docs.wso2.com/display/OB150/Deploying+APIs+for+UK#DeployingAPIsforUK-CreateandpublishanAPI).

   | API                                  | Property Name          | Property Value |
   |--------------------------------------|------------------------|----------------|
   | AccountInfo API v3.1.1               | `ob-spec`              | `uk`           |
   | AccountInfo API v3.1.1               | `ob-api-type`          | `account`      |
   | AccountInfo API v3.1.1               | `ob-api-version`       | `3.1.1`        |
   | Payments API v3.1.1                  | `ob-spec`              | `uk`           |
   | Payments API v3.1.1                  | `ob-api-type`          | `payment`      |
   | Payments API v3.1.1                  | `ob-api-version`       | `3.1.1`        |
   | Funds Confirmation API v3.1.1        | `ob-spec`              | `uk`           |
   | Funds Confirmation API v3.1.1        | `ob-api-type`          | `cof`          |
   | Funds Confirmation API v3.1.1        | `ob-api-version`       | `3.1.1`        |
   | Event Notifications API v3.1.0       | `ob-spec`              | `uk`           |
   | Event Notifications API v3.1.0       | `ob-api-type`          | `event`        |
   | Event Notifications API v3.1.0       | `ob-api-version`       | `3.1.0`        |
   | Dynamic Client Registration API v3.2 | `ob-spec`              | `uk`           |
   | Dynamic Client Registration API v3.2 | `ob-api-type`          | `dcr`          |
   | Dynamic Client Registration API v3.2 | `ob-api-version`       | `3.2`          |