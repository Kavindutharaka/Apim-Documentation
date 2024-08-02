# Map XML Configurations to TOML Configurations

WSO2 Open Banking 2.0.0 introduces a new simplified and centralized TOML-based configuration model instead of the several XML file module used in previous versions. This document explains how to map your XML configurations in Open Banking 1.5.0 to the latest TOML configurations.

The following components/modules now contain a `deployment.toml` in each. Unlike the previous versions, now we have to configure that single toml file to configure each component. Given below are the most common XML configurations in each component and the corresponding TOML configurations.

- Key Manager
- API Manager

# Key Manager

WSO2 Open Banking 2.0.0 refers to the Key Manager as the Identity and Access Management module. From this point onwards, let's refer to this root directory of this module as `WSO2_OB_IAM_HOME`.

This section explains the corresponding TOML configurations in the following files:

- `master-datasources.xml`
- `open-banking-datasources.xml`
- `carbon.xml`
- `application-authentication.xml`
- `identity.xml`
- `open-banking.xml`

## master-datasources.xml

<table>
  <tr>
   <td>
    Location of the XML file
   </td>
   <td>
    Location of the TOML file
   </td>
  </tr>
  <tr>
   <td>
    &lt;WSO2_OB_IAM_HOME>/repository/conf/datasources/master-datasources.xml
   </td>
   <td>
    &lt;WSO2_OB_IAM_HOME>/repository/conf/deployment.toml
   </td>
  </tr>
  <tr>
   <td>
    XML configuration
   </td>
   <td>
    TOML configuration
   </td>
  </tr>
  <tr>
   <td>
    Given below is a sample configuration for a datasource, refer to the XML/TOML files to see how to configure all the relevant datasources.

   ```
   <datasource>
       <name>WSO2_SHARED_DB</name>
       <description>Shared Database for user and registry data</description>
       <jndiConfig>
           <name>jdbc/SHARED_DB</name>
       </jndiConfig>
       <definition type="RDBMS">
           <configuration>
               <url>jdbc:mysql://<DATABASE_HOST>:3306/openbank_govdb?autoReconnect=true&useSSL=false</url>
               <username>root</username>
               <password>root</password>
               <driverClassName>com.mysql.jdbc.Driver</driverClassName>
               <validationQuery></validationQuery>
               <testOnBorrow>true</testOnBorrow>
               <minIdle>5</minIdle>
               <maxWait>60000</maxWait>
               <defaultAutoCommit>false</defaultAutoCommit>
               <validationQuery>SELECT 1</validationQuery>
               <validationInterval>30000</validationInterval>
               <maxActive>150</maxActive>
           </configuration>
       </definition>
   </datasource>
   ```

   </td>

   <td>

   ```
   # for registry data
   [database.shared_db]
   url = "jdbc:mysql://<DATABASE_HOST>:3306/openbank_govdbautoReconnect=true&useSSL=false"
   username = "root"
   password = "root"
   driver = "com.mysql.jdbc.Driver"
   
   [database.shared_db.pool_options]
   maxActive = "150"
   maxWait = "60000"
   minIdle ="5"
   testOnBorrow = true
   validationQuery="SELECT 1"
   #Use below for oracle
   #validationQuery="SELECT 1 FROM DUAL"
   validationInterval="30000"
   defaultAutoCommit=false
   ```

   </td>
  </tr>
</table>

## open-banking-datasources.xml

<table>
  <tr>
   <td>
    Location of the XML file
   </td>
   <td>
    Location of the TOML file
   </td>
  </tr>
  <tr>
   <td>
    &lt;WSO2_OB_IAM_HOME>/repository/conf/datasources/open-banking-datasources.xml
   </td>
   <td>
    &lt;WSO2_OB_IAM_HOME>/repository/conf/deployment.toml
   </td>
  </tr>
  <tr>
   <td>
    XML configuration
   </td>
   <td>
    TOML configuration
   </td>
  </tr>
  <tr>
   <td>

   ```
   <datasources>
       <datasource>
           <name>WSO2_OPEN_BANKING_DB</name>
           <description>The datasource used for open-banking data</description>
           <jndiConfig>
               <name>jdbc/WSO2OpenBankingDB</name>
           </jndiConfig>
           <definition type="RDBMS">
               <configuration>
                   <url>jdbc:mysql://<DATABASE_HOST>:3306/openbank_openbankingdb?autoReconnect=true&useSSL=false</url>
                   <username>root</username>
                   <password>root</password>
                   <driverClassName>com.mysql.jdbc.Driver</driverClassName>
                   <maxActive>150</maxActive>
                   <testOnBorrow>true</testOnBorrow>
                   <defaultAutoCommit>false</defaultAutoCommit>
                   <validationQuery>SELECT 1</validationQuery>
                   <maxWait>60000</maxWait>
                   <validationInterval>30000</validationInterval>
                   <minIdle>5</minIdle>
               </configuration>
           </definition>
       </datasource>
   </datasources>undefined</datasources-configuration>
   ```

   </td>
   <td>

   ```
   [open_banking_database]
   config.url = "jdbc:mysql://<DATABASE_HOST>:3306/openbank_openbankingdb?autoReconnect=true&useSSL=false"
   config.username = "root"
   config.password = "root"
   config.driver = "com.mysql.jdbc.Driver"
    
   [open_banking_database.config.pool_options]
   maxActive = "150"
   maxWait = "60000"
   minIdle ="5"
   testOnBorrow = true
   validationQuery="SELECT 1"
   #Use below for oracle
   #validationQuery="SELECT 1 FROM DUAL"
   validationInterval="30000"
   defaultAutoCommit=false
   ```

   </td>
  </tr>
</table>

## carbon.xml

