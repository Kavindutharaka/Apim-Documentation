# Configuration Changes - WSO2 IS 5.1.0 to 5.2.0

Listed below are the configuration and behavioral changes from WSO2 IS version 5.1.0 to 5.2.0.

- [Behavioral changes](#behavioral-changes)
- [Configuration changes](#configuration-changes)
- [Recommendations](#recommended)

## Bahavioral changes

Due to a fix done in this release, the effective default value of the system property org.apache.xml.security.ignoreLineBreaks has been changed from “true” to “false”. Due to this change, you will observe line breaks in SAML responses.

However, if the SAML response consuming client applications have used a standard library such as OpenSAML and use canonicalization when processing the response, this should not cause any problems. Therefore, our recommendation is to use a standard library to process SAML responses on consuming applications.

If you have any concerns about this behavioral change or if the SAML response consuming client applications does not use canonicalization when processing the response and the client cannot be updated to do so, add the following jvm parameter to the server startup script located in the `<IS_HOME>/bin/` folder to revert back to the previous behavior.

```
-Dorg.apache.xml.security.ignoreLineBreaks=true
```

## Configuration changes

Listed below are the configuration changes from WSO2 IS version 5.1.0 to 5.2.0.

### `oidc-scope-config.xml` file 

Stored in the <PRODUCT_HOME>/repository/conf/identity/ directory.

The following configuration file was added to enable grouping claims that are bound to a scope value in OpenID Connect (OIDC). When requesting for an OIDC token, you can specify a scope value that is bound to a set of claims in the oidc-scope-config.xml file. When sending that OIDC token to the userinfo endpoint, only the claims that are common to both the oidc-scope-config and the service provider claim configuration, will be returned.

### `identity-mgt.properties` file

Stored in the <PRODUCT_HOME>/repository/conf/identity/ directory.

-   The following parameters were added:

    ```
    # Whether to use hash of username when storing codes.
    # Enable this if Registry is used to store the codes and if username may contain non alphanumeric characters.
    
    UserInfoRecovery.UseHashedUserNames=false
    UserInfoRecovery.UsernameHashAlg=SHA-1
    ```

    If you have enabled the [using email address as the username](https://docs.wso2.com/display/IS520/Using+Email+Address+as+the+Username) option, the confirmation codes are retained after they are used, due to the special character '@' contained in the email address. To resolve this, you can set the UserInfoRecovery.UseHashedUserNames parameter to true so that the registry resources will be saved by hash of username instead of the email address username which contains the '@' sign.

-   The following properties were added to support notification sending for account enabling and disabling:

    ```
    Notification.Sending.Enable.Account.Disable=false
    Notification.Sending.Enable.Account.Enable=false
    ```

    For more information, see [User Account Locking and Account Disabling](https://docs.wso2.com/display/IS520/User+Account+Locking+and+Account+Disabling).

    The following property was added to check if the account has been locked, at the point of authentication.

    ```
    Authentication.Policy.Check.Account.Disable=false
    ```

### `EndpointConfig.properties` file

Stored in the <PRODUCT_HOME>/repository/conf/identity/ directory.

The following properties were replaced:

**Old configuration**

```
identity.server.host=localhost
identity.server.port=9443
identity.server.serviceURL=/services/
```

The properties above were replaced with the following:

**New configuration**

```
#identity.server.serviceURL=https://localhost:9443/services/ 
```

### `entitlement.properties` file

Stored in the <PRODUCT_HOME>/repository/conf/identity/ directory.

When policy sets are used with entitlements, the default policy set cache size is 100. This may cause frequent cache eviction if there are more than 100 policies in the set. To avoid this, configure the following property. It will cause the cache size to increase depending on the policy set size for better performance.

```
PDP.References.MaxPolicyEntries=3000
```

### `identity.xml` file

Stored in the <PRODUCT_HOME>/repository/conf/identity/ directory.

-   Session data persistence is enabled by default from IS 5.2.0 onwards.

    ```
    <SessionDataPersist>
        <Enable>true</Enable>
        <Temporary>true</Temporary>
        <PoolSize>0</PoolSize>
        <SessionDataCleanUp>
            <Enable>true</Enable>
            <CleanUpTimeout>20160</CleanUpTimeout>
            <CleanUpPeriod>1140</CleanUpPeriod>
        </SessionDataCleanUp>
        <OperationDataCleanUp>
            <Enable>true</Enable>
            <CleanUpPeriod>720</CleanUpPeriod>
        </OperationDataCleanUp>
    </SessionDataPersist>
    ```

    The following properties were removed:

    ```
    <!--SessionContextCache>
        <Enable>true</Enable>
        <Capacity>100000</Capacity>
    </SessionContextCache-->
    ```

-   The following property was added to the `<SSOService>` and `<PassiveSTS>` elements:

    ```
    <SLOHostNameVerificationEnabled>true</SLOHostNameVerificationEnabled>
    ```

    For more information on configuring hostname verification, see the info note at the bottom of the [Configuring WS-Federation](https://docs.wso2.com/display/IS520/Configuring+WS-Federation) page.

-   Listeners and properties related to analytics in WSO2 Identity Server were added. For more information, see [Prerequisites to Publish Statistics](https://docs.wso2.com/display/IS520/Prerequisites+to+Publish+Statistics).

    **Listeners**

    ```
    <EventListener type="org.wso2.carbon.identity.core.handler.AbstractIdentityMessageHandler" name="org.wso2.carbon.identity.data.publisher.application.authentication.impl.DASLoginDataPublisherImpl" orderId="10" enable="false" />
    <EventListener type="org.wso2.carbon.identity.core.handler.AbstractIdentityMessageHandler" name="org.wso2.carbon.identity.data.publisher.application.authentication.impl.DASSessionDataPublisherImpl" orderId="11" enable="false" />
    <EventListener type="org.wso2.carbon.identity.core.handler.AbstractIdentityMessageHandler" name="org.wso2.carbon.identity.data.publisher.application.authentication.AuthnDataPublisherProxy" orderId="11" enable="true" />
    ```

    **Properties**

    ```
    <ISAnalytics>
            <DefaultValues>
                <userName>NOT_AVAILABLE</userName>
                <userStoreDomain>NOT_AVAILABLE</userStoreDomain>
                <rolesCommaSeperated>NOT_AVAILABLE</rolesCommaSeperated>
                <serviceprovider>NOT_AVAILABLE</serviceprovider>
                <identityProvider>NOT_AVAILABLE</identityProvider>
            </DefaultValues>
        </ISAnalytics>
    ```  

-   The security element was updated:

    ```
    <!-- Security configurations-->
    <Security>
        <!-- The directory under which all other KeyStore files will be stored-->
        <KeyStoresDir>${carbon.home}/conf/keystores</KeyStoresDir>
        <KeyManagerType>SunX509</KeyManagerType>
        <TrustManagerType>SunX509</TrustManagerType>
    </Security>
    ```

-   The following elements were added under the `<OAuth>` element:

    ```
    <OIDCCheckSessionEPUrl>${carbon.protocol}://${carbon.host}:${carbon.management.port}/oidc/checksession</OIDCCheckSessionEPUrl>
    <OIDCLogoutEPUrl>${carbon.protocol}://${carbon.host}:${carbon.management.port}/oidc/logout</OIDCLogoutEPUrl>
    <OIDCConsentPage>${carbon.protocol}://${carbon.host}:${carbon.management.port}/authenticationendpoint/oauth2_consent.do</OIDCConsentPage>
    <OIDCLogoutConsentPage>${carbon.protocol}://${carbon.host}:${carbon.management.port}/authenticationendpoint/oauth2_logout_consent.do</OIDCLogoutConsentPage>
    <OIDCLogoutPage>${carbon.protocol}://${carbon.host}:${carbon.management.port}/authenticationendpoint/oauth2_logout.do</OIDCLogoutPage>
    
    <EnableOAuthCache>false</EnableOAuthCache>
    ```

    > Caching Recommendation
    >
    > It is recommended to keep the OAuth2 local cache and the distributed cache disabled as it may cause out-of-memory issues. However, if you want to enable the OAuth2 local cache, you have to enable the distributed cache as well.
    > 
    > To enable the OAuth2 local cache and distributed cache, set the `<EnableOAuthCache>` property and isDistributed to true.
    > ```
    > <EnableOAuthCache>true</EnableOAuthCache>
    > <Cache name="OAuthCache" enable="true" timeout="1" capacity="5000" isDistributed="true"/>
    > ```

-   The following elements were removed from the `<OAuth><OpenIDConnect>` element:

    ```
    <IDTokenSubjectClaim>http://wso2.org/claims/givenname</IDTokenSubjectClaim>
    <UserInfoEndpointClaimDialect>http://wso2.org/claims</UserInfoEndpointClaimDialect>
    ```

-   The following code was updated. To add audiences to the JWT token, use the code block below. For more information, see [JWT Token Generation](https://docs.wso2.com/display/IS520/JWT+Token+Generation).

    ```
    <OpenIDConnect>
        <IDTokenBuilder>org.wso2.carbon.identity.openidconnect.DefaultIDTokenBuilder</IDTokenBuilder>
        <!-- Comment out to add Audience values to the JWT token (id_token)-->
        <!--Audiences>
            <Audience>${carbon.protocol}://${carbon.host}:${carbon.management.port}/oauth2/token</Audience>
        </Audiences-->
        <!--Default value for IDTokenIssuerID, is OAuth2TokenEPUrl.If that doesn't satisfy uncomment the following config and explicitly configure the value-->
        <IDTokenIssuerID>${carbon.protocol}://${carbon.host}:${carbon.management.port}/oauth2/token</IDTokenIssuerID>
    
    ...
    
    </OpenIDConnect>
    ```

-   The `<CacheConfig>` was replaced:

    ```
    <CacheConfig>
        <CacheManager name="IdentityApplicationManagementCacheManager">
            <Cache name="AppAuthFrameworkSessionContextCache" enable="false" timeout="1" capacity="5000" isDistributed="false" />
            <Cache name="AuthenticationContextCache" enable="false" timeout="1" capacity="5000" isDistributed="false" />
            <Cache name="AuthenticationRequestCache" enable="false" timeout="1" capacity="5000" isDistributed="false" />
            <Cache name="AuthenticationResultCache" enable="false" timeout="1" capacity="5000" isDistributed="false" />
            <Cache name="AppInfoCache" enable="true" timeout="1" capacity="5000" isDistributed="false" />
            <Cache name="AuthorizationGrantCache" enable="false" timeout="1" capacity="5000" isDistributed="false" />
            <Cache name="OAuthCache" enable="false" timeout="1" capacity="5000" isDistributed="false" />
            <Cache name="OAuthSessionDataCache" enable="false" timeout="1" capacity="5000" isDistributed="false" />
            <Cache name="SAMLSSOParticipantCache" enable="false" timeout="1" capacity="5000" isDistributed="false" />
            <Cache name="SAMLSSOSessionIndexCache" enable="false" timeout="1" capacity="5000" isDistributed="false" />
            <Cache name="SAMLSSOSessionDataCache" enable="false" timeout="1" capacity="5000" isDistributed="false" />
            <Cache name="ServiceProviderCache" enable="true" timeout="1" capacity="5000" isDistributed="false" />
            <Cache name="ProvisioningConnectorCache" enable="true" timeout="1" capacity="5000" isDistributed="false" />
            <Cache name="ProvisioningEntityCache" enable="false" timeout="1" capacity="5000" isDistributed="false" />
            <Cache name="ServiceProviderProvisioningConnectorCache" enable="true" timeout="1" capacity="5000" isDistributed="false" />
            <Cache name="IdPCacheByAuthProperty" enable="true" timeout="1" capacity="5000" isDistributed="false" />
            <Cache name="IdPCacheByHRI" enable="true" timeout="1" capacity="5000" isDistributed="false" />
            <Cache name="IdPCacheByName" enable="true" timeout="1" capacity="5000" isDistributed="false" />
        </CacheManager>
    </CacheConfig>
    ```

### `context.xml` file 

Stored in the <PRODUCT_HOME>/repository/conf/tomcat/carbon/META-INF/ directory.

The entire file was replaced.

### `context.xml` file 

Stored in the <PRODUCT_HOME>/repository/conf/tomcat/ directory.

The entire file was replaced.

### `web.xml` file 

Stored in the <PRODUCT_HOME>/repository/conf/tomcat/carbon/WEB-INF/ directory.

The entire file was replaced.

### `carbon.xml` file 

Stored in the <PRODUCT_HOME>/repository/conf/ directory.

The following elements were added under the `<Security>` tag:

```
<STSCallBackHandlerName>org.wso2.carbon.identity.provider.AttributeCallbackHandler</STSCallBackHandlerName>
 
<XSSPreventionConfig>
    <Enabled>true</Enabled>
    <Rule>allow</Rule>
    <Patterns>
        <!--Pattern></Pattern-->
    </Patterns>
</XSSPreventionConfig>
```

The following elements were removed:

```
<!--Configurations to avoid Cross Site Request Forgery vulnerabilities-->
<CSRFPreventionConfig>
    <!--CSRFPreventionFilter configurations that adopts Synchronizer Token Pattern-->
    <CSRFPreventionFilter>
    <!-- Set below to true to enable the CSRFPreventionFilter-->
    <Enabled>false</Enabled>
    <!--Url Pattern to skip application of CSRF protection-->
    <SkipUrlPattern > (.*)(/images|/css | /js|/docs)(.*) </SkipUrlPattern>
    </CSRFPreventionFilter>
</CSRFPreventionConfig>
 
<!-- Configuration to enable or disable CR and LF sanitization filter-->
<CRLFPreventionConfig>
    <!--Set below to true to enable the CRLFPreventionFilter-->
    <Enabled>true</Enabled>
</CRLFPreventionConfig>
```

### `claim-config.xml` file 

Stored in the <PRODUCT_HOME>/repository/conf/ directory.

The following claims were added. For more information on configuring these, see [Configuring Users](https://docs.wso2.com/display/IS520/Configuring+Users#ConfiguringUsers-Customizingauser'sprofile) or [User Account Locking and Account Disabling](https://docs.wso2.com/display/IS520/User+Account+Locking+and+Account+Disabling) depending on the claim you want to configure.

```
<Claim>
    <ClaimURI>http://wso2.org/claims/identity/lastLoginTime</ClaimURI>
    <DisplayName>Last Login</DisplayName>
    <!-- Proper attribute Id in your user store must be configured for this -->
    <AttributeID>carLicense</AttributeID>
    <Description>Last Login Time</Description>
</Claim>
<Claim>
    <ClaimURI>http://wso2.org/claims/identity/lastPasswordUpdateTime</ClaimURI>
    <DisplayName>Last Password Update</DisplayName>
    <!-- Proper attribute Id in your user store must be configured for this -->
    <AttributeID>businessCategory</AttributeID>
    <Description>Last Password Update Time</Description>
</Claim>
<Claim>
    <ClaimURI>http://wso2.org/claims/identity/accountDisabled</ClaimURI>
    <DisplayName>Account Disabled</DisplayName>
    <!-- Proper attribute Id in your user store must be configured for this -->
    <AttributeID>ref</AttributeID>
    <Description>Account Disabled</Description>
</Claim>
```

### `data-agent-config.xml` file 

Stored in the  <PRODUCT_HOME>/repository/conf/data-bridge/ directory.

The file was newly added.

### `event-processor.xml` file 

Stored in the  <PRODUCT_HOME>/repository/conf/ directory.

The file was newly added.

### `metrics-datasources.xml` file 

Stored in the  <PRODUCT_HOME>/repository/conf/datasources/ directory.

Set the `<defaultAutocommit>` property to true.

```
<datasource>
    <name>WSO2_METRICS_DB</name>
    <description>The default datasource used for WSO2 Carbon Metrics</description>
    <jndiConfig>
        <name>jdbc/WSO2MetricsDB</name>
    </jndiConfig>
    <definition type="RDBMS">
        <configuration>        <url>jdbc:h2:repository/database/WSO2METRICS_DB;DB_CLOSE_ON_EXIT=FALSE;AUTO_SERVER=TRUE</url>
            <username>wso2carbon</username>
            <password>wso2carbon</password>
            <driverClassName>org.h2.Driver</driverClassName>
            <maxActive>50</maxActive>
            <maxWait>60000</maxWait>
            <testOnBorrow>true</testOnBorrow>
            <validationQuery>SELECT 1</validationQuery>
            <validationInterval>30000</validationInterval>
            <defaultAutoCommit>true</defaultAutoCommit>
        </configuration>
    </definition>
</datasource>
```

### `application-authentication.xml` file 

Stored in the <PRODUCT_HOME>/repository/conf/identity/ directory.

```
<AuthenticatorConfig name="EmailOTP" enabled="true">
    <Parameter name="GmailClientId">gmailClientIdValue</Parameter>
    <Parameter name="GmailClientSecret">gmailClientSecretValue</Parameter>
    <Parameter name="SendgridAPIKey">sendgridAPIKeyValue</Parameter>
    <Parameter name="GmailRefreshToken">gmailRefreshTokenValue</Parameter>
    <Parameter name="GmailEmailEndpoint">https://www.googleapis.com/gmail/v1/users/[userId]/messages/send</Parameter>
    <Parameter name="SendgridEmailEndpoint">https://api.sendgrid.com/api/mail.send.json</Parameter>
    <Parameter name="accessTokenRequiredAPIs">Gmail</Parameter>
    <Parameter name="apiKeyHeaderRequiredAPIs">Sendgrid</Parameter>
    <Parameter name="SendgridFormData">sendgridFormDataValue</Parameter>
    <Parameter name="SendgridURLParams">sendgridURLParamsValue</Parameter>
    <Parameter name="GmailAuthTokenType">Bearer</Parameter>
    <Parameter name="GmailTokenEndpoint">https://www.googleapis.com/oauth2/v3/token</Parameter>
    <Parameter name="SendgridAuthTokenType">Bearer</Parameter>
</AuthenticatorConfig>
 
<AuthenticatorConfig name="x509CertificateAuthenticator" enabled="true">
    <Parameter name="AuthenticationEndpoint">https://localhost:8443/x509-certificate-servlet</Parameter>
</AuthenticatorConfig>
 
<AuthenticatorConfig name="totp" enabled="true">
    <Parameter name="encodingMethod">Base32</Parameter>
    <Parameter name="timeStepSize">30</Parameter>
    <Parameter name="windowSize">3</Parameter>
    <Parameter name="enableTOTP">false</Parameter>
</AuthenticatorConfig>
```

### `metrics.xml` file 

Stored in the <PRODUCT_HOME>/repository/conf/ directory.

The following elements were added:

```
<Metrics xmlns="http://wso2.org/projects/carbon/metrics.xml">
    <Reporting>
        <Console>
            <Enabled>false</Enabled>
            <!-- Polling Period in seconds.
                This is the period for polling metrics from the metric registry and
                printing in the console -->
            <PollingPeriod>60</PollingPeriod>
        </Console>
 
        <DAS>
            <Enabled>false</Enabled>
            <!-- Source of Metrics, which will be used to
                identify each metric sent in the streams -->
            <!-- Commented to use the hostname
                <Source>Carbon</Source>
            -->
            <!-- Polling Period in seconds.
                This is the period for polling metrics from the metric registry and
                sending events via the Data Publisher -->
            <PollingPeriod>60</PollingPeriod>
            <!-- The type used with Data Publisher -->
            <Type>thrift</Type>
            <!-- Data Receiver URL used by the Data Publisher -->
            <ReceiverURL>tcp://localhost:7611</ReceiverURL>
            <!-- Authentication URL for the Data Publisher -->
            <!-- <AuthURL>ssl://localhost:7711</AuthURL> -->
            <Username>admin</Username>
            <Password>admin</Password>
            <!-- Path for Data Agent Configuration -->
            <DataAgentConfigPath>repository/conf/data-bridge/data-agent-config.xml</DataAgentConfigPath>
        </DAS>
```

### `output-event-adapters.xml` file 

Stored in the <PRODUCT_HOME>/repository/conf/ directory.

The following adapter configurations were added:

```
<adapterConfig type="http">
    <!-- Thread Pool Related Properties -->
    <property key="minThread">8</property>
    <property key="maxThread">100</property>
    <property key="keepAliveTimeInMillis">20000</property>
    <property key="jobQueueSize">10000</property>
    <!-- HTTP Client Pool Related Properties -->
    <property key="defaultMaxConnectionsPerHost">50</property>
    <property key="maxTotalConnections">1000</property>
</adapterConfig>
 
<adapterConfig type="jms">
    <!-- Thread Pool Related Properties -->
    <property key="minThread">8</property>
    <property key="maxThread">100</property>
    <property key="keepAliveTimeInMillis">20000</property>
    <property key="jobQueueSize">10000</property>
</adapterConfig>
 
<adapterConfig type="mqtt">
    <!-- Thread Pool Related Properties -->
    <property key="minThread">8</property>
    <property key="maxThread">100</property>
    <property key="keepAliveTimeInMillis">20000</property>
    <property key="jobQueueSize">10000</property>
    <property key="connectionKeepAliveInterval">60</property>
</adapterConfig>
 
<adapterConfig type="kafka">
    <!-- Thread Pool Related Properties -->
    <property key="minThread">8</property>
    <property key="maxThread">100</property>
    <property key="keepAliveTimeInMillis">20000</property>
    <property key="jobQueueSize">10000</property>
</adapterConfig>
 
<adapterConfig type="email">
    <!-- Comment mail.smtp.user and mail.smtp.password properties to support connecting SMTP servers which use trust
        based authentication rather username/password authentication -->
    <property key="mail.smtp.from">abcd@gmail.com</property>
    <property key="mail.smtp.user">abcd</property>
    <property key="mail.smtp.password">xxxx</property>
    <property key="mail.smtp.host">smtp.gmail.com</property>
    <property key="mail.smtp.port">587</property>
    <property key="mail.smtp.starttls.enable">true</property>
    <property key="mail.smtp.auth">true</property>
    <!-- Thread Pool Related Properties -->
    <property key="minThread">8</property>
    <property key="maxThread">100</property>
    <property key="keepAliveTimeInMillis">20000</property>
    <property key="jobQueueSize">10000</property>
</adapterConfig>
 
<adapterConfig type="ui">
    <property key="eventQueueSize">30</property>
    <!-- Thread Pool Related Properties -->
    <property key="minThread">8</property>
    <property key="maxThread">100</property>
    <property key="keepAliveTimeInMillis">20000</property>
    <property key="jobQueueSize">10000</property>
</adapterConfig>
 
<adapterConfig type="websocket-local">
    <!-- Thread Pool Related Properties -->
    <property key="minThread">8</property>
    <property key="maxThread">100</property>
    <property key="keepAliveTimeInMillis">20000</property>
    <property key="jobQueueSize">10000</property>
</adapterConfig>
 
<adapterConfig type="websocket">
    <!-- Thread Pool Related Properties -->
    <property key="minThread">8</property>
    <property key="maxThread">100</property>
    <property key="keepAliveTimeInMillis">20000</property>
    <property key="jobQueueSize">10000</property>
</adapterConfig>
 
<adapterConfig type="soap">
    <!-- Thread Pool Related Properties -->
    <property key="minThread">8</property>
    <property key="maxThread">100</property>
    <property key="keepAliveTimeInMillis">20000</property>
    <property key="jobQueueSize">10000</property>
    <!-- Axis2 Client Connection Related Properties -->
    <property key="axis2ClientConnectionTimeout">10000</property>
    <property key="reuseHTTPClient">true</property>
    <property key="autoReleaseConnection">true</property>
    <property key="maxConnectionsPerHost">50</property>
</adapterConfig>
```

### `registry.xml` file 

Stored in the <PRODUCT_HOME>/repository/conf/ directory.

The following elements were added:

```
<indexingConfiguration>
    <startIndexing>false</startIndexing>
    <startingDelayInSeconds>35</startingDelayInSeconds>
    <indexingFrequencyInSeconds>5</indexingFrequencyInSeconds>
    <!--number of resources submit for given indexing thread -->
    <batchSize>40</batchSize>
    <!--number of worker threads for indexing -->
    <indexerPoolSize>40</indexerPoolSize>
    <!-- location storing the time the indexing took place-->
    <lastAccessTimeLocation>/_system/local/repository/components/org.wso2.carbon.registry/indexing/lastaccesstime</lastAccessTimeLocation>
    <!-- the indexers that implement the indexer interface for a relevant media type/(s) -->
    <indexers>
        <indexer class="org.wso2.carbon.registry.indexing.indexer.MSExcelIndexer" mediaTypeRegEx="application/vnd.ms-excel" />
        <indexer class="org.wso2.carbon.registry.indexing.indexer.MSPowerpointIndexer" mediaTypeRegEx="application/vnd.ms-powerpoint" />
        <indexer class="org.wso2.carbon.registry.indexing.indexer.MSWordIndexer" mediaTypeRegEx="application/msword" />
        <indexer class="org.wso2.carbon.registry.indexing.indexer.PDFIndexer" mediaTypeRegEx="application/pdf" />
        <indexer class="org.wso2.carbon.registry.indexing.indexer.XMLIndexer" mediaTypeRegEx="application/xml" />
        <indexer class="org.wso2.carbon.registry.indexing.indexer.XMLIndexer" mediaTypeRegEx="application/(.)+\+xml" />
        <indexer class="org.wso2.carbon.registry.indexing.indexer.PlainTextIndexer" mediaTypeRegEx="application/swagger\+json" />
        <indexer class="org.wso2.carbon.registry.indexing.indexer.PlainTextIndexer" mediaTypeRegEx="application/(.)+\+json" />
        <indexer class="org.wso2.carbon.registry.indexing.indexer.PlainTextIndexer" mediaTypeRegEx="text/(.)+" />
        <indexer class="org.wso2.carbon.registry.indexing.indexer.PlainTextIndexer" mediaTypeRegEx="application/x-javascript" />
    </indexers>
    <exclusions>
        <exclusion pathRegEx="/_system/config/repository/dashboards/gadgets/swfobject1-5/.*[.]html" />
        <exclusion pathRegEx="/_system/local/repository/components/org[.]wso2[.]carbon[.]registry/mount/.*" />
    </exclusions>
</indexingConfiguration>
```

### `user-mgt.xml` file 

Stored in the <PRODUCT_HOME>/repository/conf/ directory.

The following LDAP/AD property was added:

```
<Property name="AnonymousBind">false</Property>
```

## Recommended

Note that the following new configuration files have been added from 5.2.0 onwards.

- repository/conf/event-processor.xml
- repository/conf/security/Owasp.CsrfGuard.Carbon.properties
- repository/conf/tomcat/carbon/WEB-INF/web.xml
- repository/conf/identity/oidc-scope-config.xml