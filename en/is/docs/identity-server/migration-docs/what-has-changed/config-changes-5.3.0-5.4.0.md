# Configuration Changes - WSO2 IS 5.3.0 to 5.4.0

Listed below are the configuration and behavioral changes from WSO2 IS version 5.3.0 to 5.4.0.

- [Configuration changes](#configuration-changes)

## Configuration changes

Listed below are the configuration changes from WSO2 IS version 5.3.0 to 5.4.0.

### `carbon.xml` file 

Stored in the <IS_HOME>/repository/conf folder.

Change the version property value to 5.4.0.

```
<Version>5.4.0</Version>
```

### `identity-event.properties` file 

Stored in the <IS_HOME>/repository/conf/identity folder.

Add the following property.

```
account.lock.handler.notification.manageInternally=true
```

The property given above allows you to enable or disable sending emails via the WSO2 Identity Server when an account is locked or unlocked.

### `identity.xml` file 

Stored in the <IS_HOME>/repository/conf/identity folder.

Add the following property within the `<SessionDataCleanUp>` tag.

```
<DeleteChunkSize>50000</DeleteChunkSize>
```

In a production environment, there is a possibility for a deadlock/database lock
to occur when running a session data cleanup task in high load scenarios.
To mitigate this, the property given above was introduced to clean data in chunks.
Configure this property with the required chunk size. For more information, see [Deployment Guidelines in Production](https://docs.wso2.com/display/IS540/Deployment+Guidelines+in+Production#DeploymentGuidelinesinProduction-Configuringchunksize).

Remove the following property found within the `<OperationDataCleanUp>` tag.

```
<CleanUpPeriod>720</CleanUpPeriod>
```

WSO2 IS 5.3.0 had two separate tasks for session data cleanup and operation data cleanup.
This is now combined and done through one task.
Therefore the property given above is no longer needed.
You can still configure the `<CleanUpPeriod>` property within the `<SessionDataCleanUp>` tag
to specify the cleanup period for the combined task.

Change the default value of the following property from 300 to 0.

> You can skip this step if you have already configured the `<TimestampSkew>` property with your own value.

```
<TimestampSkew>0</TimestampSkew>
```

The property given above specifies the maximum tolerance limit
for the clock skewed between the sender and recipient.
The default value was changed to 0 as the best practice is to assume
that the sender and recipient clocks are synchronized and are in the same time stamp.
Configure this accordingly if the clocks are not in the same timestamp.

Add the following JWT bearer grant type within the `<SupportedGrantTypes>` tag.

```
<SupportedGrantType>
<GrantTypeName>urn:ietf:params:oauth:grant-type:jwt-bearer</GrantTypeName>
<GrantTypeHandlerImplClass>org.wso2.carbon.identity.oauth2.grant.jwt.JWTBearerGrantHandler</GrantTypeHandlerImplClass>
<GrantTypeValidatorImplClass>org.wso2.carbon.identity.oauth2.grant.jwt.JWTGrantValidator</GrantTypeValidatorImplClass>
</SupportedGrantType>
```

The JWT bearer grant type is supported out-of-the-box with WSO2 IS 5.4.0.
For more information, see [Configuring JWT Grant Type](https://docs.wso2.com/display/ISCONNECTORS/Configuring+JWT+Grant+Type) in the ISConnectors documentation.

Update the `<EmailVerification>` code block with the following code.

The properties shown below at line numbers 3,8,9,10 & 11 were added in 5.4.0.

> This step is optional.

```
<EmailVerification>
    <Enable>false</Enable>
    <ExpiryTime>1440</ExpiryTime>
    <LockOnCreation>true</LockOnCreation>
    <Notification>
        <InternallyManage>true</InternallyManage>
    </Notification>
    <AskPassword>
        <ExpiryTime>1440</ExpiryTime>
        <PasswordGenerator>org.wso2.carbon.user.mgt.common.DefaultPasswordGenerator</PasswordGenerator>
    </AskPassword>
</EmailVerification>
```

Update the following property found within the `<SelfRegistration>` tag to true.

> This step is optional.

```
<LockOnCreation>true</LockOnCreation>
```

Add the following properties within the `<SelfRegistration>` tag.

> This step is optional.

```
<VerificationCode>
  <ExpiryTime>1440</ExpiryTime>
</VerificationCode>
```

Add the following properties within the `<Server>` tag.

```
<AuthenticationPolicy>
    <CheckAccountExist>false</CheckAccountExist>
</AuthenticationPolicy>
```

Change the default values within the `<CacheManager>` tag.

> **If you have already configured all the properties** within the `<CacheManager>` tag with your own values, skip this step.
> 
> **If you have only configured some properties** within the `<CacheManager>` tag with your own values, replace the properties that are not been changed/configured with the relevant default values shown below.
>
> **If you have not configured or changed any of the properties** within the `<CacheManager>` tag with your own values, copy the entire code block below and replace the `<CacheManager>` tag in the identity.xml file with the code block given below.

```
<CacheManager name="IdentityApplicationManagementCacheManager">
    <Cache name="AppAuthFrameworkSessionContextCache" enable="true" timeout="300" capacity="5000" isDistributed="false"/>
    <Cache name="AuthenticationContextCache" enable="true" timeout="300" capacity="5000" isDistributed="false"/>
    <Cache name="AuthenticationRequestCache" enable="true" timeout="300" capacity="5000" isDistributed="false"/>
    <Cache name="AuthenticationResultCache"  enable="true" timeout="300" capacity="5000" isDistributed="false"/>
    <Cache name="AppInfoCache"               enable="true"  timeout="900" capacity="5000" isDistributed="false"/>
    <Cache name="AuthorizationGrantCache"    enable="true" timeout="300" capacity="5000" isDistributed="false"/>
    <Cache name="OAuthCache"                 enable="true" timeout="300" capacity="5000" isDistributed="false"/>
    <Cache name="OAuthScopeCache"            enable="true"  timeout="300" capacity="5000" isDistributed="false"/>
    <Cache name="OAuthSessionDataCache"      enable="true" timeout="300" capacity="5000" isDistributed="false"/>
    <Cache name="SAMLSSOParticipantCache"    enable="true" timeout="300" capacity="5000" isDistributed="false"/>
    <Cache name="SAMLSSOSessionIndexCache"   enable="true" timeout="300" capacity="5000" isDistributed="false"/>
    <Cache name="SAMLSSOSessionDataCache"    enable="true" timeout="300" capacity="5000" isDistributed="false"/>
    <Cache name="ServiceProviderCache"       enable="true"  timeout="900" capacity="5000" isDistributed="false"/>
    <Cache name="ProvisioningConnectorCache" enable="true"  timeout="900" capacity="5000" isDistributed="false"/>
    <Cache name="ProvisioningEntityCache"    enable="true" timeout="900" capacity="5000" isDistributed="false"/>
    <Cache name="ServiceProviderProvisioningConnectorCache" enable="true"  timeout="900" capacity="5000" isDistributed="false"/>
    <Cache name="IdPCacheByAuthProperty"     enable="true"  timeout="900" capacity="5000" isDistributed="false"/>
    <Cache name="IdPCacheByHRI"              enable="true"  timeout="900" capacity="5000" isDistributed="false"/>
    <Cache name="IdPCacheByName"             enable="true"  timeout="900" capacity="5000" isDistributed="false"/>
</CacheManager>
```

Add the following property within the `<CacheManager>` tag if it does not already exist.

```
<Cache name="OAuthScopeCache" enable="true"  timeout="300" capacity="5000" isDistributed="false"/>
```

Add the following properties within the `<OAuth>` tag. The code comments explain the usage and applicable values for the properties.

```
<!-- Specify the Token issuer class to be used.
Default: org.wso2.carbon.identity.oauth2.token.OauthTokenIssuerImpl.
Applicable values: org.wso2.carbon.identity.oauth2.token.JWTTokenIssuer-->
    <!--<IdentityOAuthTokenGenerator>org.wso2.carbon.identity.oauth2.token.JWTTokenIssuer</IdentityOAuthTokenGenerator>-->
 
<!-- This configuration is used to specify the access token value generator.
Default: org.apache.oltu.oauth2.as.issuer.UUIDValueGenerator
Applicable values: org.apache.oltu.oauth2.as.issuer.UUIDValueGenerator,
    org.apache.oltu.oauth2.as.issuer.MD5Generator,
    org.wso2.carbon.identity.oauth.tokenvaluegenerator.SHA256Generator -->
    <!--<AccessTokenValueGenerator>org.wso2.carbon.identity.oauth.tokenvaluegenerator.SHA256Generator</AccessTokenValueGenerator>-->
 
<!-- This configuration is used to specify whether the Service Provider tenant domain should be used when generating
access token.Otherwise user domain will be used.Currently this value is only supported by the JWTTokenIssuer. -->
    <!--<UseSPTenantDomain>True</UseSPTenantDomain>-->
```

Add the following properties related to token persistence within the `<OAuth>` tag.

```
<TokenPersistence>
    <Enable>true</Enable>
    <PoolSize>0</PoolSize>
    <RetryCount>5</RetryCount>
</TokenPersistence>
```

Add the following property within the `<OpenIDConnect>` tag.

```
<SignJWTWithSPKey>false</SignJWTWithSPKey>
```

Replace the `<OAuth2RevokeEPUrll>` property with the following.

```
<OAuth2RevokeEPUrl>${carbon.protocol}://${carbon.host}:${carbon.management.port}/oauth2/revoke</OAuth2RevokeEPUrl>
```

Add the following event listener within the `<EventListeners>` tag. Uncomment this listener if you are using SCIM 2.0.

```
<!-- Uncomment the following event listener if SCIM2 is used. -->
<!--EventListener type="org.wso2.carbon.user.core.listener.UserOperationEventListener"
name = "org.wso2.carbon.identity.scim2.common.listener.SCIMUserOperationListener"
orderId = "93"
enable = "true" /-->
```

Add the following properties within the `<ResourceAccessControl>` tag. These properties specify the access levels and permissions for the SCIM 2.0 resources.

```
<Resource context="(.*)/scim2/Users" secured="true" http-method="POST">
    <Permissions>/permission/admin/manage/identity/usermgt/create</Permissions>
</Resource>
<Resource context="(.*)/scim2/Users" secured="true" http-method="GET">
    <Permissions>/permission/admin/manage/identity/usermgt/list</Permissions>
</Resource>
<Resource context="(.*)/scim2/Groups" secured="true" http-method="POST">
    <Permissions>/permission/admin/manage/identity/rolemgt/create</Permissions>
</Resource>
<Resource context="(.*)/scim2/Groups" secured="true" http-method="GET">
    <Permissions>/permission/admin/manage/identity/rolemgt/view</Permissions>
</Resource>
<Resource context="(.*)/scim2/Users/(.*)" secured="true" http-method="GET">
    <Permissions>/permission/admin/manage/identity/usermgt/view</Permissions>
</Resource>
<Resource context="(.*)/scim2/Users/(.*)" secured="true" http-method="PUT">
    <Permissions>/permission/admin/manage/identity/usermgt/update</Permissions>
</Resource>
<Resource context="(.*)/scim2/Users/(.*)" secured="true" http-method="PATCH">
    <Permissions>/permission/admin/manage/identity/usermgt/update</Permissions>
</Resource>
<Resource context="(.*)/scim2/Users/(.*)" secured="true" http-method="DELETE">
    <Permissions>/permission/admin/manage/identity/usermgt/delete</Permissions>
</Resource>
<Resource context="(.*)/scim2/Groups/(.*)" secured="true" http-method="GET">
    <Permissions>/permission/admin/manage/identity/rolemgt/view</Permissions>
</Resource>
<Resource context="(.*)/scim2/Groups/(.*)" secured="true" http-method="PUT">
    <Permissions>/permission/admin/manage/identity/rolemgt/update</Permissions>
</Resource>
<Resource context="(.*)/scim2/Groups/(.*)" secured="true" http-method="PATCH">
    <Permissions>/permission/admin/manage/identity/rolemgt/update</Permissions>
</Resource>
<Resource context="(.*)/scim2/Groups/(.*)" secured="true" http-method="DELETE">
    <Permissions>/permission/admin/manage/identity/rolemgt/delete</Permissions>
</Resource>
<Resource context="(.*)/scim2/Me" secured="true"    http-method="GET">
    <Permissions>/permission/admin/login</Permissions>
</Resource>
<Resource context="(.*)/scim2/Me" secured="true" http-method="DELETE">
    <Permissions>/permission/admin/manage/identity/usermgt/delete</Permissions>
</Resource>
<Resource context="(.*)/scim2/Me" secured="true"    http-method="PUT">
    <Permissions>/permission/admin/login</Permissions>
</Resource>
<Resource context="(.*)/scim2/Me" secured="true"   http-method="PATCH">
    <Permissions>/permission/admin/login</Permissions>
</Resource>
<Resource context="(.*)/scim2/Me" secured="true" http-method="POST">
    <Permissions>/permission/admin/manage/identity/usermgt/create</Permissions>
</Resource>
<Resource context="/scim2/ServiceProviderConfig" secured="false" http-method="all">
    <Permissions></Permissions>
</Resource>
<Resource context="/scim2/ResourceType" secured="false" http-method="all">
    <Permissions></Permissions>
</Resource>
<Resource context="/scim2/Bulk" secured="true"  http-method="all">
    <Permissions>/permission/admin/manage/identity/usermgt</Permissions>
</Resource>
<Resource context="(.*)/api/identity/oauth2/dcr/(.*)" secured="true" http-method="all">
    <Permissions>/permission/admin/manage/identity/applicationmgt</Permissions>
</Resource>
```

Add the following properties within the `<TenantContextsToRewrite><WebApp>` tag.

```
<Context>/scim2</Context>
<Context>/api/identity/oauth/dcr/v1.0</Context>
```

Remove the following property found within the `<OAuth>` tag.

```
<AppInfoCacheTimeout>-1</AppInfoCacheTimeout>
<AuthorizationGrantCacheTimeout>-1</AuthorizationGrantCacheTimeout>
<SessionDataCacheTimeout>-1</SessionDataCacheTimeout>
<ClaimCacheTimeout>-1</ClaimCacheTimeout>
```

Add the following commented property within the `<OAuth>` tag.

```
<!-- True, if access token alias is stored in the database instead of access token.
Eg.token alias and token is same when
default AccessTokenValueGenerator is used.
When JWTTokenIssuer is used, jti is used as the token alias
Default: true.
Applicable values: true, false-->
 
    <!--<PersistAccessTokenAlias>false</PersistAccessTokenAlias>-->
```

Replace the `<OAuth2DCREPUrl>` property with the property value given below.

```
<OAuth2DCREPUrl>${carbon.protocol}://${carbon.host}:${carbon.management.port}/api/identity/oauth2/dcr/v1.0/register</OAuth2DCREPUrl>
```

Uncomment the following property and add line number 3 given below to the file.

```
<TokenValidators>
    <TokenValidator type="bearer" class="org.wso2.carbon.identity.oauth2.validators.DefaultOAuth2TokenValidator" />
    <TokenValidator type="jwt" class="org.wso2.carbon.identity.oauth2.validators.OAuth2JWTTokenValidator" />
</TokenValidators>
```

Add the following commented property to the file. You can place it after the `</EnableAssertions>` closing tag.

```
<!-- This should be true if subject identifier in the token validation response needs to adhere to the
following SP configuration.
 
- Use tenant domain in local subject identifier. - Use user store domain in local subject identifier.
 
if the value is false, subject identifier will be set as the fully qualified username.
 
Default value: false
 
Supported versions: IS 5.4.0 beta onwards-->
    <!--<BuildSubjectIdentifierFromSPConfig>true</BuildSubjectIdentifierFromSPConfig>-->
```

Uncomment the `<UserType>` property that has the value "Federated" and comment out the `<UserType>` property that has the value "Local" as seen below.
The property can be found within the `<SAML2Grant>` tag.

```
<SAML2Grant>
    <!--SAML2TokenHandler></SAML2TokenHandler-->
    <!-- UserType conifg decides whether the SAML assertion carrying user is local user or a federated user.
            Only Local Users can access claims from local userstore. LEGACY users will have to have tenant domain appended username.
            They will not be able to access claims from local userstore. To get claims by mapping users with exact same username from local
            userstore (for non LOCAL scenarios) use mapFederatedUsersToLocal config -->
    <!--<UserType>LOCAL</UserType>-->
    <UserType>FEDERATED</UserType>
    <!--UserType>LEGACY</UserType-->
</SAML2Grant>
```

Remove the following properties found within the `<SSOService>` tag.

> This step is optional.

```
<PersistanceCacheTimeout>157680000</PersistanceCacheTimeout>
<SessionIndexCacheTimeout>157680000</SessionIndexCacheTimeout>
```

Add the following properties to the file. You can place the code block after the `</SCIM>` closing tag.

```
<SCIM2>
    <!--Default value for UserEPUrl and GroupEPUrl are built in following format
            https://<HostName>:<MgtTrpProxyPort except 443>/<ProxyContextPath>/<context>/<path>
            If that doesn't satisfy uncomment the following config and explicitly configure the value-->
    <!--UserEPUrl>${carbon.protocol}://${carbon.host}:${carbon.management.port}/scim2/Users</UserEPUrl-->
    <!--GroupEPUrl>${carbon.protocol}://${carbon.host}:${carbon.management.port}/scim2/Groups</GroupEPUrl-->
</SCIM2>
```

Add the following properties to the file. You can place it after the `</EnableAskPasswordAdminUI>` closing tag.

```
<EnableRecoveryEndpoint>true</EnableRecoveryEndpoint>
<EnableSelfSignUpEndpoint>true</EnableSelfSignUpEndpoint>
```

Add the following properties within the `<ResourceAccessControl>` tag.

```
<Resource context="(.*)/api/identity/oauth2/dcr/v1.0/register(.*)" secured="true" http-method="POST">
    <Permissions>/permission/admin/manage/identity/applicationmgt/create</Permissions>
</Resource>
<Resource context="(.*)/api/identity/oauth2/dcr/v1.0/register(.*)" secured="true" http-method="DELETE">
    <Permissions>/permission/admin/manage/identity/applicationmgt/delete</Permissions>
</Resource>
<Resource context="(.*)/api/identity/oauth2/dcr/v1.0/register(.*)" secured="true" http-method="PUT">
    <Permissions>/permission/admin/manage/identity/applicationmgt/update</Permissions>
</Resource>
<Resource context="(.*)/api/identity/oauth2/dcr/v1.0/register(.*)" secured="true" http-method="GET">
    <Permissions>/permission/admin/manage/identity/applicationmgt/view</Permissions>
</Resource>
```

### `oidc-scope-config.xml` file 

Stored in the <IS_HOME>/repository/conf/identity folder.

Replace the `<Claim>` tag within the `<Scope id="openid">` tag with the following.

```
<Claim>
    sub, email, email_verified, name, family_name, given_name, middle_name, nickname, preferred_username, profile,
    picture, website, gender, birthdate, zoneinfo, locale, updated_at, phone_number, phone_number_verified,
    address,street_address,country, formatted, postal_code, locality, region
</Claim>
```

Replace the `<Claim>` tag within the `<Scope id="address">` tag with the following.

```
<Claim>address,street</Claim>
```

### `authenticators.xml` file 

Stored in the <IS_HOME>/repository/conf/security folder.

Update the parameter name of the JITUserProvisioning parameter to the following.

```
<Parameter name="JITUserProvisioningEnabled">true</Parameter>
```

### `web.xml` file 

Stored in the <IS_HOME>/repository/conf/tomcat folder.

Add the following property under the `<session-config>` tag.

```
<tracking-mode>COOKIE</tracking-mode>
```

Add the following properties below the `<servlet-class>org.apache.jasper.servlet.JspServlet</servlet-class>` property.

```
<init-param>
   <param-name>compilerSourceVM</param-name>
   <param-value>1.8</param-value>
</init-param>
<init-param>
   <param-name>compilerTargetVM</param-name>
   <param-value>1.8</param-value>
</init-param>
```

### `email-admin-config.xml` file 

Stored in the <IS_HOME>/repository/conf/email folder.

Replace "https://localhost:9443" in all instances of the accountrecoveryendpoint URL with the {carbon.product-url} placeholder.
The URL should look similiar to the URL shown in the code block below. The placeholder will retrieve the value configured in the carbon.xml file.

> You can skip this step if you have already configured this with your load balancer URL.

```
{carbon.product-url}}/accountrecoveryendpoint/confirmregistration.do?confirmation={confirmation-code}&amp;userstoredomain={userstore-domain}&amp;username={url:user-name}&amp;tenantdomain={tenant-domain}
```

### `cipher-tool.properties` file 

Stored in the <IS_HOME>/repository/conf folder.

Add the following property.

```
ThirftBasedEntitlementConfig.KeyStore.Password=repository/conf/identity/identity.xml//Server/EntitlementSettings/ThirftBasedEntitlementConfig/KeyStore/Password,true
```

### `cipher-text.properties` file 

Stored in the <IS_HOME>/repository/conf folder.

Add the following property.

```
ThirftBasedEntitlementConfig.KeyStore.Password=[wso2carbon]
```

### `claim-config.xml` file 

Stored in the <IS_HOME>/repository/conf folder.

Add the following claims within the `<Dialect dialectURI="http://wso2.org/claims">` tag.

```
<Claim>
    <ClaimURI>http://wso2.org/claims/identity/phoneVerified</ClaimURI>
    <DisplayName>Phone Verified</DisplayName>
    <!-- Proper attribute Id in your user store must be configured for this -->
    <AttributeID>phoneVerified</AttributeID>
    <Description>Phone Verified</Description>
</Claim>
 
<Claim>
    <ClaimURI>http://wso2.org/claims/department</ClaimURI>
    <DisplayName>Department</DisplayName>
    <AttributeID>departmentNumber</AttributeID>
    <Description>Department</Description>
    <SupportedByDefault />
    <ReadOnly />
</Claim>
```

Add the following claims. This new claim dialect and the claims within it are required for SCIM 2.0.

```
<Dialect dialectURI="urn:ietf:params:scim:schemas:core:2.0">
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:id</ClaimURI>
        <DisplayName>Id</DisplayName>
        <AttributeID>scimId</AttributeID>
        <Description>Id</Description>
        <Required />
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/userid</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:externalId</ClaimURI>
        <DisplayName>External Id</DisplayName>
        <AttributeID>externalId</AttributeID>
        <Description>External Id</Description>
        <Required />
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/externalid</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:meta.created</ClaimURI>
        <DisplayName>Meta - Created</DisplayName>
        <AttributeID>createdDate</AttributeID>
        <Description>Meta - Created</Description>
        <Required />
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/created</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:meta.lastModified</ClaimURI>
        <DisplayName>Meta - Last Modified</DisplayName>
        <AttributeID>lastModifiedDate</AttributeID>
        <Description>Meta - Last Modified</Description>
        <Required />
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/modified</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:meta.location</ClaimURI>
        <DisplayName>Meta - Location</DisplayName>
        <AttributeID>location</AttributeID>
        <Description>Meta - Location</Description>
        <Required />
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/location</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:meta.resourceType</ClaimURI>
        <DisplayName>Meta - Location</DisplayName>
        <AttributeID>ref</AttributeID>
        <Description>Meta - Location</Description>
        <Required />
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/resourceType</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:meta.version</ClaimURI>
        <DisplayName>Meta - Version</DisplayName>
        <AttributeID>im</AttributeID>
        <Description>Meta - Version</Description>
        <Required />
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/im</MappedLocalClaim>
    </Claim>
</Dialect>
<Dialect dialectURI="urn:ietf:params:scim:schemas:core:2.0:User">
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:userName</ClaimURI>
        <DisplayName>User Name</DisplayName>
        <AttributeID>uid</AttributeID>
        <Description>User Name</Description>
        <DisplayOrder>2</DisplayOrder>
        <Required />
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/username</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:name.givenName</ClaimURI>
        <DisplayName>Name - Given Name</DisplayName>
        <AttributeID>givenName</AttributeID>
        <Description>Given Name</Description>
        <Required />
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/givenname</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:name.familyName</ClaimURI>
        <DisplayName>Name - Family Name</DisplayName>
        <AttributeID>sn</AttributeID>
        <Description>Family Name</Description>
        <DisplayOrder>2</DisplayOrder>
        <Required />
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/lastname</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:name.formatted</ClaimURI>
        <DisplayName>Name - Formatted Name</DisplayName>
        <AttributeID>formattedName</AttributeID>
        <Description>Formatted Name</Description>
        <DisplayOrder>2</DisplayOrder>
        <Required />
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/formattedName</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:name.middleName</ClaimURI>
        <DisplayName>Name - Middle Name</DisplayName>
        <AttributeID>middleName</AttributeID>
        <Description>Middle Name</Description>
        <DisplayOrder>2</DisplayOrder>
        <Required />
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/middleName</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:name.honorificPrefix</ClaimURI>
        <DisplayName>Name - Honoric Prefix</DisplayName>
        <AttributeID>honoricPrefix</AttributeID>
        <Description>Honoric Prefix</Description>
        <DisplayOrder>2</DisplayOrder>
        <Required />
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/honorificPrefix</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:name.honorificSuffix</ClaimURI>
        <DisplayName>Name - Honoric Suffix</DisplayName>
        <AttributeID>honoricSuffix</AttributeID>
        <Description>Honoric Suffix</Description>
        <DisplayOrder>2</DisplayOrder>
        <Required />
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/honorificSuffix</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:displayName</ClaimURI>
        <DisplayName>Display Name</DisplayName>
        <AttributeID>displayName</AttributeID>
        <Description>Display Name</Description>
        <DisplayOrder>2</DisplayOrder>
        <Required />
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/displayName</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:nickName</ClaimURI>
        <DisplayName>Nick Name</DisplayName>
        <AttributeID>nickName</AttributeID>
        <Description>Nick Name</Description>
        <DisplayOrder>2</DisplayOrder>
        <Required />
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/nickname</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:profileUrl</ClaimURI>
        <DisplayName>Profile URL</DisplayName>
        <AttributeID>url</AttributeID>
        <Description>Profile URL</Description>
        <DisplayOrder>2</DisplayOrder>
        <Required />
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/url</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:title</ClaimURI>
        <DisplayName>Title</DisplayName>
        <AttributeID>title</AttributeID>
        <Description>Title</Description>
        <DisplayOrder>2</DisplayOrder>
        <Required />
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/title</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:userType</ClaimURI>
        <DisplayName>User Type</DisplayName>
        <AttributeID>userType</AttributeID>
        <Description>User Type</Description>
        <DisplayOrder>2</DisplayOrder>
        <Required />
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/userType</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:preferredLanguage</ClaimURI>
        <DisplayName>Preferred Language</DisplayName>
        <AttributeID>preferredLanguage</AttributeID>
        <Description>Preferred Language</Description>
        <DisplayOrder>2</DisplayOrder>
        <Required />
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/preferredLanguage</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:locale</ClaimURI>
        <DisplayName>Locality</DisplayName>
        <AttributeID>localityName</AttributeID>
        <Description>Locality</Description>
        <DisplayOrder>2</DisplayOrder>
        <Required />
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/local</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:timezone</ClaimURI>
        <DisplayName>Time Zone</DisplayName>
        <AttributeID>timeZone</AttributeID>
        <Description>Time Zone</Description>
        <DisplayOrder>2</DisplayOrder>
        <Required />
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/timeZone</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:active</ClaimURI>
        <DisplayName>Active</DisplayName>
        <AttributeID>active</AttributeID>
        <Description>Active</Description>
        <DisplayOrder>2</DisplayOrder>
        <Required />
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/active</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:emails.work</ClaimURI>
        <DisplayName>Emails - Work Email</DisplayName>
        <AttributeID>workEmail</AttributeID>
        <Description>Work Email</Description>
        <DisplayOrder>5</DisplayOrder>
        <SupportedByDefault />
        <RegEx>^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$</RegEx>
        <MappedLocalClaim>http://wso2.org/claims/emails.work</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:emails.home</ClaimURI>
        <DisplayName>Emails - Home Email</DisplayName>
        <AttributeID>homeEmail</AttributeID>
        <Description>Home Email</Description>
        <DisplayOrder>5</DisplayOrder>
        <SupportedByDefault />
        <RegEx>^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$</RegEx>
        <MappedLocalClaim>http://wso2.org/claims/emails.home</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:emails.other</ClaimURI>
        <DisplayName>Emails - Other Email</DisplayName>
        <AttributeID>otherEmail</AttributeID>
        <Description>Other Email</Description>
        <DisplayOrder>5</DisplayOrder>
        <SupportedByDefault />
        <RegEx>^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$</RegEx>
        <MappedLocalClaim>http://wso2.org/claims/emails.other</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:phoneNumbers.mobile</ClaimURI>
        <DisplayName>Phone Numbers - Mobile Number</DisplayName>
        <AttributeID>mobile</AttributeID>
        <Description>Mobile Number</Description>
        <DisplayOrder>5</DisplayOrder>
        <SupportedByDefault />
        <RegEx>^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$</RegEx>
        <MappedLocalClaim>http://wso2.org/claims/mobile</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:phoneNumbers.home</ClaimURI>
        <DisplayName>Phone Numbers - Home Phone Number</DisplayName>
        <AttributeID>homePhone</AttributeID>
        <Description>Home Phone</Description>
        <DisplayOrder>5</DisplayOrder>
        <SupportedByDefault />
        <RegEx>^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$</RegEx>
        <MappedLocalClaim>http://wso2.org/claims/phoneNumbers.home</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:phoneNumbers.work</ClaimURI>
        <DisplayName>Phone Numbers - Work Phone Number</DisplayName>
        <AttributeID>workPhone</AttributeID>
        <Description>Work Phone</Description>
        <DisplayOrder>5</DisplayOrder>
        <SupportedByDefault />
        <RegEx>^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$</RegEx>
        <MappedLocalClaim>http://wso2.org/claims/phoneNumbers.work</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:phoneNumbers.other</ClaimURI>
        <DisplayName>Phone Numbers - Other</DisplayName>
        <AttributeID>otherPhoneNumber</AttributeID>
        <Description>Other Phone Number</Description>
        <DisplayOrder>5</DisplayOrder>
        <SupportedByDefault />
        <RegEx>^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$</RegEx>
        <MappedLocalClaim>http://wso2.org/claims/phoneNumbers.other</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:ims.gtalk</ClaimURI>
        <DisplayName>IM - Gtalk</DisplayName>
        <AttributeID>imGtalk</AttributeID>
        <Description>IM - Gtalk</Description>
        <DisplayOrder>5</DisplayOrder>
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/gtalk</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:ims.skype</ClaimURI>
        <DisplayName>IM - Skype</DisplayName>
        <AttributeID>imSkype</AttributeID>
        <Description>IM - Skype</Description>
        <DisplayOrder>5</DisplayOrder>
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/skype</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:photos.photo</ClaimURI>
        <DisplayName>Photo</DisplayName>
        <AttributeID>photoUrl</AttributeID>
        <Description>Photo</Description>
        <DisplayOrder>5</DisplayOrder>
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/photourl</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:photos.thumbnail</ClaimURI>
        <DisplayName>Photo - Thumbnail</DisplayName>
        <AttributeID>thumbnail</AttributeID>
        <Description>Photo - Thumbnail</Description>
        <DisplayOrder>5</DisplayOrder>
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/thumbnail</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:addresses.home</ClaimURI>
        <DisplayName>Address - Home</DisplayName>
        <AttributeID>localityAddress</AttributeID>
        <Description>Address - Home</Description>
        <DisplayOrder>5</DisplayOrder>
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/addresses.locality</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:addresses.work</ClaimURI>
        <DisplayName>Address - Work</DisplayName>
        <AttributeID>region</AttributeID>
        <Description>Address - Work</Description>
        <DisplayOrder>5</DisplayOrder>
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/region</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:groups</ClaimURI>
        <DisplayName>Groups</DisplayName>
        <AttributeID>groups</AttributeID>
        <Description>Groups</Description>
        <DisplayOrder>5</DisplayOrder>
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/groups</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:entitlements.default</ClaimURI>
        <DisplayName>Entitlements</DisplayName>
        <AttributeID>entitlements</AttributeID>
        <Description>Entitlements</Description>
        <DisplayOrder>5</DisplayOrder>
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/entitlements</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:roles.default</ClaimURI>
        <DisplayName>Roles</DisplayName>
        <AttributeID>roles</AttributeID>
        <Description>Roles</Description>
        <DisplayOrder>5</DisplayOrder>
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/role</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:x509Certificates.default</ClaimURI>
        <DisplayName>X509Certificates</DisplayName>
        <AttributeID>x509Certificates</AttributeID>
        <Description>X509Certificates</Description>
        <DisplayOrder>5</DisplayOrder>
        <SupportedByDefault />
        <MappedLocalClaim>http://wso2.org/claims/x509Certificates</MappedLocalClaim>
    </Claim>
</Dialect>
```

### `application-authentication.xml` file 

Stored in the <IS_HOME>/repository/conf/identity folder.

Add the following parameter within the FacebookAuthenticator tag.

```
<!--<Parameter name="ClaimDialectUri">http://wso2.org/facebook/claims</Parameter>-->
```

Add the following parameter within the relevant tags of the following authenticators:
MobileConnectAuthenticator, EmailOTP, SMSOTP and totp

```
<Parameter name="redirectToMultiOptionPageOnFailure">false</Parameter>
```

### `entitlement.properties` file 

Stored in the <IS_HOME>/repository/conf/identity folder.

WSO2 IS 5.4.0 introduces a set of new XACML policies that load at server startup when the PAP.Policy.Add.Start.Enable property is set to true.
Therefore, when you upgrade to IS 5.4.0, follow one of the steps below depending on whether you want to add the new policies:

-   If you want to add the new policies on server startup, set both PDP.Balana.Config.Enable and PAP.Policy.Add.Start.Enable properties to true.
-   If you do not want to add the new policies on server startup, set both PDP.Balana.Config.Enable and PAP.Policy.Add.Start.Enable properties to false.

> **Note**
>
> If you set the PDP.Balana.Config.Enable property to false, while the PAP.Policy.Add.Start.Enable property is set to true, the server does not look for the balana-config.xml file on startup. This results in an error as follows because the balana-config.xml file includes functions required by the new XACML policies:
> 
> ```
> TID: [-1234] [] [2018-01-01 01:16:37,547] ERROR
> {org.wso2.carbon.identity.entitlement.EntitlementUtil}
> Error while adding sample XACML policies
> java.lang.IllegalArgumentException: Error while parsing start up policy
> ```