<table>
  <tr>
   <td>
    Location of the XML file
   </td>
   <td>
    Location of the TOML file
   </td>
  </tr>
  <tr>
   <td>
    &lt;WSO2_OB_IAM_HOME>/repository/conf/carbon.xml
   </td>
   <td>
    &lt;WSO2_OB_IAM_HOME>/repository/conf/deployment.toml
   </td>
  </tr>
  <tr>
   <td>
    XML configuration
   </td>
   <td>
    TOML configuration
   </td>
  </tr>
  <tr>
   <td>
    Update the configurations with the hostname of your Open Banking Key Manager server/Identity and Access Management module.

   ```
   <HostName><WSO2_OB_IAM_HOST></HostName>
   <MgtHostName><WSO2_OB_IAM_HOST></MgtHostName>
   ```

   </td>
   <td>

   ```
   [server]
   hostname = "<WSO2_OB_IAM_HOST>"
   node_ip = "127.0.0.1"
   base_path = "https://$ref{server.hostname}:${carbon.management.port}"
   serverDetails = "WSO2 IS as KM 5.10.0"
   mode = "single"
   userAgent = "WSO2 IS as KM 5.10.0"
   offset = 3
   ```

   </td>
  </tr>
  <tr>
   <td>
    Update the configurations according to your Keystore.

   ```
   <KeyStore>
       <!-- Keystore file location-->
       <Location>
   ${carbon.home}/repository/resources/security/wso2carbon.jks
   </Location>
       <!-- Keystore type (JKS/PKCS12 etc.)-->
       <Type>JKS</Type>
       <!-- Keystore password-->
       <Password>wso2carbon</Password>
       <!-- Private Key alias-->
       <KeyAlias>wso2carbon</KeyAlias>
       <!-- Private Key password-->
       <KeyPassword>wso2carbon</KeyPassword>
   </KeyStore>
   ```

   </td>
   <td>

   ```
   [keystore.primary]
   name = "wso2carbon.jks"
   password = "wso2carbon"
   type = "JKS"
   alias = "wso2carbon"
   key_password = "wso2carbon"
   ```

   </td>
  </tr>
</table>

## application-authentication.xml

<table>
  <tr>
   <td>
    Location of the XML file
   </td>
   <td>
    Location of the TOML file
   </td>
  </tr>
  <tr>
   <td>
    &lt;WSO2_OB_IAM_HOME>/repository/conf/datasources/open-banking-datasources.xml
   </td>
   <td>
    &lt;WSO2_OB_IAM_HOME>/repository/conf/deployment.toml
   </td>
  </tr>
  <tr>
   <td>
    XML configuration
   </td>
   <td>
    TOML configuration
   </td>
  </tr>
  <tr>
   <td>
    Update the following with the URLs of the authentication web application, as shown below:

   ```
   <AuthenticationEndpointURL>
       https://<WSO2_OB_IAM_HOST>:9446/authenticationendpoint/login.do
   </AuthenticationEndpointURL>
    
   <AuthenticationEndpointRetryURL>
       https://<WSO2_OB_IAM_HOST>:9446/authenticationendpoint/retry.do
   </AuthenticationEndpointRetryURL>
   ```

   </td>
   <td>

   ```
   [authentication.endpoints]
   login_url = "https://<WSO2_OB_IAM_HOST>:9446/authenticationendpoint/login.do"
   retry_url = "https://<WSO2_OB_IAM_HOST>:9446/authenticationendpoint/retry.do"
   ```

   </td>
  </tr>
  <tr>
   <td>
    In the authentication web application, when the action is set to include, the defined parameters will be sent to the  `AuthenticationEndpoint`  as query parameters.

   **Note**

   If you're using a customized authentication web app, you can access the hidden parameters using the  sessionDataKeyConsent  parameter. For more information, see <a href="https://is.docs.wso2.com/en/5.10.0/develop/authentication-data-api/#authentication-data-api"> Authentication Data API</a>.

   ```
   <AuthenticationEndpointRedirectParams action="include" removeOnConsumeFromAPI="true">
           <AuthenticationEndpointRedirectParam name="sessionDataKeyConsent"/>
           <AuthenticationEndpointRedirectParam name="relyingParty"/>
           <AuthenticationEndpointRedirectParam name="authenticators"/>
           <AuthenticationEndpointRedirectParam name="authFailureMsg"/>
           <AuthenticationEndpointRedirectParam name="authFailure"/>
   </AuthenticationEndpointRedirectParams>
   ```

   </td>
   <td>

   ```
   [authentication.endpoint.redirect_params]
   filter_policy = "include"
   remove_on_consume_from_api = "true"
   parameters = ["sessionDataKeyConsent","relyingParty", "authenticators", "authFailureMsg", "authFailure"]
   ```

   </td>
  </tr>
</table>

## identity.xml

