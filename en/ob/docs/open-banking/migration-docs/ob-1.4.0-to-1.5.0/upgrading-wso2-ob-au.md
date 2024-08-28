# WSO2 Open Banking AU (Upgrading from v1.0.0 to v1.2.0)

1. Run the relevant database script in the `<WSO2_OB_KM_HOME>/dbscripts/finance/openbanking.org.uk/migration-1.4.0_to_1.5.0` directory against the `openbank_openbankingdb` database.

2. Add the following configurations to the open-banking.xml files, under the `<Server>` tag. The `open-banking.xml` files are in the below locations:

- `<WSO2_OB_KM_HOME>/repository/conf/finance/open-banking.xml`
- `<WSO2_OB_APIM_HOME>/repository/conf/finance/open-banking.xml`

These configurations are for:

- [Metadata Cache Management](https://docs.wso2.com/display/OB150/Metadata+Cache+Management)
- [Enable extended endpoints and holder specific versioning](https://docs.wso2.com/display/OB150/Deploying+APIs+for+AU#DeployingAPIsforAU-Enableextendedendpointsandholderspecificversioning)
- Cache the responses received for the Consumer Data Standards API requests

  ```
  <AU>
      <MetaDataCache>
          <EnableMetaDataCache>true</EnableMetaDataCache>
          <MetaDataCacheUpdatePeriod>5</MetaDataCacheUpdatePeriod>
          <DefaultCacheTimeout>1</DefaultCacheTimeout>
          <DataRecipientsDiscoveryURL>DR_DISCOVERY_MOCK_URL</DataRecipientsDiscoveryURL>
          <SoftwareProductsDiscoveryURL>SP_DISCOVERY_MOCK_URL</SoftwareProductsDiscoveryURL>
          <DCRInternalURL>https://
              <WSO2_OB_APIM_HOST>:9443/dynamic-client-registration/common/register/
              </DCRInternalURL>
          </MetaDataCache>
          <ResourcePaths>
              /banking/accounts,
              /banking/accounts/balances,
              /banking/accounts/direct-debits,
              /banking/accounts/{AccountId}/balance,
              /banking/accounts/{AccountId},
              /banking/accounts/{AccountId}/transactions,
              /banking/accounts/{AccountId}/transactions/{transactionId},
              /banking/accounts/{AccountId}/direct-debits,
              /banking/accounts/{AccountId}/payments/scheduled,
              /banking/payments/scheduled,
              /banking/payees,
              /banking/payees/{payeeId},
              /banking/products,
              /banking/products/{productId},
              /common/customer,
              /common/customer/detail,
              /discovery/status,
              /discovery/outages
          </ResourcePaths>
          <HolderIdentifier>
              <!--configure bank specific identifier-->
          </HolderIdentifier>
          <Enforcement>
              <Cache>
                  <CacheEnabled>true</CacheEnabled>
                  <ModifiedExpiryMinutes>15</ModifiedExpiryMinutes>
                  <AccessedExpiryMinutes>15</AccessedExpiryMinutes>
              </Cache>
          </Enforcement>
  </AU>
  ```
  
3. Add the following configurations for Dynamic Client Registration under `<Server>` tag and update them accordingly. Remove any DCR configurations within the `<UK>` tags.

   ```
   <DCR>
       <TokenAuthentication>
           <Method>private_key_jwt</Method>
           <Method>tls_client_auth</Method>
       </TokenAuthentication>
       <ConnectionTimeout>0</ConnectionTimeout>
       <ReadTimeout>0</ReadTimeout>
       <!--The endpoint urls are to access the rest APIs of API manager in order to
           create the application, service provider and generate keys for the application.
            -->
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
       <!-- Use SoftwareID in SSA as Application Name-->
       <UseSoftwareIdAsApplicationName>false</UseSoftwareIdAsApplicationName>
   </DCR>
   ```
   
4. Go to the API Publisher (`https://<WSO2_OB_APIM_HOST>:9443/publisher`), add the following API properties to the already deployed APIs and republish them. For more information, see [Deploying APIs for AU](https://docs.wso2.com/display/OB150/Deploying+APIs+for+AU).

| API                                                | Property Name  | Property Value  |
|----------------------------------------------------|----------------|-----------------|
| Consumer Data Standards API v1.2.0                 | `ob-spec`      | `au`            |
| Consumer Data Standards API v1.2.0                 | `ob-api-type`  | `account`       |
| Consumer Data Standards Administration API v1.2.0  | N/A            | N/A             |
| Dynamic Client Registration API v0.1               | `ob-spec`      | `au`            |
| Dynamic Client Registration API v0.1               | `ob-api-type`  | `dcr`           |