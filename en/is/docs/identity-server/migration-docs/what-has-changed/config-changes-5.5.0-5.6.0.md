# Configuration Changes - WSO2 IS 5.5.0 to 5.6.0

Listed below are the configuration and behavioral changes from WSO2 IS version 5.5.0 to 5.6.0.

- [Configuration changes](#configuration-changes)

## Configuration changes

Listed below are the configuration changes from WSO2 IS version 5.5.0 to 5.6.0.

### `carbon.xml` file 

Stored in the <IS_HOME>/repository/conf folder.

Change the version property value to 5.6.0.

```
<Version>5.6.0</Version>
```

Add the following new property within the `<cache>` tag. Setting this property to true enables local cache invalidation for clustered nodes.

```
<ForceLocalCache>false</ForceLocalCache>
```

### `axis2.xml` file 

Stored in the <IS_HOME>/repository/conf/axis2 folder.

Change the following property values to 5.6.0.

```
<parameter name="userAgent" locked="true">
        WSO2 Identity Server-5.6.0
</parameter>
<parameter name="server" locked="true">
    WSO2 Identity Server-5.6.0
</parameter>
```

### `application-authentication.xml` file 

Stored in the <IS_HOME>/repository/conf/identity folder.

Add the following new property within the root tag.

```
<AuthenticationEndpointMissingClaimsURL>/authenticationendpoint/claims.do</AuthenticationEndpointMissingClaimsURL>
```

### `entitlement.properties` file 

Stored in the <IS_HOME>/repository/conf/identity folder.

Add the following property. Setting this property to true will shorten the SAML JSON response format.

```
JSON.Shorten.Form.Enabled=false
```

### `identity.xml` file 

Stored in the <IS_HOME>/repository/conf/identity folder.

Add the following properties within the `<JDBCPersistenceManager><SessionDataPersist>` tag. These configurations are relevant for cleaning
temporary authentication context data after each authentication flow.

```
<TempDataCleanup>
    <!-- Enabling separated cleanup for temporary authentication context data -->
    <Enable>true</Enable>
    <!-- When PoolZize > 0, temporary data which have no usage after the authentication flow will be deleted immediately
                 When PoolZise = 0, data will be deleted only by the scheduled cleanup task-->
    <PoolSize>20</PoolSize>
    <!-- All temporary authentication context data older than CleanUpTimeout value are considered as expired
                and would be deleted during cleanup task -->
    <CleanUpTimeout>40</CleanUpTimeout>
</TempDataCleanup>
```

Add the following property within the `<OAuth>` tag for OAuth key hashing. For more information, see [Setting Up OAuth Token Hashing](https://docs.wso2.com/display/IS560/Setting+Up+OAuth+Token+Hashing).

```
<!-- This should be true if the oauth keys (consumer secret, access token, refresh token and authorization code) need to be hashed,before storing them in the database. If the value is false, the oauth keys will be saved in a plain text format.
By default : false.
Supported versions: IS 5.6.0 onwards.
   -->
<EnableClientSecretHash>false</EnableClientSecretHash>
```

>  **Tip**
>
> Use a fresh server to enable hashing.

Add the following configurations within the `<EventListeners>` tag.

```
<!-- Audit Loggers -->
<!-- Old Audit Logger -->
<EventListener type="org.wso2.carbon.user.core.listener.UserOperationEventListener"
                       name="org.wso2.carbon.user.mgt.listeners.UserMgtAuditLogger"
                       orderId="0" enable="false"/>
<!-- New Audit Loggers-->
<EventListener type="org.wso2.carbon.user.core.listener.UserOperationEventListener"
                       name="org.wso2.carbon.user.mgt.listeners.UserManagementAuditLogger"
                       orderId="1" enable="true"/>
<EventListener type="org.wso2.carbon.user.core.listener.UserManagementErrorEventListener"
                       name="org.wso2.carbon.user.mgt.listeners.UserMgtFailureAuditLogger"
                       orderId="0" enable="true"/>
```

Add the following properties related to the validitating JWT based on JWKS capability. For more information, see [Validating JWT based on JWKS](https://docs.wso2.com/display/IS560/Validating+JWT+based+on+JWKS).

```
<!-- JWT validator configurations -->
<JWTValidatorConfigs>
    <Enable>true</Enable>
    <JWKSEndpoint>
        <HTTPConnectionTimeout>1000</HTTPConnectionTimeout>
        <HTTPReadTimeout>1000</HTTPReadTimeout>
        <HTTPSizeLimit>51200</HTTPSizeLimit>
    </JWKSEndpoint>
</JWTValidatorConfigs>
```

If you are using SCIM 1.1, disable the following SCIM 2.0 event listener.

```
<EventListener type="org.wso2.carbon.user.core.listener.UserOperationEventListener"
                        name="org.wso2.carbon.identity.scim2.common.listener.SCIMUserOperationListener"
                        orderId="93" enable="false"/>
```

If you are using SCIM 2.0, disable the following SCIM 1.1 event listener (this listener is disabled by default in 5.6.0).

```
<EventListener type="org.wso2.carbon.user.core.listener.UserOperationEventListener"
                        name="org.wso2.carbon.identity.scim.common.listener.SCIMUserOperationListener"
                        orderId="90" enable="false"/>
```

### `oidc-scope-config.xml` file 

Stored in the <IS_HOME>/repository/conf/identity folder.

Append the values "upn" and "groups" to the comma separated list within the `<Scope id="openid"><Claim>` element.

```
<Claim>
sub,email,email_verified,name,family_name,given_name,middle_name,nickname,preferred_username,upn,groups,profile,picture,website,gender,birthdate,zoneinfo,locale,updated_at,phone_number,phone_number_verified,address,street_address,country,formatted,postal_code,locality,region
</Claim>
```

These are MP-JWT supported claims. The MP-JWT 1.0 specification has introduced two claims; namely "upn" and "groups", which are mandatory to generate a JWT token that is supported by the MicroProfile JWT authentication framework.

### `catalina-server.xml` file 

Stored in the <IS_HOME>/repository/conf/tomcat folder.

Disable the following properties by setting the relevant properties to false to avoid displaying unneccessary information.

```
<!--Error pages -->
<Valve className="org.apache.catalina.valves.ErrorReportValve" showServerInfo="false" showReport="false"/>
```

### `claim-config.xml` file 

Stored in the <IS_HOME>/repository/conf/ folder.

Add the following claims within the `<`Dialect dialectURI="http://wso2.org/claims">` dialect tag.

```
<Claim>
    <ClaimURI>http://wso2.org/claims/userprincipal</ClaimURI>
    <DisplayName>User Principal</DisplayName>
    <AttributeID>uid</AttributeID>
    <Description>User Principal</Description>
</Claim>
<Claim>
    <ClaimURI>http://wso2.org/claims/extendedRef</ClaimURI>
    <DisplayName>Extended Ref</DisplayName>
    <!-- Proper attribute Id in your user store must be configured for this -->
    <AttributeID>extendedRef</AttributeID>
    <Description>Extended Ref</Description>
</Claim>
<Claim>
    <ClaimURI>http://wso2.org/claims/extendedDisplayName</ClaimURI>
    <DisplayName>Extended Display Name</DisplayName>
    <!-- Proper attribute Id in your user store must be configured for this -->
    <AttributeID>extendedDisplayName</AttributeID>
    <Description>Extended Display Name</Description>
</Claim>
<Claim>
    <ClaimURI>http://wso2.org/claims/costCenter</ClaimURI>
    <DisplayName>Cost Center</DisplayName>
    <!-- Proper attribute Id in your user store must be configured for this -->
    <AttributeID>costCenter</AttributeID>
    <Description>Cost Center</Description>
</Claim>
<Claim>
    <ClaimURI>http://wso2.org/claims/extendedExternalId</ClaimURI>
    <DisplayName>Extended External ID</DisplayName>
    <!-- Proper attribute Id in your user store must be configured for this -->
    <AttributeID>extendedExternalId</AttributeID>
    <Description>Extended External ID</Description>
</Claim>
```

Add the following claims within the `<Dialect dialectURI="http://wso2.org/oidc/claim">` dialect tag.

```
<Claim>
    <ClaimURI>upn</ClaimURI>
    <DisplayName>User Principal</DisplayName>
    <AttributeID>uid</AttributeID>
    <Description>The user principal name</Description>
    <DisplayOrder>11</DisplayOrder>
    <SupportedByDefault />
    <MappedLocalClaim>http://wso2.org/claims/userprincipal</MappedLocalClaim>
</Claim>
<Claim>
    <ClaimURI>groups</ClaimURI>
    <DisplayName>User Groups</DisplayName>
    <AttributeID>role</AttributeID>
    <Description>List of group names that have been assigned to the principal. This typically will require a mapping at the application container level to application deployment roles.</Description>
    <DisplayOrder>12</DisplayOrder>
    <SupportedByDefault />
    <MappedLocalClaim>http://wso2.org/claims/role</MappedLocalClaim>
</Claim>
```

Add the following claims within the `<Dialect dialectURI="urn:ietf:params:scim:schemas:core:2.0:User">` dialect tag.

```
<Claim>
    <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:emails</ClaimURI>
    <DisplayName>Emails</DisplayName>
    <AttributeID>mail</AttributeID>
    <Description>Email Addresses</Description>
    <DisplayOrder>5</DisplayOrder>
    <SupportedByDefault />
    <RegEx>^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$</RegEx>
    <MappedLocalClaim>http://wso2.org/claims/emailaddress</MappedLocalClaim>
</Claim>
<Claim>
    <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:phoneNumbers</ClaimURI>
    <DisplayName>Phone Numbers</DisplayName>
    <AttributeID>phoneNumbers</AttributeID>
    <Description>Phone Numbers</Description>
    <DisplayOrder>5</DisplayOrder>
    <SupportedByDefault/>
    <RegEx>^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$</RegEx>
    <MappedLocalClaim>http://wso2.org/claims/phoneNumbers</MappedLocalClaim>
</Claim>
<Claim>
    <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:photos</ClaimURI>
    <DisplayName>Photo</DisplayName>
    <AttributeID>photos</AttributeID>
    <Description>Photo</Description>
    <DisplayOrder>5</DisplayOrder>
    <SupportedByDefault />
    <MappedLocalClaim>http://wso2.org/claims/photos</MappedLocalClaim>
</Claim>
<Claim>
    <ClaimURI>urn:ietf:params:scim:schemas:core:2.0:User:addresses</ClaimURI>
    <DisplayName>Address</DisplayName>
    <AttributeID>addresses</AttributeID>
    <Description>Address</Description>
    <DisplayOrder>5</DisplayOrder>
    <SupportedByDefault />
    <MappedLocalClaim>http://wso2.org/claims/addresses</MappedLocalClaim>
</Claim>
```

Replace the following property values within the urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:employeeNumber claim URI.

```
<Claim>
    <ClaimURI>urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:employeeNumber</ClaimURI>
    <DisplayName>Employee Number</DisplayName>
    <AttributeID>extendedExternalId</AttributeID>
    <Description>Employee Number</Description>
    <Required />
    <DisplayOrder>1</DisplayOrder>
    <SupportedByDefault />
    <MappedLocalClaim>http://wso2.org/claims/extendedExternalId</MappedLocalClaim>
</Claim>
```

Replace the following property values within the urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:costCenter claim URI.

```
<Claim>
    <ClaimURI>urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:costCenter</ClaimURI>
    <DisplayName>Cost Center</DisplayName>
    <AttributeID>costCenter</AttributeID>
    <Description>Cost Center</Description>
    <Required />
    <DisplayOrder>1</DisplayOrder>
    <SupportedByDefault />
    <MappedLocalClaim>http://wso2.org/claims/costCenter</MappedLocalClaim>
</Claim>
```

Replace the following property values within the urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:manager.$ref claim URI.

```
<Claim>
    <ClaimURI>urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:manager.$ref</ClaimURI>
    <DisplayName>Manager - home</DisplayName>
    <AttributeID>extendedRef</AttributeID>
    <Description>Manager - home</Description>
    <Required />
    <DisplayOrder>1</DisplayOrder>
    <SupportedByDefault />
    <MappedLocalClaim>http://wso2.org/claims/extendedRef</MappedLocalClaim>
</Claim>
```

Replace the following property values within the urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:manager.displayName claim URI.

```
<Claim>
    <ClaimURI>urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:manager.displayName</ClaimURI>
    <DisplayName>Manager - Display Name</DisplayName>
    <AttributeID>extendedDisplayName</AttributeID>
    <Description>Manager - Display Name</Description>
    <Required />
    <DisplayOrder>1</DisplayOrder>
    <SupportedByDefault />
    <MappedLocalClaim>http://wso2.org/claims/extendedDisplayName</MappedLocalClaim>
</Claim>
```

Add the following claims within the root tag. This new claim dialect and the claims within it are required for eiDAS.

For more information, see [eIDAS SAML Attribute Profile Support via WSO2 Identity Server](https://docs.wso2.com/display/IS560/eIDAS+SAML+Attribute+Profile+Support+via+WSO2+Identity+Server).

```
<Dialect dialectURI="http://eidas.europa.eu/attributes/naturalperson">
    <Claim>
        <ClaimURI>http://eidas.europa.eu/attributes/naturalperson/PersonIdentifier</ClaimURI>
        <DisplayName>Person Identifier</DisplayName>
        <AttributeID>scimId</AttributeID>
        <Description>Person Identifier</Description>
        <Required/>
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault/>
        <MappedLocalClaim>http://wso2.org/claims/userid</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>http://eidas.europa.eu/attributes/naturalperson/CurrentFamilyName</ClaimURI>
        <DisplayName>Current Family Name</DisplayName>
        <AttributeID>sn</AttributeID>
        <Description>Current Family Name</Description>
        <Required/>
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault/>
        <MappedLocalClaim>http://wso2.org/claims/lastname</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>http://eidas.europa.eu/attributes/naturalperson/CurrentGivenName</ClaimURI>
        <DisplayName>Current Given Name</DisplayName>
        <AttributeID>givenName</AttributeID>
        <Description>Current Given Name</Description>
        <Required/>
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault/>
        <MappedLocalClaim>http://wso2.org/claims/givenname</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>http://eidas.europa.eu/attributes/naturalperson/DateOfBirth</ClaimURI>
        <DisplayName>Date of birth</DisplayName>
        <AttributeID>dateOfBirth</AttributeID>
        <Description>Date of birth</Description>
        <Required/>
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault/>
        <MappedLocalClaim>http://wso2.org/claims/dob</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>http://eidas.europa.eu/attributes/naturalperson/BirthName</ClaimURI>
        <DisplayName>Birth Name</DisplayName>
        <AttributeID>uid</AttributeID>
        <Description>Birth Name</Description>
        <Required/>
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault/>
        <MappedLocalClaim>http://wso2.org/claims/username</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>http://eidas.europa.eu/attributes/naturalperson/PlaceOfBirth</ClaimURI>
        <DisplayName>Place of Birth</DisplayName>
        <AttributeID>country</AttributeID>
        <Description>Place of Birth</Description>
        <Required/>
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault/>
        <MappedLocalClaim>http://wso2.org/claims/country</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>http://eidas.europa.eu/attributes/naturalperson/CurrentAddress</ClaimURI>
        <DisplayName>Current Address</DisplayName>
        <AttributeID>localityAddress</AttributeID>
        <Description>Current Address</Description>
        <Required/>
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault/>
        <MappedLocalClaim>http://wso2.org/claims/addresses</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>http://eidas.europa.eu/attributes/naturalperson/Gender</ClaimURI>
        <DisplayName>Gender</DisplayName>
        <AttributeID>gender</AttributeID>
        <Description>Gender</Description>
        <Required/>
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault/>
        <MappedLocalClaim>http://wso2.org/claims/gender</MappedLocalClaim>
    </Claim>
</Dialect>
<Dialect dialectURI="http://eidas.europa.eu/attributes/legalperson">
    <Claim>
        <ClaimURI>http://eidas.europa.eu/attributes/legalperson/LegalPersonIdentifier</ClaimURI>
        <DisplayName>Legal Person Identifier</DisplayName>
        <AttributeID>extendedExternalId</AttributeID>
        <Description>Legal Person Identifier</Description>
        <Required/>
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault/>
        <MappedLocalClaim>http://wso2.org/claims/extendedExternalId</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>http://eidas.europa.eu/attributes/legalperson/LegalName</ClaimURI>
        <DisplayName>Legal Person Name</DisplayName>
        <AttributeID>extendedDisplayName</AttributeID>
        <Description>Legal Person Name</Description>
        <Required/>
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault/>
        <MappedLocalClaim>http://wso2.org/claims/extendedDisplayName</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>http://eidas.europa.eu/attributes/legalperson/LegalPersonAddress</ClaimURI>
        <DisplayName>Legal Person Address</DisplayName>
        <AttributeID>localityAddress</AttributeID>
        <Description>Legal Person Address</Description>
        <Required/>
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault/>
        <MappedLocalClaim>http://wso2.org/claims/addresses</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>http://eidas.europa.eu/attributes/legalperson/VATRegistrationNumber</ClaimURI>
        <DisplayName>VAT Registration Number</DisplayName>
        <AttributeID>im</AttributeID>
        <Description>VAT Registration Number</Description>
        <Required/>
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault/>
        <MappedLocalClaim>http://wso2.org/claims/im</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>http://eidas.europa.eu/attributes/legalperson/TaxReference</ClaimURI>
        <DisplayName>Tax Reference</DisplayName>
        <AttributeID>postalcode</AttributeID>
        <Description>Tax Reference</Description>
        <Required/>
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault/>
        <MappedLocalClaim>http://wso2.org/claims/postalcode</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>http://eidas.europa.eu/attributes/legalperson/D-2012-17-EUIdentifier</ClaimURI>
        <DisplayName>EU Identifier</DisplayName>
        <AttributeID>externalId</AttributeID>
        <Description>EU Identifier</Description>
        <Required/>
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault/>
        <MappedLocalClaim>http://wso2.org/claims/externalid</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>http://eidas.europa.eu/attributes/legalperson/LEI</ClaimURI>
        <DisplayName>LEI</DisplayName>
        <AttributeID>extendedRef</AttributeID>
        <Description>LEI</Description>
        <Required/>
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault/>
        <MappedLocalClaim>http://wso2.org/claims/extendedRef</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>http://eidas.europa.eu/attributes/legalperson/EORI</ClaimURI>
        <DisplayName>Economic Operator Registration and Identification</DisplayName>
        <AttributeID>departmentNumber</AttributeID>
        <Description>Economic Operator Registration and Identification</Description>
        <Required/>
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault/>
        <MappedLocalClaim>http://wso2.org/claims/department</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>http://eidas.europa.eu/attributes/legalperson/SEED</ClaimURI>
        <DisplayName>System for Exchange of Excise Data Identifier</DisplayName>
        <AttributeID>nickName</AttributeID>
        <Description>System for Exchange of Excise Data Identifier</Description>
        <Required/>
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault/>
        <MappedLocalClaim>http://wso2.org/claims/nickname</MappedLocalClaim>
    </Claim>
    <Claim>
        <ClaimURI>http://eidas.europa.eu/attributes/legalperson/SIC</ClaimURI>
        <DisplayName>Standard Industrial Classification</DisplayName>
        <AttributeID>nickName</AttributeID>
        <Description>Standard Industrial Classification</Description>
        <Required/>
        <DisplayOrder>1</DisplayOrder>
        <SupportedByDefault/>
        <MappedLocalClaim>http://wso2.org/claims/nickname</MappedLocalClaim>
    </Claim>
</Dialect>
```