<table>
  <tr>
   <td>
    Location of the XML file
   </td>
   <td>
    Location of the TOML file
   </td>
  </tr>
  <tr>
   <td>
    &lt;WSO2_OB_IAM_HOME>/repository/conf/identity/identity.xml
   </td>
   <td>
    &lt;WSO2_OB_IAM_HOME>/repository/conf/deployment.toml
   </td>
  </tr>
  <tr>
   <td>
    XML configuration
   </td>
   <td>
    TOML configuration
   </td>
  </tr>
  <tr>
   <td>
    Update the following configurations with the hostname of the Open Banking API Manager Gateway.

   ```
   <OAuth2AuthzEPUrl>
       ${carbon.protocol}://<WSO2_OB_APIM_HOST>:8243/authorize
   </OAuth2AuthzEPUrl>    
   <OAuth2TokenEPUrl>
       ${carbon.protocol}://<WSO2_OB_APIM_HOST>:8243/token
   </OAuth2TokenEPUrl>
   <OAuth2UserInfoEPUrl>
       ${carbon.protocol}://<WSO2_OB_APIM_HOST>:8243/userinfo
   </OAuth2UserInfoEPUrl>
    
   <OAuth2DCREPUrl>
       ${carbon.protocol}://<WSO2_OB_APIM_HOST>:8243/register
   </OAuth2DCREPUrl>
   ```

   </td>
   <td>

   ```
   [oauth.endpoints]
   oauth2_authz_url = "${carbon.protocol}://<WSO2_OB_APIM_HOST>:8243/authorize"
   oauth2_token_url = "${carbon.protocol}://<WSO2_OB_APIM_HOST>:8243/token"
   oauth2_user_info_url = "${carbon.protocol}://<WSO2_OB_APIM_HOST>:8243/userinfo"
   oauth2_consent_page = "${carbon.protocol}://<WSO2_OB_APIM_HOST>:${carbon.management.port}/ob/authenticationendpoint/oauth2_authz.do"
   oidc_consent_page = "${carbon.protocol}://<WSO2_OB_APIM_HOST>:${carbon.management.port}/ob/authenticationendpoint/oauth2_consent.do"
   oauth2_dcr_url = "${carbon.protocol}://<WSO2_OB_APIM_HOST>:8243/register"
   ```

   </td>
  </tr>
  <tr>
   <td>

   ```
   <IDTokenIssuerID>https://<WSO2_OB_APIM_HOST>:8243/token</IDTokenIssuerID>
   ```

   </td>
   <td>

   ```
   [oauth.oidc]
   id_token.issuer = "https://<WSO2_OB_APIM_HOST>:8243/token"
   ```

   </td>
  </tr>
  <tr>
   <td>
    Update the following configurations with the hostname of your Open Banking Key Manager server (referred as the Identity and Access Management module now).

   ```
   <OAuth2ConsentPage>
       ${carbon.protocol}://<WSO2_OB_IAM_HOST>:${carbon.management.port}/ob/authenticationendpoint/oauth2_authz.do
   </OAuth2ConsentPage>
   <OAuth2ErrorPage>
       ${carbon.protocol}://<WSO2_OB_IAM_HOST>:${carbon.management.port}/authenticationendpoint/oauth2_error.do
   </OAuth2ErrorPage>
   <OIDCConsentPage>
       ${carbon.protocol}://<WSO2_OB_IAM_HOST>:${carbon.management.port}/ob/authenticationendpoint/oauth2_consent.do
   </OIDCConsentPage>
   <OIDCLogoutConsentPage>
       ${carbon.protocol}://<WSO2_OB_IAM_HOST>:${carbon.management.port}/authenticationendpoint/oauth2_logout_consent.do
   </OIDCLogoutConsentPage>
   <OIDCLogoutPage>
       ${carbon.protocol}://<WSO2_OB_IAM_HOST>:${carbon.management.port}/authenticationendpoint/oauth2_logout.do
   </OIDCLogoutPage>
   <OIDCWebFingerEPUrl>
       ${carbon.protocol}://<WSO2_OB_IAM_HOST>:${carbon.management.port}/.well-known/webfinger
   </OIDCWebFingerEPUrl>
     
   <OIDCDiscoveryEPUrl>
       ${carbon.protocol}://<WSO2_OB_IAM_HOST>:${carbon.management.port}/oauth2/oidcdiscovery
   </OIDCDiscoveryEPUrl>
   ```

   </td>
   <td>

   ```
   oauth2_consent_page = "${carbon.protocol}://<WSO2_OB_IAM_HOST>:${carbon.management.port}/ob/authenticationendpoint/oauth2_authz.do"
   oauth2_error_page = "https://<WSO2_OB_IAM_HOST>:${carbon.management.port}/authenticationendpoint/oauth2_error.do"
   oidc_consent_page = "${carbon.protocol}://<WSO2_OB_IAM_HOST>:${carbon.management.port}/ob/authenticationendpoint/oauth2_consent.do"
   oauth.endpoints.oauth2_error_page = "https://<WSO2_OB_IAM_HOST>:${carbon.management.port}/authenticationendpoint/oauth2_error.do"
   oidc_logout_consent_page = "https://<WSO2_OB_IAM_HOST>:${carbon.management.port}/authenticationendpoint/oauth2_logout_consent.do"
   oidc_web_finger_url = "https://<WSO2_OB_IAM_HOST>:${carbon.management.port}/.well-known/webfinger"
   oidc_discovery_url = "https://<WSO2_OB_IAM_HOST>:${carbon.management.port}/oauth2/oidcdiscovery"
   ```

   </td>
  </tr>
  <tr>
   <td>
    Configure the ReceiverURL of the  &lt;EventPublisher>  under  &lt;AdaptiveAuth>  with the hostname of the Open Banking Business Intelligence Server. By default, the relevant Siddhi Apps are configured to listen to port 8006.

   ```
   <ReceiverURL>http://<WSO2_OB_BI_HOST>:8006/</ReceiverURL>
   ```

   </td>
   <td>

   ```
   [authentication.adaptive.event_publisher]
   url = "http://<WSO2_OB_BI_HOST>:8006/"
   ```

   </td>
  </tr>
  <tr>
   <td>
   
   The ID Token Builder and the algorithm that signs the ID Token Builder are configurable.
   
   By default,  `<IDTokenBuilder>` is set to  `com.wso2.finance.open.banking.idtoken.builder.OBIDTokenBuilder`. For example, to sign the `<IDTokenBuilder>` with the `SHA256withRSA` algorithm the configurations are as follows:
   
   ```
   <IDTokenBuilder>com.wso2.finance.open.banking.idtoken.builder.OBIDTokenBuilder</IDTokenBuilder>
   <SignatureAlgorithm>SHA256withRSA</SignatureAlgorithm>
   ```

   </td>
   <td>

   ```
   [oauth.oidc]
   extensions.id_token_builder = "com.wso2.finance.open.banking.idtoken.builder.OBIDTokenBuilder"
   id_token.signature_algorithm
   ```

   </td>
  </tr>
</table>

## open-banking.xml

