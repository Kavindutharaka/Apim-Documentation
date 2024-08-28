# Configuration Changes - WSO2 IS 5.2.0 to 5.3.0

Listed below are the configuration and behavioral changes from WSO2 IS version 5.2.0 to 5.3.0.

- [Behavioral changes](#behavioral-changes)
- [Configuration changes](#configuration-changes)

## Behavioral changes

Due to a fix done in this release, the effective default value of the system property 
org.apache.xml.security.ignoreLineBreaks has been changed from “true” to “false”. 
Due to this change, you will observe line breaks in SAML responses.

However, if the SAML response consuming client applications have used a standard 
library such as OpenSAML and use canonicalization when processing the response, 
this should not cause any problems. Therefore, our recommendation is to use a 
standard library to process SAML responses on consuming applications.

If you have any concerns about this behavioral change or if the SAML response 
consuming client applications does not use canonicalization when processing the 
response and the client cannot be updated to do so, add the following jvm parameter 
to the server startup script located in the <IS_HOME>/bin/ folder to revert back to 
the previous behavior.

```
-Dorg.apache.xml.security.ignoreLineBreaks=true
```

## Configuration changes

Listed below are the configuration changes from WSO2 IS version 5.2.0 to 5.3.0.

### `carbon.xml` file 

> **Mandatory**

Stored in the <PRODUCT_HOME>/repository/conf/ directory.

Add the following property to the config file.

```
<HideMenuItemIds>
<HideMenuItemId>claim_mgt_menu</HideMenuItemId>
<HideMenuItemId>identity_mgt_emailtemplate_menu</HideMenuItemId>
<HideMenuItemId>identity_security_questions_menu</HideMenuItemId>
</HideMenuItemIds>
```

Update the following property value to 5.3.0.

```
<Version>5.3.0</Version>
```

### `entitlement.properties` file 

> **Optional**

Stored in the <PRODUCT_HOME>/repository/conf/identity/ directory.

If you are using the service provider authorization feature, add the following property to the config file.

> If you have any other AttributeDesignators configured with the number 2, use the smallest unused number instead of 2 when adding the property below.

```
PIP.AttributeDesignators.Designator.2=org.wso2.carbon.identity.application.authz.xacml.pip.AuthenticationContextAttributePIP
```

### `application-authentication.xml` file 

> **Mandatory**

Stored in the <PRODUCT_HOME>/repository/conf/identity/ directory.

Add the following property under the `<Extensions>` tag.

```
<AuthorizationHandler>org.wso2.carbon.identity.application.authz.xacml.handler.impl.XACMLBasedAuthorizationHandler</AuthorizationHandler>
```

### `application-authentication.xml` file 

> **Optional**

Stored in the <PRODUCT_HOME>/repository/conf/identity/ directory.

If you are using the mobile connect authenticator feature, add the following element under the `<AuthenticatorConfigs>` tag.

```
<AuthenticatorConfig name="MobileConnectAuthenticator" enabled="true">
    <Parameter name="MobileConnectKey">mobileConnectClientId</Parameter>
    <Parameter name="MobileConnectSecret">mobileConnectClientSecret</Parameter>
</AuthenticatorConfig>
```

### `Owasp.CsrfGuard.Carbon.properties` 

> **Mandatory**

Stored in the <PRODUCT_HOME>/repository/conf/security/ directory.

Find the following line.

**Old configuration**

```
org.owasp.csrfguard.unprotected.authiwa=%servletContext%/commonauth/iwa/*
```

Update the line as follows.

**New Configuration**

```
org.owasp.csrfguard.unprotected.oauthiwa=%servletContext%/commonauth/iwa/*
```

Add the following property.

```
org.owasp.csrfguard.unprotected.mex=%servletContext%/mexut/*
```

### `user-mgt.xml` file 

> **Mandatory**

Stored in the <PRODUCT_HOME>/repository/conf/ directory.

Add the following element under the `<Realm> <Configuration>` tag.

```
<Property name="initializeNewClaimManager">true</Property>
```

### `email-admin-config.xml` file 

> **Mandatory**

Stored in the <PRODUCT_HOME>/repository/conf/ directory.

If you have not made any custom changes to this file in your previous version of WSO2 IS:

-   Copy the <NEW_IS_HOME>/repository/conf/email/email-admin-config.xml file and replace the existing one.

If you have made custom changes to this file in your previous version:

1.  Locate the templates you have updated that differ from the default config file. You can use a diff tool to compare your <OLD_IS_HOME>/repository/conf/email/email-admin-config.xml file with the default file to identify the custom changes you have made. Note these changes/updates.

2.  Copy the file from <NEW_IS_HOME>/repository/conf/email/email-admin-config.xml to <OLD_IS_HOME>/repository/conf/email/ directory and rename it to email-"admin-config-new.xml".

3.  For each template you have modified, do the following:

    > **Note**
    >
    > If you opt to migrate to the new identity management implementation, follow all the steps below. If you wish to continue with the old identity management implementation, skip steps iii and iv.

    1.  Locate the relevant template configuration in the old email-admin-config-new.xml file by searching for `<configuration type="xxxxx" where “xxxxx”>` is the type at email-admin-config.xml.

    2.  Update the subject, body, and footer in the new config file with the values from the existing configuration.

    3.  [OPTIONAL] Update the placeholders so that they are enclosed with double braces (E.g., {user-name} -> {user-name} )

    4.  [OPTIONAL] Update the user’s attribute related placeholders to follow the {user.claim.yyyy} format where yyyy is the attribute name (E.g., {first-name} -> {user.claim.givenname})

4.  Delete the <OLD_IS_HOME>/repository/conf/email/email-admin-config.xml file and rename the email-admin-config-new.xml file to "email-admin-config.xml” to finish the update.

> For more information about this feature, see [Email Templates](https://docs.wso2.com/display/IS530/Email+Templates).

### `output-event-adapters.xml` file 

> **Optional**

Stored in the <PRODUCT_HOME>/repository/conf/ directory.

Add the following properties under the `<outputEventAdaptersConfig>` tag.

```
<adapterConfig type="wso2event">
    <property key="default.thrift.tcp.url">tcp://localhost:7612</property 
    <property key="default.thrift.ssl.url">ssl://localhost:7712</property>
    <property key="default.binary.tcp.url">tcp://localhost:9612</property>
    <property key="default.binary.ssl.url">ssl://localhost:9712</property>
</adapterConfig>
```

### `identity.xml` file 

> **Mandatory**

Stored in the <PRODUCT_HOME>/repository/conf/identitydirectory.

Add the following event listeners as child elements under the `<EventListeners>` tag.

```
<EventListeners>
    ....
    ....
    <EventListener
    type="org.wso2.carbon.user.core.listener.UserOperationEventListener"
    name="org.wso2.carbon.identity.governance.listener.IdentityStoreEventListener"
    orderId="97" enable="true">
    <Property name="Data.Store">org.wso2.carbon.identity.governance.store.JDBCIdentityDataStore</Property>
    </EventListener>
             
    <EventListener
    type="org.wso2.carbon.user.core.listener.UserOperationEventListener"
    name="org.wso2.carbon.identity.governance.listener.IdentityMgtEventListener"
    orderId="95"
    enable="true"/>
    ....
</EventListeners>
```

Add the following properties under the `<OAuth>` tag.

```
<OIDCWebFingerEPUrl>${carbon.protocol}://${carbon.host}:${carbon.management.port}/.well-known/webfinger</OIDCWebFingerEPUrl>
 
<!-- For tenants below urls will be modified as https://<hostname>:<port>/t/<tenant domain>/<path>-->
<OAuth2DCREPUrl>${carbon.protocol}://${carbon.host}:${carbon.management.port}/identity/connect/register</OAuth2DCREPUrl>
<OAuth2JWKSPage>${carbon.protocol}://${carbon.host}:${carbon.management.port}/oauth2/jwks</OAuth2JWKSPage>
<OIDCDiscoveryEPUrl>${carbon.protocol}://${carbon.host}:${carbon.management.port}/oauth2/oidcdiscovery</OIDCDiscoveryEPUrl>
```

Add the following property under the `<SSOService>` tag.

```
<!--<SAMLSSOAssertionBuilder>org.wso2.carbon.identity.sso.saml.builders.assertion.ExtendedDefaultAssertionBuilder</SAMLSSOAssertionBuilder>-->
```

Add the following properties at the top level.

```
<!--Recovery>
        <Notification>
            <Password>
                <Enable>false</Enable>
            </Password>
            <Username>
                <Enable>false</Enable>
            </Username>
            <InternallyManage>true</InternallyManage>
        </Notification>
        <Question>
            <Password>
                <Enable>false</Enable>
                <NotifyStart>true</NotifyStart>
                <Separator>!</Separator>
                <MinAnswers>2</MinAnswers>
                <ReCaptcha>
                    <Enable>true</Enable>
                    <MaxFailedAttempts>3</MaxFailedAttempts>
                </ReCaptcha>
            </Password>
        </Question>
        <ExpiryTime>3</ExpiryTime>
        <NotifySuccess>true</NotifySuccess>
        <AdminPasswordReset>
            <Offline>false</Offline>
            <OTP>false</OTP>
            <RecoveryLink>false</RecoveryLink>
        </AdminPasswordReset>
    </Recovery>
 
    <EmailVerification>
        <Enable>false</Enable>
        <LockOnCreation>false</LockOnCreation>
        <Notification>
            <InternallyManage>true</InternallyManage>
        </Notification>
    </EmailVerification>
 
    <SelfRegistration>
    <Enable>false</Enable>
    <LockOnCreation>false</LockOnCreation>
    <Notification>
        <InternallyManage>true</InternallyManage>
    </Notification>
    <ReCaptcha>false</ReCaptcha>
    </SelfRegistration-->
    ```

Remove the following section:

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

Add the following properties to the top level.

```
<ResourceAccessControl>
        <Resource context="(.*)/api/identity/user/(.*)" secured="true" http-method="all"/>
        <Resource context="(.*)/api/identity/recovery/(.*)" secured="true" http-method="all"/>
        <Resource context="(.*)/.well-known(.*)" secured="true" http-method="all"/>
        <Resource context="(.*)/identity/register(.*)" secured="true" http-method="all">
            <Permissions>/permission/admin/manage/identity/applicationmgt/delete</Permissions>
        </Resource>
        <Resource context="(.*)/identity/connect/register(.*)" secured="true" http-method="all">
            <Permissions>/permission/admin/manage/identity/applicationmgt/create</Permissions>
        </Resource>
        <Resource context="(.*)/oauth2/introspect(.*)" secured="true" http-method="all">
            <Permissions>/permission/admin/manage/identity/applicationmgt/view</Permissions>
        </Resource>
        <Resource context="(.*)/api/identity/entitlement/(.*)" secured="true" http-method="all">
            <Permissions>/permission/admin/manage/identity/pep</Permissions>
        </Resource>
    </ResourceAccessControl>
 
    <ClientAppAuthentication>
        <Application name="dashboard" hash="66cd9688a2ae068244ea01e70f0e230f5623b7fa4cdecb65070a09ec06452262"/>
    </ClientAppAuthentication>
 
    <TenantContextsToRewrite>
        <WebApp>
            <Context>/api/identity/user/v0.9</Context>
            <Context>/api/identity/recovery/v0.9</Context>
            <Context>/oauth2</Context>
            <Context>/api/identity/entitlement</Context>
        </WebApp>
        <Servlet>
            <Context>/identity/(.*)</Context>
        </Servlet>
    </TenantContextsToRewrite>
```

### `web.xml` file 

> **Optional**

Stored in the `<PRODUCT_HOME>/repository/conf/tomcat/carbon/WEB_INF` directory.

Add the following properties after the CsrfGuardHttpSessionListener.

```
<filter>
      <filter-name>CaptchaFilter</filter-name>
      <filter-class>org.wso2.carbon.identity.captcha.filter.CaptchaFilter</filter-class>
    </filter>
 
    <filter-mapping>
      <filter-name>CaptchaFilter</filter-name>
      <url-pattern>/samlsso</url-pattern>
      <url-pattern>/oauth2</url-pattern>
      <url-pattern>/commonauth</url-pattern>
      <dispatcher>FORWARD</dispatcher>
      <dispatcher>REQUEST</dispatcher>
    </filter-mapping>
```

### `catalina-server.xml` file 

> **Mandatory**

Stored in the <PRODUCT_HOME>/repository/conf/tomcat/ directory.

Add the following valves under the `<Host>` tag.

```
<!-- Authentication and Authorization valve for the rest apis and we can configure context for this in identity.xml  -->
                <Valve className="org.wso2.carbon.identity.auth.valve.AuthenticationValve"/>
                <Valve className="org.wso2.carbon.identity.authz.valve.AuthorizationValve"/>
                <Valve className="org.wso2.carbon.identity.context.rewrite.valve.TenantContextRewriteValve"/>
```

### `carbon.xml` file 

> **Optinal**

Stored in the <PRODUCT_HOME>/repository/conf/ directory.

Add the following properties after the `</Security>` tag.

```
<HideMenuItemIds>
<HideMenuItemId>identity_mgt_emailtemplate_menu</HideMenuItemId>
<HideMenuItemId>identity_security_questions_menu</HideMenuItemId>
</HideMenuItemIds>
```

### `log4j.properties` file 

> **Optional**

Stored in the <PRODUCT_HOME>/repository/conf/ directory.

Add the following property.

```
log4j.logger.org.springframework=WARN
```

### `data-agent-config.xml` file

> **Mandatory**

Stored in the <NEW_IS_HOME>/repository/conf/data-bridge directory.

Add the following properties under the `<Agent>` ThriftDataEndpoint and under the `<Agent>` BinaryDataEndpoint tags.

```
<!--<sslEnabledProtocols>TLSv1,TLSv1.1,TLSv1.2</sslEnabledProtocols>-->
<!--<ciphers>SSL_RSA_WITH_RC4_128_MD5,SSL_RSA_WITH_RC4_128_SHA,TLS_RSA_WITH_AES
_128_CBC_SHA,TLS_DHE_RSA_WITH_AES_128_CBC_SHA,TLS_DHE_DSS_WITH_AES_128_CBC_SHA,SSL
_RSA_WITH_3DES_EDE_CBC_SHA,SSL_DHE_RSA_WITH_3DES_EDE_CBC_SHA,SSL_DHE_DSS_WITH_
3DES_EDE_CBC_SHA</ciphers>-->
```

### `claim-config.xml` file 

> **Mandatory**

Stored in the <NEW_IS_HOME>/repository/conf/ directory

Replace the following attribute found under the `<Claim> <ClaimURI>http://wso2.org/claims/locality>` tag.

Replace this attribute:

```
<AttributeID>localityName</AttributeID>
```
  
with this:

```
<AttributeID>local</AttributeID>
```

Modify the following claims as follows.

```
<Claim>
  <ClaimURI>http://wso2.org/claims/userid</ClaimURI>
  <DisplayName>User ID</DisplayName>
  <AttributeID>scimId</AttributeID>
  <Description>Unique ID of the user</Description>
  <ReadOnly/>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/externalid</ClaimURI>
  <DisplayName>External User ID</DisplayName>
  <AttributeID>externalId</AttributeID>
  <Description>Unique ID of the user used in external systems</Description>
  <ReadOnly/>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/created</ClaimURI>
  <DisplayName>Created Time</DisplayName>
  <AttributeID>createdDate</AttributeID>
  <Description>Created timestamp of the user</Description>
  <ReadOnly/>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/modified</ClaimURI>
  <DisplayName>Last Modified Time</DisplayName>
  <AttributeID>lastModifiedDate</AttributeID>
  <Description>Last Modified timestamp of the user</Description>
  <ReadOnly/>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/location</ClaimURI>
  <DisplayName>Location</DisplayName>
  <AttributeID>location</AttributeID>
  <Description>Location</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/formattedName</ClaimURI>
  <DisplayName>Name - Formatted Name</DisplayName>
  <AttributeID>formattedName</AttributeID>
  <Description>Formatted Name</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/middleName</ClaimURI>
  <DisplayName>Middle Name</DisplayName>
  <AttributeID>middleName</AttributeID>
  <Description>Middle Name</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/honorificPrefix</ClaimURI>
  <DisplayName>Name - Honoric Prefix</DisplayName>
  <AttributeID>honoricPrefix</AttributeID>
  <Description>Honoric Prefix</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/honorificSuffix</ClaimURI>
  <DisplayName>Name - Honoric Suffix</DisplayName>
  <AttributeID>honoricSuffix</AttributeID>
  <Description>Honoric Suffix</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/userType</ClaimURI>
  <DisplayName>User Type</DisplayName>
  <AttributeID>userType</AttributeID>
  <Description>User Type</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/preferredLanguage</ClaimURI>
  <DisplayName>Preferred Language</DisplayName>
  <AttributeID>preferredLanguage</AttributeID>
  <Description>Preferred Language</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/local</ClaimURI>
  <DisplayName>Local</DisplayName>
  <AttributeID>local</AttributeID>
  <Description>Local</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/timeZone</ClaimURI>
  <DisplayName>Time Zone</DisplayName>
  <AttributeID>timeZone</AttributeID>
  <Description>Time Zone</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/emails.work</ClaimURI>
  <DisplayName>Emails - Work Email</DisplayName>
  <AttributeID>workEmail</AttributeID>
  <Description>Work Email</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/emails.home</ClaimURI>
  <DisplayName>Emails - Home Email</DisplayName>
  <AttributeID>homeEmail</AttributeID>
  <Description>Home Email</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/emails.other</ClaimURI>
  <DisplayName>Emails - Other Email</DisplayName>
  <AttributeID>otherEmail</AttributeID>
  <Description>Other Email</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/phoneNumbers</ClaimURI>
  <DisplayName>Phone Numbers</DisplayName>
  <AttributeID>phoneNumbers</AttributeID>
  <Description>Phone Numbers</Description>
  <RegEx>^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$</RegEx>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/phoneNumbers.home</ClaimURI>
  <DisplayName>Phone Numbers - Home Phone Number</DisplayName>
  <AttributeID>homePhone</AttributeID>
  <Description>Home Phone</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/phoneNumbers.work</ClaimURI>
  <DisplayName>Phone Numbers - Work Phone Number</DisplayName>
  <AttributeID>workPhone</AttributeID>
  <Description>Work Phone</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/phoneNumbers.fax</ClaimURI>
  <DisplayName>Phone Numbers - Fax Number</DisplayName>
  <AttributeID>fax</AttributeID>
  <Description>Fax Number</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/phoneNumbers.pager</ClaimURI>
  <DisplayName>Phone Numbers - Pager Number</DisplayName>
  <AttributeID>pager</AttributeID>
  <Description>Pager Number</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/phoneNumbers.other</ClaimURI>
  <DisplayName>Phone Numbers - Other</DisplayName>
  <AttributeID>otherPhoneNumber</AttributeID>
  <Description>Other Phone Number</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/gtalk</ClaimURI>
  <DisplayName>IM - Gtalk</DisplayName>
  <AttributeID>imGtalk</AttributeID>
  <Description>IM - Gtalk</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/skype</ClaimURI>
  <DisplayName>IM - Skype</DisplayName>
  <AttributeID>imSkype</AttributeID>
  <Description>IM - Skype</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/photos</ClaimURI>
  <DisplayName>Photo</DisplayName>
  <AttributeID>photos</AttributeID>
  <Description>Photo</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/photourl</ClaimURI>
  <DisplayName>Photo URIL</DisplayName>
  <AttributeID>photoUrl</AttributeID>
  <Description>Photo URL</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/thumbnail</ClaimURI>
  <DisplayName>Photo - Thumbnail</DisplayName>
  <AttributeID>thumbnail</AttributeID>
  <Description>Photo - Thumbnail</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/addresses</ClaimURI>
  <DisplayName>Address</DisplayName>
  <AttributeID>addresses</AttributeID>
  <Description>Address</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/addresses.formatted</ClaimURI>
  <DisplayName>Address - Formatted</DisplayName>
  <AttributeID>formattedAddress</AttributeID>
  <Description>Address - Formatted</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/streetaddress</ClaimURI>
  <DisplayName>Address - Street</DisplayName>
  <AttributeID>streetAddress</AttributeID>
  <Description>Address - Street</Description>
  <DisplayOrder>5</DisplayOrder>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/addresses.locality</ClaimURI>
  <DisplayName>Address - Locality</DisplayName>
  <AttributeID>localityAddress</AttributeID>
  <Description>Address - Locality</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/groups</ClaimURI>
  <DisplayName>Groups</DisplayName>
  <AttributeID>groups</AttributeID>
  <Description>Groups</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/identity/verifyEmail</ClaimURI>
  <DisplayName>Verify Email</DisplayName>
  <AttributeID>manager</AttributeID>
  <Description>Temporary claim to invoke email verified feature</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/identity/askPassword</ClaimURI>
  <DisplayName>Ask Password</DisplayName>
  <AttributeID>postOfficeBox</AttributeID>
  <Description>Temporary claim to invoke email ask Password feature</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/identity/adminForcedPasswordReset</ClaimURI>
  <DisplayName>Force Password Reset</DisplayName>
  <AttributeID>departmentNumber</AttributeID>
  <Description>Temporary claim to invoke email force password feature</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/entitlements</ClaimURI>
  <DisplayName>Entitlements</DisplayName>
  <AttributeID>entitlements</AttributeID>
  <Description>Entitlements</Description>
</Claim>
<Claim>
  <ClaimURI>urn:scim:schemas:core:1.0:roles</ClaimURI>
  <DisplayName>Roles</DisplayName>
  <AttributeID>roles</AttributeID>
  <Description>Roles</Description>
  <DisplayOrder>5</DisplayOrder>
  <SupportedByDefault />
  <MappedLocalClaim>http://wso2.org/claims/role</MappedLocalClaim>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/x509Certificates</ClaimURI>
  <DisplayName>X509Certificates</DisplayName>
  <AttributeID>x509Certificates</AttributeID>
  <Description>X509Certificates</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/identity/failedPasswordRecoveryAttempts</ClaimURI>
  <DisplayName>Failed Password Recovery Attempts</DisplayName>
  <AttributeID>postalCode</AttributeID>
  <Description>Number of consecutive failed attempts done for password recovery</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/identity/emailVerified</ClaimURI>
  <DisplayName>Email Verified</DisplayName>
  <!-- Proper attribute Id in your user store must be configured for this -->
  <AttributeID>postalAddress</AttributeID>
  <Description>Email Verified</Description>
</Claim>
<Claim>
  <ClaimURI>http://wso2.org/claims/identity/failedLoginLockoutCount</ClaimURI>
  <DisplayName>Failed Lockout Count</DisplayName>
  <!-- Proper attribute Id in your user store must be configured for this -->
  <AttributeID>employeeNumber</AttributeID>
  <Description>Failed Lockout Count</Description>
</Claim>
```

Remove the following claim.

```
<Claim>
  <ClaimURI>http://wso2.org/claims/identity/lastLoginTime</ClaimURI>
  <DisplayName>Last Login</DisplayName>
  <!-- Proper attribute Id in your user store must be configured for this -->
  <AttributeID>carLicense</AttributeID>
  <Description>Last Login Time</Description>
</Claim>
```

Add the following claim.

```
<ClaimURI>http://wso2.org/claims/identity/lastLogonTime</ClaimURI>
<DisplayName>Last Logon</DisplayName>
<!-- Proper attribute Id in your user store must be configured for this -->
<AttributeID>carLicense</AttributeID>
<Description>Last Logon Time</Description>
</Claim>
```

Replace the following attribute from under the `<Claim> <ClaimURI> http://wso2.org/claims/challengeQuestion1 </ClaimURI>` tag.

Replace this attribute:

```
<AttributeID>localityName</AttributeID>
```
  
with this:

```
<AttributeID>firstChallenge</AttributeID>
```

Replace the following attribute from under the the `<Claim> <ClaimURI> http://wso2.org/claims/challengeQuestion2 </ClaimURI>`.

Replace this attribute:

```
<AttributeID>localityName</AttributeID>
```
  
with this:

```
<AttributeID>secondChallenge</AttributeID>
```

Modify this claim as follows:

```
<Claim>
  <ClaimURI>http://wso2.org/claims/active</ClaimURI>
  <DisplayName>Active</DisplayName>
  <AttributeID>active</AttributeID>
  <Description>Status of the account</Description>
</Claim>
```

