# Configuration Changes - WSO2 IS 5.4.0 to 5.5.0

Listed below are the configuration and behavioral changes from WSO2 IS version 5.4.0 to 5.5.0.

- [Configuration changes](#configuration-changes)

## Configuration changes

Listed below are the configuration changes from WSO2 IS version 5.4.0 to 5.5.0.

### `carbon.xml` file 

Stored in the <IS_HOME>/repository/conf folder.

Change the version property value to 5.5.0.

```
<Version>5.5.0</Version>
```

### `application-authentication.xml` file 

Stored in the <IS_HOME>/repository/conf/identity folder.

Replace the following property found within the  `<Extensions>` list.

> If you are using a custom `<StepBasedSequenceHandler>`, skip this step.

```
<StepBasedSequenceHandler>org.wso2.carbon.identity.application.authentication.framework.handler.sequence.impl.DefaultStepBasedSequenceHandler</StepBasedSequenceHandler>
```

with the one given below.

```
<StepBasedSequenceHandler>org.wso2.carbon.identity.application.authentication.framework.handler.sequence.impl.GraphBasedSequenceHandler</StepBasedSequenceHandler>
```

If you are using a custom authorization handler, see the content on Migrating Custom Authorization Handlers.

The OpenIDAuthenticator is no longer available. Remove the following configurations that are related to it.

Remove the following property found within the `<AuthenticatorNameMappings>` tag.

```
<AuthenticatorNameMapping name="OpenIDAuthenticator" alias="openid" />
```

Remove the whole configuration block that starts with the config given below found within the `<AuthenticatorConfigs>` tag.

```
<AuthenticatorConfig name="OpenIDAuthenticator" enabled="true">
.....
.....
</AuthenticatorConfig>
```

Replace the AuthenticatorConfig block for the MobileConnectAuthenticator found within the `<AuthenticatorConfigs>` tag, with the following configuration.

```
<AuthenticatorConfig name="MobileConnectAuthenticator" enabled="true">
    <Parameter name="MCAuthenticationEndpointURL">mobileconnectauthenticationendpoint/mobileconnect.jsp</Parameter>
    <Parameter name="MCDiscoveryAPIURL">https://discover.mobileconnect.io/gsma/v2/discovery/</Parameter>
    <Parameter name="redirectToMultiOptionPageOnFailure">false</Parameter>
</AuthenticatorConfig>
```

Remove the following property found within the `<AuthenticatorNameMappings>` tag. The AuthorizationHandler property has been removed from this file for newer versions of this product.

```
<AuthorizationHandler>org.wso2.carbon.identity.application.authz.xacml.handler.impl.XACMLBasedAuthorizationHandler</AuthorizationHandler>
```

### `identity-event.properties` file 

Stored in the <IS_HOME>/repository/conf/identity folder.

Add the following properties that are required for Request Object Support. For more information about the feature, see [Request Object Support](https://docs.wso2.com/display/IS550/Request+Object+Support).

```
module.name.11=handleRequestObject
handleRequestObject.subscription.1=POST_REVOKE_ACESS_TOKEN
handleRequestObject.subscription.2=POST_REVOKE_CODE
handleRequestObject.subscription.3=POST_REVOKE_ACESS_TOKEN_BY_ID
handleRequestObject.subscription.4=POST_REVOKE_CODE_BY_ID
handleRequestObject.subscription.5=POST_REFRESH_TOKEN
handleRequestObject.subscription.6=POST_ISSUE_CODE
handleRequestObject.subscription.7=POST_ISSUE_ACCESS_TOKEN
```

Add the following properties to enable the user event handler used to delete user consents when users are deleted.

```
module.name.12=user.consent.delete
user.consent.delete.subscription.1=POST_DELETE_USER
user.consent.delete.receipt.search.limit=500
```

### `identity.xml` file 

Stored in the <IS_HOME>/repository/conf/identity folder.

Remove the `<ClientAuthHandlers>` code block found within the `<OAuth>` tag. From WSO2 IS 5.5.0 onwards, client authentication is handled differently. For more information, see the introduction of the [Writing A New OAuth Client Authenticator](https://docs.wso2.com/display/IS550/Writing+A+New+OAuth+Client+Authenticator) topic.

```
<ClientAuthHandlers>
    <ClientAuthHandler Class="org.wso2.carbon.identity.oauth2.token.handlers.clientauth.BasicAuthClientAuthHandler">
        <Property Name="StrictClientCredentialValidation">false</Property>
    </ClientAuthHandler>
</ClientAuthHandlers>
```

Add the following property within the `<ScopeValidators>` tag. For more information about the XACML based scope validator, see [Validating the Scope of OAuth Access Tokens using XACML Policies](https://docs.wso2.com/display/IS550/Validating+the+Scope+of+OAuth+Access+Tokens+using+XACML+Policies).

> To migrate custom scope validators, see the topic on **Migrating Custom Scope Validators**.

```
<ScopeValidator class="org.wso2.carbon.identity.oauth2.validators.xacml.XACMLScopeValidator"/>
```

Add the following property within the `<OpenIDConnect>` tag to enable the service provider wise audience configuration. For more information about this, see

> This feature requires a new database table that is created when running the migration script. If you do not wish to use this feature, you can set the value of the property given below to false.

```
<EnableAudiences>true</EnableAudiences>
```

Add the following property within the `<OpenIDConnect>` tag.

```
<LogoutTokenExpiration>120</LogoutTokenExpiration>
```

Add the following property within the `<EventListeners>` tag.

```
<EventListener type="org.wso2.carbon.user.core.listener.UserOperationEventListener"
                       name="org.wso2.carbon.user.mgt.listeners.UserDeletionEventListener"
                       orderId="98" enable="false"/>
```

Add the following code block within the root tag after the `<EventListeners>` code block. For more information about this configuration, see [Tracking user deletion on deleting a user](https://docs.wso2.com/display/IS550/Configuring+Users#ConfiguringUsers-Trackinguserdeletionondeletingauser).

```
<UserDeleteEventRecorders>
    <UserDeleteEventRecorder name="org.wso2.carbon.user.mgt.recorder.DefaultUserDeletionEventRecorder" enable="false">
        <!-- Un comment below line if you need to write entries to a separate .csv file. Otherwise this will be
            written in to a log file using a separate appender. -->
        <!--<Property name="path">${carbon.home}/repository/logs/delete-records.csv</Property>-->
    </UserDeleteEventRecorder>
</UserDeleteEventRecorders>
```

Do the following configuration changes to enable fine grained access control introduced with Identity Server 5.5.0

Remove the following property found within the `<ResourceAccessControl>` tag.

```
<Resource context="(.*)/api/identity/user/(.*)" secured="true" http-method="all"/>
```

Add the following set of resources within the < ResourceAccessControl> tag.

```
<Resource context="(.*)/api/identity/user/v1.0/validate-code" secured="true" http-method="all"/>
<Resource context="(.*)/api/identity/user/v1.0/resend-code" secured="true" http-method="all"/>
<Resource context="(.*)/api/identity/user/v1.0/me" secured="true" http-method="POST"/>
<Resource context="(.*)/api/identity/user/v1.0/me" secured="true" http-method="GET"/>
<Resource context="(.*)/api/identity/user/v1.0/pi-info" secured="true" http-method="all">
    <Permissions>/permission/admin/manage/identity/usermgt/view</Permissions>
</Resource>
<Resource context="(.*)/api/identity/user/v1.0/pi-info/(.*)" secured="true" http-method="all">
    <Permissions>/permission/admin/manage/identity/usermgt/view</Permissions>
</Resource>
<Resource context="(.*)/api/identity/consent-mgt/v1.0/consents" secured="true" http-method="all"/>
<Resource context="(.*)/api/identity/consent-mgt/v1.0/consents/receipts/(.*)" secured="true" http-method="all"/>
<Resource context="(.*)/api/identity/consent-mgt/v1.0/consents/purposes" secured="true" http-method="POST">
    <Permissions>/permission/admin/manage/identity/consentmgt/add</Permissions>
</Resource>
<Resource context="(.*)/api/identity/consent-mgt/v1.0/consents/purposes(.*)" secured="true" http-method="GET"/>
<Resource context="(.*)/api/identity/consent-mgt/v1.0/consents/purposes(.+)" secured="true" http-method="DELETE">
    <Permissions>/permission/admin/manage/identity/consentmgt/delete</Permissions>
</Resource>
<Resource context="(.*)/api/identity/consent-mgt/v1.0/consents/pii-categories" secured="true" http-method="POST">
    <Permissions>/permission/admin/manage/identity/consentmgt/add</Permissions>
</Resource>
<Resource context="(.*)/api/identity/consent-mgt/v1.0/consents/pii-categories(.*)" secured="true" http-method="GET"/>
<Resource context="(.*)/api/identity/consent-mgt/v1.0/consents/pii-categories(.+)" secured="true" http-method="DELETE">
    <Permissions>/permission/admin/manage/identity/consentmgt/delete</Permissions>
</Resource>
<Resource context="(.*)/api/identity/consent-mgt/v1.0/consents/purpose-categories" secured="true" http-method="POST">
    <Permissions>/permission/admin/manage/identity/consentmgt/add</Permissions>
</Resource>
<Resource context="(.*)/api/identity/consent-mgt/v1.0/consents/purpose-categories(.*)" secured="true" http-method="GET"/>
<Resource context="(.*)/api/identity/consent-mgt/v1.0/consents/purpose-categories(.+)" secured="true" http-method="DELETE">
    <Permissions>/permission/admin/manage/identity/consentmgt/delete</Permissions>
</Resource>
```

Replace the following property found within the `<WebApp>` tag under the `<TenantContextsToRewrite>` tag.

```
<Context>/api/identity/user/v0.9/</Context>
```

with the one given below

```
<Context>/api/identity/user/v1.0/</Context>
```

Add the following new property within the `<WebApp>` tag found under the `<TenantContextsToRewrite>` tag.

```
<Context>/api/identity/consent-mgt/v1.0/</Context>
```

Add the following code block within the root tag after the `<SSOService>` code block.

This configuration specifies whether consent management should be enabled during single sign-on authentication. For more information, see [Consent Management with Single-Sign-On](https://docs.wso2.com/display/IS550/Consent+Management+with+Single-Sign-On).

```
<Consent>
    <!--Specify whether consent management should be enable during SSO.-->
    <EnableSSOConsentManagement>true</EnableSSOConsentManagement>
</Consent>
```

Add the following code block within the  `<OAuth>`  tag. This configuration is used  to specify the grant types that filter claims based on user consents. The grant types given below are out-of-the-box grant types that prompt the user for consent.

```
<!--Defines the grant types that will filter user claims based on user consent in their responses such as id_token or user info response.Default grant types that filter user claims based on user consent are 'authorization_code' and 'implicit'.
Supported versions: IS 5.5.0 onwards. -->
  
<UserConsentEnabledGrantTypes>
    <UserConsentEnabledGrantType>
        <GrantTypeName>authorization_code</GrantTypeName>
    </UserConsentEnabledGrantType>
    <UserConsentEnabledGrantType>
        <GrantTypeName>implicit</GrantTypeName>
    </UserConsentEnabledGrantType>
</UserConsentEnabledGrantTypes>
```

### `log4j.properties` file 

Stored in the <IS_HOME>/repository/conf folder.

Add the following properties.

```
log4j.logger.DELETE_EVENT_LOGGER=INFO, DELETE_EVENT_LOGFILE
log4j.appender.DELETE_EVENT_LOGFILE=org.apache.log4j.FileAppender
log4j.appender.DELETE_EVENT_LOGFILE.File=${carbon.home}/repository/logs/delete-event.log
log4j.appender.DELETE_EVENT_LOGFILE.Append=true
log4j.appender.DELETE_EVENT_LOGFILE.layout=org.apache.log4j.PatternLayout
log4j.appender.DELETE_EVENT_LOGFILE.layout.ConversionPattern=%m %n
log4j.appender.DELETE_EVENT_LOGFILE.threshold=INFO
log4j.additivity.DELETE_EVENT_LOGFILE=false
```

### `provisioning-config.xml` file 

Stored in the <IS_HOME>/repository/conf/identity folder.

Remove the `<scim-providers>` and `<scim-consumers>` code blocks from the file.