<table>
  <tr>
   <td>
    Location of the XML file
   </td>
   <td>
    Location of the TOML file
   </td>
  </tr>
  <tr>
   <td>
    &lt;WSO2_OB_IAM_HOME>/repository/conf/finance/open-banking.xml
   </td>
   <td>
    &lt;WSO2_OB_IAM_HOME>/repository/conf/deployment.toml
   </td>
  </tr>
  <tr>
   <td>
    XML configuration
   </td>
   <td>
    TOML configuration
   </td>
  </tr>
  <tr>
   <td>

   Define the specification that you plan to deploy.

   Possible values: UK, BERLIN, AU

   ```
   <DeployedSpecification>UK</DeployedSpecification>
   ```

   </td>
   <td>

   ```
   [open_banking]
   deployed_spec = "UK"
   ```

   </td>
  </tr>
  <tr>
   <td>
    Configuring bank backend:
<ul>

<li>&lt;SharableAccountsRetrieveEndpoint>: Configures the endpoint to retrieve sharable accounts that are listed on the consent page.

<li>&lt;PayableAccountsRetrieveEndpoint>: Configures the endpoint to retrieve accounts that the user can make payments with, which are listed on the consent page.

   ```
   <PayableAccountsRetrieveEndpoint>
       http://localhost:9763/api/openbanking/backend-uk/services/bankaccounts/bankaccountservice/payable-accounts
   </PayableAccountsRetrieveEndpoint>
   <SharableAccountsRetrieveEndpoint>
       http://localhost:9763/api/openbanking/backend-uk/services/bankaccounts/bankaccountservice/sharable-accounts
   </SharableAccountsRetrieveEndpoint>
   ```

</li>
</ul>
   </td>
   <td>

   ```
   [open_banking]
   payable_accounts_retrieve_endpoint = "http://localhost:9763/api/openbanking/backend-uk/services/bankaccounts/bankaccountservice/payable-accounts"
   sharable_accounts_retrieve_endpoint = "http://localhost:9763/api/openbanking/backend-uk/services/bankaccounts/bankaccountservice/sharable-accounts"
   ```

   </td>
  </tr>
  <tr>
   <td>
    
   To enable the Event Notification feature (for Open Banking UK):

   ```
   <EventNotifications>
       <IsEnabled>true</IsEnabled>
       <TokenIssuer>www.openbank.com</TokenIssuer>
       <NotificationAPIUrl>
           https://localhost:8243/open-banking/v3.1/event-notification
       </NotificationAPIUrl>
   </EventNotifications>
   ```

   </td>
   <td>

   ```
   [open_banking.event_notifications]
   enable = true
   token_issuer = "www.openbank.com"
   api_url = "https://localhost:8243/open-banking/v3.1/event-notification"
   ```

   </td>
  </tr>
  
  <tr>
   <td>
    
   To enable Request-URI validation during the account retrieval process; validate the account ID against the account ID in the consent (for Open Banking UK and Open Banking Australia)

   ```
   <ValidateAccountIdOnRetrieval>true</ValidateAccountIdOnRetrieval>
   ```

   </td>
   <td>

   ```
   [open_banking.account_id_validation_on_retrieval]
   enable = true
   ```

   </td>
  </tr>
  <tr>
   <td>
    For Open Banking UK - The unique ID of the bank to which the request is issued. The unique ID is issued by OBIE and corresponds to the Organization ID of the ASPSP in the Open Banking Directory. If the value does not match the expected value (based on the Client ID or network certificate of the caller), the bank must reject the request with a 403 (Forbidden) status code.

   ```
   <XFAPIFinancialId>open-bank</XFAPIFinancialId>
   ```

   </td>
   <td>

   ```
   [open_banking.uk]
   x_fapi_financial_id = "open-bank"
   ```

   </td>
  </tr>
  <tr>
   <td>
    For the Data Reporting feature, to enable data publishing set the  &lt;Enabled>  property value to true. So, the WSO2 Open Banking Business Intelligence can capture and summarize data. Replace the  &lt;WSO2_OB_BI_HOSTNAME>  placeholder with the hostname of Open Banking Business Intelligence server.

   ```
   <DataPublishing>
       <Enabled>true</Enabled>
       <ServerURL>{tcp://<WSO2_OB_BI_HOST>:7612}</ServerURL>
   </DataPublishing>
   ```
   
   </td>
   <td>

   ```
   [open_banking.bi_server.data_publishing]
   enable = true
   server_url = "{tcp://<WSO2_OB_BI_HOST>:7612}"
   ```

   </td>
  </tr>
  <tr>
   <td>
    To enable Transaction Risk Analysis:
<ul>

<li>Set the &lt;IsEnabled> property under &lt;TRA> to true.

<li>Replace the &lt;WSO2_OB_BI_HOST> place holder with the hostname of Open Banking Business Intelligence server.

<li>Use the &lt;AccountValidationEnabled> and &lt;PaymentValidationEnabled> properties to enable TRA for Accounts and Payments respectively.

   ```
   <TRA>
       <IsEnabled>true</IsEnabled>
       <PaymentValidationEnabled>true</PaymentValidationEnabled>
       <AccountValidationEnabled>true</AccountValidationEnabled>
       <Receivers>
           <TRAAccountValidationURL>http://<WSO2_OB_BI_HOST>:8007/TRAAccountValidationApp/TRAValidationStream</TRAAccountValidationURL>
           <TRAPaymentValidationURL>http://<WSO2_OB_BI_HOST>:8007/TRAPaymentValidationApp/TRAValidationStream</TRAPaymentValidationURL>
       </Receivers>
   </TRA>
   ```

</li>
</ul>
   </td>
   <td>

   ```
   [open_banking.bi_server.tra]
   enable = true
   payment_validation.enable = true
   account_validation.enable = true
    
   [open_banking.bi_server.tra.receivers]
   account_validation_url = "http://<WSO2_OB_BI_HOST>:8007/TRAAccountValidationApp/TRAValidationStream"
   payment_validation_url = "http://<WSO2_OB_BI_HOST>:8007/TRAPaymentValidationApp/TRAValidationStream"
   ```

   </td>
  </tr>
  <tr>
   <td>
    You can enable the Fraud Detection feature by setting the &lt;IsEnabled> value to true. Replace the &lt;WSO2_OB_BI_HOST> placeholder with the hostname of WSO2 Open Banking Business Intelligence server.

   ```
   <FraudDetection>
       <IsEnabled>false</IsEnabled>
       <Receivers>
           <FraudDetectionURL>
               http://<WSO2_OB_BI_HOST>:8007/FraudDetectionApp/FraudDetectionStream
           </FraudDetectionURL>
           <InvalidSubmissionURL>
               http://<WSO2_OB_BI_HOST>:8006/InvalidSubmissionsApp/InvalidSubmissionsStream
           </InvalidSubmissionURL>
       </Receivers>
   </FraudDetection>
   ```

   </td>
   <td>

   ```
   [open_banking.bi_server.fraud_detection]
   enable = false
    
   [open_banking.bi_server.fraud_detection.receivers]
   fraud_detection_url = "http://localhost:8007/FraudDetectionApp/FraudDetectionStream"
   invalid_submission_url = "http://localhost:8006/InvalidSubmissionsApp/InvalidSubmissionsStream"
   ```

   </td>
  </tr>
  <tr>
   <td>

   To enable MTLS token binding:

   ```
   <EnableMTLSTokenBinding>true</EnableMTLSTokenBinding>
   ```
   
   Now configure the client certificate header as follows: 
   
   ```
   <ClientAuthenticationHeader>x-wso2-mutual-auth-cert</ClientAuthenticationHeader>
   ```

   </td>
   <td>

   ```
   [open_banking.api_security]
   mtls_token_binding.enable = true
   ```
    
   ```
   [open_banking.cert_mgt]
   client_auth_header = "x-wso2-mutual-auth-cert"
   ```

   </td>
  </tr>
</table>

# API Manager

From this point onwards, the root directory of the API Management module is known as `WSO2_OB_APIM_HOME`.

This section explains the corresponding TOML configurations in the following files:

- `master-datasources.xml`
- `open-banking-datasources.xml`
- `carbon.xml`
- `api-manager.xml`
- `synapse-handlers.xml`
- `open-banking.xml`

## master-datasources.xml

<table>
  <tr>
   <td>
    Location of the XML file
   </td>
   <td>
    Location of the TOML file
   </td>
  </tr>
  <tr>
   <td>
    &lt;WSO2_OB_APIM_HOME>/repository/conf/datasources/master-datasources.xml
   </td>
   <td>
    &lt;WSO2_OB_APIM_HOME>/repository/conf/deployment.toml
   </td>
  </tr>
  <tr>
   <td>
    XML configuration
   </td>
   <td>
    TOML configuration
   </td>
  </tr>
  <tr>
   <td>
    Given below is a sample configuration for a datasource, refer to the XML/TOML files to see how to configure all the relevant datasources.

   ```
   <datasource>
       <name>WSO2_SHARED_DB</name>
       <description>Shared Database for user and registry data</description>
       <jndiConfig>
           <name>jdbc/SHARED_DB</name>
       </jndiConfig>
       <definition type="RDBMS">
           <configuration>
               <url>
   jdbc:mysql://<DATABASE_HOST>:3306/openbank_govdb?autoReconnect=true&useSSL=false
   </url>
               <username>root</username>
               <password>root</password>
               <driverClassName>com.mysql.jdbc.Driver</driverClassName>
               <validationQuery/>
               <testOnBorrow>true</testOnBorrow>
               <minIdle>5</minIdle>
               <maxWait>60000</maxWait>
               <defaultAutoCommit>false</defaultAutoCommit>
               <validationQuery>SELECT 1</validationQuery>
               <validationInterval>30000</validationInterval>
               <maxActive>150</maxActive>
           </configuration>
       </definition>
   </datasource>
   ```

   </td>
   <td>

   ```
   # for registry data
   [database.shared_db]
   url = "jdbc:mysql://<DATABASE_HOST>:3306/openbank_govdb?autoReconnect=true&useSSL=false"
   username = "root"
   password = "root"
   driver = "com.mysql.jdbc.Driver"
    
   [database.shared_db.pool_options]
   maxActive = "150"
   maxWait = "60000"
   minIdle ="5"
   testOnBorrow = true
   validationQuery="SELECT 1"
   #Use below for oracle
   #validationQuery="SELECT 1 FROM DUAL"
   validationInterval="30000"
   defaultAutoCommit=false
   ```

   </td>
  </tr>
</table>

## open-banking-datasources.xml

<table>
  <tr>
   <td>
    Location of the XML file
   </td>
   <td>
    Location of the TOML file
   </td>
  </tr>
  <tr>
   <td>
    &lt;WSO2_OB_APIM_HOME>/repository/conf/api-manager.xml
   </td>
   <td>
    &lt;WSO2_OB_APM_HOME>/repository/conf/deployment.toml
   </td>
  </tr>
  <tr>
   <td>
    XML configuration
   </td>
   <td>
    TOML configuration
   </td>
  </tr>
  <tr>
   <td>

   ```
   <datasources>
       <datasource>
           <name>WSO2_OPEN_BANKING_DB</name>
           <description>The datasource used for open-banking data</description>
           <jndiConfig>
               <name>jdbc/WSO2OpenBankingDB</name>
           </jndiConfig>
           <definition type="RDBMS">
               <configuration>
                   <url>jdbc:mysql://<DATABASE_HOST>:3306/openbank_openbankingdb?autoReconnect=true&useSSL=false</url>
                   <username>root</username>
                   <password>root</password>
                   <driverClassName>com.mysql.jdbc.Driver</driverClassName>
                   <maxActive>150</maxActive>
                   <testOnBorrow>true</testOnBorrow>
                   <defaultAutoCommit>false</defaultAutoCommit>
                   <validationQuery>SELECT 1</validationQuery>
                   <maxWait>60000</maxWait>
                   <validationInterval>30000</validationInterval>
                   <minIdle>5</minIdle>
               </configuration>
           </definition>
       </datasource>
   </datasources>undefined</datasources-configuration>
   ```

   </td>
   <td>

   ```
   [open_banking_database]
   config.url = "jdbc:mysql://<DATABASE_HOST>:3306/openbank_openbankingdb?autoReconnect=true&useSSL=false"
   config.username = "root"
   config.password = "root"
   config.driver = "com.mysql.jdbc.Driver"
    
   [open_banking_database.config.pool_options]
   maxActive = "150"
   maxWait = "60000"
   minIdle ="5"
   testOnBorrow = true
   validationQuery="SELECT 1"
   #Use below for oracle
   #validationQuery="SELECT 1 FROM DUAL"
   validationInterval="30000"
   defaultAutoCommit=false
   ```

   </td>
  </tr>
</table>

## carbon.xml

<table>
  <tr>
   <td>
    Location of the XML file
   </td>
   <td>
    Location of the TOML file
   </td>
  </tr>
  <tr>
   <td>
    &lt;WSO2_OB_APIM_HOME>/repository/conf/carbon.xml
   </td>
   <td>
    &lt;WSO2_OB_APIM_HOME>/repository/conf/deployment.toml
   </td>
  </tr>
  <tr>
   <td>
    XML configuration
   </td>
   <td>
    TOML configuration
   </td>
  </tr>
  <tr>
   <td>
    Update the configurations with the hostname of your Open Banking Key Manager server/Identity and Access Management module.

   ```
   <HostName><WSO2_OB_APIM_HOST></HostName>
   <MgtHostName><WSO2_OB_APIM_HOST></MgtHostName>
   ```
   </td>
   <td>

   ```
   [server]
   hostname = "<WSO2_OB_APIM_HOST>"
   ```

   </td>
  </tr>
  <tr>
   <td>
    Update the configurations according to your Keystore.

   ```
   <KeyStore>
       <!-- Keystore file location-->
       <Location>
   ${carbon.home}/repository/resources/security/wso2carbon.jks
   </Location>
       <!-- Keystore type (JKS/PKCS12 etc.)-->
       <Type>JKS</Type>
       <!-- Keystore password-->
       <Password>wso2carbon</Password>
       <!-- Private Key alias-->
       <KeyAlias>wso2carbon</KeyAlias>
       <!-- Private Key password-->
       <KeyPassword>wso2carbon</KeyPassword>
   </KeyStore>
   ```

   </td>
   <td>

   ```
   [keystore.primary]
   name = "wso2carbon.jks"
   password = "wso2carbon"
   type = "JKS"
   alias = "wso2carbon"
   key_password = "wso2carbon"
   ```

   </td>
  </tr>
</table>

## api-manager.xml

<table>
  <tr>
   <td>
    Location of the XML file
   </td>
   <td>
    Location of the TOML file
   </td>
  </tr>
  <tr>
   <td>
    &lt;WSO2_OB_APIM_HOME>/repository/conf/api-manager.xml
   </td>
   <td>
    &lt;WSO2_OB_APIM_HOME>/repository/conf/deployment.toml
   </td>
  </tr>
  <tr>
   <td>
    XML configuration
   </td>
   <td>
    TOML configuration
   </td>
  </tr>
  <tr>
   <td>
    Update the following configurations according to the given placeholder.

   ```
   <AuthManager>
       <!-- Server URL of the Authentication service -->
       <ServerURL>
           https://<WSO2_OB_IAM_HOST>:${mgt.transport.https.port}${carbon.context}services/
       </ServerURL>
   ```

   </td>
   <td>

   ```
   [apim.key_manager]
   service_url = "https://<WSO2_OB_IAM_HOST>:9446${carbon.context}services/"
   ```

   </td>
  </tr>
  <tr>
   <td>

   ```
   <GatewayEndpoint>
       http://<WSO2_OB_APIM_HOST>:${http.nio.port},https://<WSO2_OB_APIM_HOST>:${https.nio.port}
   </GatewayEndpoint>
   ```

   </td>
   <td>

   ```
   http_endpoint = "http://<WSO2_OB_APIM_HOST>:${http.nio.port}"
   ```

   </td>
  </tr>
  <tr>
   <td>
    
   To configure Analytics for the API Management module:

   ```
   <Analytics>
       <Enabled>true</Enabled>
       <StreamProcessorServerURL>{tcp://localhost:7612}</StreamProcessorServerURL>
   ```

   </td>
   <td>

   ```
   [apim.analytics]
   enable = true
   receiver_urls = "{tcp://<WSO2_OB_BI_HOST>:7612}"
   ```

   </td>
  </tr>
</table>

## synapse-handlers.xml

<table>
  <tr>
   <td>
    Location of the XML file
   </td>
   <td>
    Location of the TOML file
   </td>
  </tr>
  <tr>
   <td>
    &lt;WSO2_OB_APIM_HOME>/repository/conf/synapse-handlers.xml
   </td>
   <td>
    &lt;WSO2_OB_APIM_HOME>/repository/conf/deployment.toml
   </td>
  </tr>
  <tr>
   <td>
    XML configuration
   </td>
   <td>
    TOML configuration
   </td>
  </tr>
  <tr>
   <td>

   ```
   <handler name = "UkJwsResponseSignatureHandler" class="com.wso2.finance.open.banking.gateway.jws.UkJwsResponseSignatureHandler"></handler>
   ```

   </td>
   <td>

   Following configuration must be added to the top of the &lt;WSO2_OB_APIM_HOME>/repository/conf/deployment.toml file:

   ```
   enabled_global_handlers= ["jws", "externalCallLogger", "open_tracing"]
   [synapse_handlers.jws]
   name= "jws"
   class= "com.wso2.finance.open.banking.gateway.jws.UkJwsResponseSignatureHandler"
    
   [synapse_handlers.externalCallLogger]
   name= "externalCallLogger"
   class= "org.wso2.carbon.apimgt.gateway.handlers.LogsHandler"
    
   [synapse_handlers.open_tracing]
   name= "open_tracing"
   class= "org.wso2.carbon.apimgt.gateway.handlers.common.APIMgtLatencySynapseHandler"
   ```

   </td>
  </tr>
</table>

## open-banking.xml

<table>
  <tr>
   <td>
    Location of the XML file
   </td>
   <td>
    Location of the TOML file
   </td>
  </tr>
  <tr>
   <td>
    &lt;WSO2_OB_APIM_HOME>/repository/conf/finance/open-banking.xml
   </td>
   <td>
    &lt;WSO2_OB_APIM_HOME>/repository/conf/deployment.toml
   </td>
  </tr>
  <tr>
   <td>
    XML configuration
   </td>
   <td>
    TOML configuration
   </td>
  </tr>
  <tr>
   <td>
   Define the specification that you plan to deploy.

   Possible values:   UK, BERLIN, AU

   ```
   <DeployedSpecification>UK</DeployedSpecification>
   ```

   </td>
   <td>

   ```
   [open_banking]
   deployed_spec = "UK"
   ```

   </td>
  </tr>
  <tr>
   <td>
    Configuring bank backend:
<ul>

<li>&lt;SharableAccountsRetrieveEndpoint>: Configures the endpoint to retrieve sharable accounts that are listed on the consent page.

<li>&lt;PayableAccountsRetrieveEndpoint>: Configures the endpoint to retrieve accounts that the user can make payments with, which are listed on the consent page.

   ```
   <PayableAccountsRetrieveEndpoint>
       http://localhost:9763/api/openbanking/backend-uk/services/bankaccounts/bankaccountservice/payable-accounts
   </PayableAccountsRetrieveEndpoint>
   <SharableAccountsRetrieveEndpoint>
       http://localhost:9763/api/openbanking/backend-uk/services/bankaccounts/bankaccountservice/sharable-accounts
   </SharableAccountsRetrieveEndpoint>
   ```

</li>
</ul>
   </td>
   <td>

   ```
   [open_banking]
   payable_accounts_retrieve_endpoint = "http://localhost:9763/api/openbanking/backend-uk/services/bankaccounts/bankaccountservice/payable-accounts"
   sharable_accounts_retrieve_endpoint = "http://localhost:9763/api/openbanking/backend-uk/services/bankaccounts/bankaccountservice/sharable-accounts"
   ```

   </td>
  </tr>
  <tr>
   <td>
    To enable the Event Notification feature (for Open Banking UK):

   ```
   <EventNotifications>
       <IsEnabled>true</IsEnabled>
       <TokenIssuer>www.openbank.com</TokenIssuer>
       <NotificationAPIUrl>
           https://localhost:8243/open-banking/v3.1/event-notification
       </NotificationAPIUrl>
   </EventNotifications>
   ```

   </td>
   <td>

   ```
   [open_banking.event_notifications]
   enable = true
   token_issuer = "www.openbank.com"
   api_url = "https://localhost:8243/open-banking/v3.1/event-notification"
   ```

   </td>
  </tr>
  <tr>
   <td>
    To enable Request-URI validation during the account retrieval process; validate the account ID against the account ID in the consent (for Open Banking UK and Open Banking Australia)

   ```
   <ValidateAccountIdOnRetrieval>true</ValidateAccountIdOnRetrieval>
   ```

   </td>
   <td>

   ```
   [open_banking.account_id_validation_on_retrieval]
   enable = true
   ```

   </td>
  </tr>
  <tr>
   <td>
    
   For Open Banking UK - The unique ID of the bank to which the request is issued. The unique ID is issued by OBIE and corresponds to the Organization ID of the ASPSP in the Open Banking Directory. If the value does not match the expected value (based on the Client ID or network certificate of the caller), the bank must reject the request with a 403 (Forbidden) status code.

   ```
   <XFAPIFinancialId>open-bank</XFAPIFinancialId>
   ```

   </td>
   <td>

   ```
   [open_banking.uk]
   x_fapi_financial_id = "open-bank"
   ```

   </td>
  </tr>
  <tr>
   <td>
    
   For the Data Reporting feature, to enable data publishing set the  &lt;Enabled>  property value to true. So, the WSO2 Open Banking Business Intelligence can capture and summarize data. Replace the  &lt;WSO2_OB_BI_HOSTNAME>  placeholder with the hostname of Open Banking Business Intelligence server.

   ```
   <DataPublishing>
       <Enabled>true</Enabled>
       <ServerURL>{tcp://<WSO2_OB_BI_HOST>:7612}</ServerURL>
   </DataPublishing>
   ```

   </td>
   <td>

   ```
   [open_banking.bi_server.data_publishing]
   enable = true
   server_url = "{tcp://<WSO2_OB_BI_HOST>:7612}"
   ```

   </td>
  </tr>
  <tr>
   <td>
    
   To enable Transaction Risk Analysis:

<ul>

<li>Set the &lt;IsEnabled> property under &lt;TRA> to true.

<li>Replace the &lt;WSO2_OB_BI_HOST> place holder with the hostname of Open Banking Business Intelligence server.

<li>Use the &lt;AccountValidationEnabled> and &lt;PaymentValidationEnabled> properties to enable TRA for Accounts and Payments respectively.

   ```
   <TRA>
       <IsEnabled>true</IsEnabled>
       <PaymentValidationEnabled>true</PaymentValidationEnabled>
       <AccountValidationEnabled>true</AccountValidationEnabled>
       <Receivers>
           <TRAAccountValidationURL>http://<WSO2_OB_BI_HOST>:8007/TRAAccountValidationApp/TRAValidationStream</TRAAccountValidationURL>
           <TRAPaymentValidationURL>http://<WSO2_OB_BI_HOST>:8007/TRAPaymentValidationApp/TRAValidationStream</TRAPaymentValidationURL>
       </Receivers>
   </TRA>
   ```

</li>
</ul>
   </td>
   <td>
   
   ```
   [open_banking.bi_server.tra]
   enable = true
   payment_validation.enable = true
   account_validation.enable = true
    
   [open_banking.bi_server.tra.receivers]
   account_validation_url = "http://<WSO2_OB_BI_HOST>:8007/TRAAccountValidationApp/TRAValidationStream"
   payment_validation_url = "http://<WSO2_OB_BI_HOST>:8007/TRAPaymentValidationApp/TRAValidationStream"
   ```
   
   </td>
  </tr>
  <tr>
   <td>
    You can enable the Fraud Detection feature by setting the &lt;IsEnabled> value to true. Replace the &lt;WSO2_OB_BI_HOST> placeholder with the hostname of WSO2 Open Banking Business Intelligence server.

   ```
   <FraudDetection>
       <IsEnabled>false</IsEnabled>
       <Receivers>
           <FraudDetectionURL>
               http://<WSO2_OB_BI_HOST>:8007/FraudDetectionApp/FraudDetectionStream
           </FraudDetectionURL>
           <InvalidSubmissionURL>
               http://<WSO2_OB_BI_HOST>:8006/InvalidSubmissionsApp/InvalidSubmissionsStream
           </InvalidSubmissionURL>
       </Receivers>
   </FraudDetection>
   ```

   </td>
   <td>

   ```
   [open_banking.bi_server.fraud_detection]
   enable = false
    
   [open_banking.bi_server.fraud_detection.receivers]
   fraud_detection_url = "http://localhost:8007/FraudDetectionApp/FraudDetectionStream"
   invalid_submission_url = "http://localhost:8006/InvalidSubmissionsApp/InvalidSubmissionsStream"
   ```

   </td>
  </tr>
  <tr>
   <td>
    To enable MTLS token binding:

   ```
   <EnableMTLSTokenBinding>true</EnableMTLSTokenBinding>
   ```

Now configure the client certificate header as follows: 

   ```
   <ClientAuthenticationHeader>x-wso2-mutual-auth-cert</ClientAuthenticationHeader>
   ```

   </td>
   <td>

   ```
   [open_banking.api_security]
   mtls_token_binding.enable = true
   ```

   ```
   [open_banking.cert_mgt]
   client_auth_header = "x-wso2-mutual-auth-cert"
   ```

   </td>
  </tr>
  <tr>
   <td>
    
   By default, the signing configuration is set to false. In order to change the value, configure as follows:

   ```
   <SigningConfiguration>
              <!-- Enable Response Signing -->
              <Enable>true</Enable>
              <OBIE>
                  <!--
                      Trusted Anchor Configuration
                  -->
                  <TrustedAnchors>
                      <!-- Domain name that is registered to and identifies the Trust Anchor that hosts the public counter-part of the key used for signing the response. Included in the claim http://openbanking.org.uk/tan -->
                      <Signing>openbanking.org.uk</Signing>
                      <!--
                     Trusted domain names that are registered to and identifies the Trust Anchor that hosts the public counter-part of the key used for request signing by the TPP. The value included in the claim http://openbanking.org.uk/tan of the TPP's JOSE header will be validated against the following list of domain names.
                          Multiple values supported with `|` delimiter
                          IE - trustanchor.org|trustanchor.org.uk
                      -->
                      <Validation>openbanking.org.uk</Validation>
                  </TrustedAnchors>
                  <!-- Organization Id of the ASPSP. This value is used as the http://openbanking.org.uk/iss claim during response signing -->
                  <OrganizationId>ABC1234</OrganizationId>
              </OBIE>
              <!-- Default Singing Algorithm is PS256, to support others uncomment line below -->
              <!--<Algorithm>RS256</Algorithm>-->
    
              <!-- By default the UK specification mandates the Payment and Even Notification APIs to have request/response message signing. Hence, the following specified APIs will be mandated for message signing. -->
              <MandatedAPIs>
                  <APIContext>/open-banking/v3.0/event-notification/</APIContext>
                  <APIContext>/open-banking/v3.0/pisp/</APIContext>
                  <APIContext>/open-banking/v3.1/event-notification/</APIContext>
                  <APIContext>/open-banking/v3.1/pisp/</APIContext>
              </MandatedAPIs>
    
   <!-- The following specified APIs will be associated with response signing. -->
              <ResponseSignatureRequiredAPIs>
                  <APIContext>/open-banking/v3.0/pisp/</APIContext>
                  <APIContext>/open-banking/v3.1/pisp/</APIContext>
              </ResponseSignatureRequiredAPIs>
          </SigningConfiguration>
   ```

   </td>
   <td>

   ```
   [open_banking.uk.signing_config]
   #Enable Response Signing
   enable = true
    
   #Domain name that is registered to and identifies the Trust Anchor that hosts the public counter-part of the key used for signing the response.
   #Included in the claim http://openbanking.org.uk/tan
   obie.trusted_anchors.signing = "openbanking.org.uk"
    
   #Trusted domain names that are registered to and identifies the Trust Anchor that hosts the public counter-part of the key used for request signing by the TPP.
   #The value included in the claim http://openbanking.org.uk/tan of the TPP's JOSE header will be validated against the following list of domain names.
                        ##  Multiple values supported with `|` delimiter
                        ##  IE - trustanchor.org|trustanchor.org.uk
   obie.trusted_anchors.validation = "openbanking.org.uk"
    
   #Organization Id of the ASPSP. This value is used as the http://openbanking.org.uk/iss claim during response signing
   obie.org_id = "ABC1234"
   ```

   </td>
  </tr>
</table>

For more information on configuring the `deployment.toml`, see the following topics:

- [Configuring WSO2 Open Banking for UK](https://docs.wso2.com/display/OB200/Configuring+WSO2+Open+Banking+for+UK)
- [Configuring WSO2 Open Banking for Berlin](https://docs.wso2.com/display/OB200/Configuring+WSO2+Open+Banking+for+Berlin)
- [Configuring WSO2 Open Banking for Australia](https://docs.wso2.com/display/OB200/Configuring+WSO2+Open+Banking+for+Australia)