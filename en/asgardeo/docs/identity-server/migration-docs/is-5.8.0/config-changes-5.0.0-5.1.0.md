# Configuration Changes - WSO2 IS 5.0.0 to 5.1.0

Listed below are the configuration and behavioral changes from WSO2 IS version 5.0.0 to 5.1.0.

- [Configuration changes](#configuration-changes)
- [API changes](#api-changes)
- [Recommendations](#recommended)

## Configuration changes

Listed below are the configuration changes from WSO2 IS version 5.0.0 to 5.1.0.

### `axis2.xml` file

Stored in the <PRODUCT_HOME>/repository/conf/axis2/ directory.

-   The following new parameter was added: 

    ```
    <parameter name="httpContentNegotiation">true</parameter>. 
    ```

    When this is set to 'true' , the server will determine the contentType of responses to requests, by using the 'Accept header' of the request. 
    
### `identity.xml` file 

Stored in the <PRODUCT_HOME>/repository/conf/identity directory.

1.  The `<TimeConfig>` element was added. This element contains a global session timeout configuration. To configure session timeouts and remember me periods tenant wise, see [Configuring Session Timeout](https://docs.wso2.com/display/IS510/Configuring+Session+Timeout).
2.  The `<SessionTimeout>` parameter under the `<OpenID>` element and the `<SSOService>` element was removed. This configuration is no longer a constant across all service providers. With Identity Server 5.1.0, you can define the session timeout and remember me period tenant wise using the management console. For more information on how to do this, see [Configuring Session Timeout](https://docs.wso2.com/display/IS510/Configuring+Session+Timeout).

### `tenant-axis2.xml` file 

Stored in the <PRODUCT_HOME>/repository/conf/tomcat/ directory.

The default value for the "httpContentNegotiation" parameter is set to 'true': `<parameter name="httpContentNegotiation">true</parameter>`.

### `catalina-server.xml` file 

Stored in the <PRODUCT_HOME>/repository/conf/tomcat/ directory.

1.  Keystore parameters were added under the `<Connector>` element as shown below. This setting allows you to use separate keystore and security certificates to certify SSL connections. Note that the location and password of the default "wso2carbon.jks" keystore is given for these parameters by default.

    ```
    keystoreFile=location of the keystore file
    keystorePass=password for the keystore
    ```

2.  The ciphers parameter under the `<Connector>` element was removed. Depending on the java version you are using, you can define ciphers using the [Configuring Transport Level Security](https://docs.wso2.com/display/Carbon443/Configuring+Transport+Level+Security) page as a guide.

3.  The clientAuth parameter setting under the `<Connector>` element was changed from clientAuth="false" to clientAuth="want". Setting this parameter to false makes the two-way SSL authentication optional and uses it in instances when it is possible i.e., if you need to disable the certification authentication in certain occasions (e.g., mobile applications). This is recommended since setting it to 'false' will simply disable certificate authentication completely and not use it even when it is possible. The `<Host>` element was removed. It was added to fix XSS and CSRF vulnarabilities in WSO2-CARBON-PATCH-4.2.0-1256. For information on how to fix these vulnerabilities in IS 5.1.0, see the following pages:

    -   [Mitigating Cross Site Request Forgery (CSRF) Attacks](https://docs.wso2.com/display/IS510/Mitigating+Cross+Site+Request+Forgery+%28CSRF%29+Attacks) 
    -   [Mitigating Carriage Return Line Feed (CRLF)](https://docs.wso2.com/display/IS510/Mitigating+Carriage+Return+Line+Feed+%28CRLF%29+Attacks)
    -   [Mitigating Cross Site Scripting (XSS) Attacks](https://docs.wso2.com/display/IS510/Mitigating+Cross+Site+Scripting+%28XSS%29+Attacks)

### `master-datasources.xml` file 

Stored in the <PRODUCT_HOME>/repository/conf/datasources/ directory.

Default auto-commit setting for a data source is set to false: 

```
<defaultAutoCommit>false</defaultAutoCommit>
```

### `carbon.xml` file 

Stored in the <PRODUCT_HOME>/repository/conf/ directory. 

-   New parameters to define proxy context path as shown below;

    ```	
    <MgtProxyContextPath></MgtProxyContextPath>
    <ProxyContextPath></ProxyContextPath>
    ```

    Proxy context path is a useful parameter to add a proxy path when a Carbon server is fronted by a reverse proxy. In addition to the proxy host and proxy port this parameter allows you to add a path component to external URLs. See [Adding a Custom Proxy Path](https://docs.wso2.com/display/Carbon430/Adding+a+Custom+Proxy+Path) for details.

-   The following port configurations was removed:

    ```
    <!-- Embedded Qpid broker ports →
    <EmbeddedQpid>
    <!-- Broker TCP Port →
    <BrokerPort>5672</BrokerPort>
    <!-- SSL Port →
    <BrokerSSLPort>8672</BrokerSSLPort>
    </EmbeddedQpid>
    ```

-   In Carbon 4.2.0, the following registry keystore configuration was required for configuring the keystore keys that certify encrypting/decrypting meta data to the registry. From Carbon 4.3.0 onwards the primary keystore configuration shown below will be used for this purpose as well. Therefore, it is not necessary to use a separate registry keystore configuration for encrypting/decrypting meta data to the registry. Read more about [keystore configurations in Carbon 4.3.0](https://docs.wso2.com/display/Carbon430/Configuring+Keystores+in+WSO2+Products).

    ```
    <RegistryKeyStore>
                <!-- Keystore file location-->
                <Location>${carbon.home}/repository/resources/security/wso2carbon.jks</Location>
                <!-- Keystore type (JKS/PKCS12 etc.)-->
                <Type>JKS</Type>
                <!-- Keystore password-->
                <Password>wso2carbon</Password>
                <!-- Private Key alias-->
                <KeyAlias>wso2carbon</KeyAlias>
                <!-- Private Key password-->
                <KeyPassword>wso2carbon</KeyPassword>
    </RegistryKeyStore>
    ```

### `user-mgt.xml` file 

Stored in the<PRODUCT_HOME>/repository/conf/ directory.

The following property was added under the `<Configuration>` tag. If you are connecting the database from a previous version of IS, set this property to false. 

```
<Property name="isCascadeDeleteEnabled">true</Property>
```

The following properties under the `<UserStoreManager>` tag were changed as follows:

-   The `<BackLinksEnabled>` property was added. If this property is set to 'true', it enables an object that has a reference to another object to inherit the attributes of the referenced object.
-   The following property was added. It provides flexibility to customize the error message.
	
    ```
    <Property name="UsernameJavaRegExViolationErrorMsg">Username pattern policy violated</Property>
                <Property name="PasswordJavaRegEx">^[\S]{5,30}$</Property>
    ```

-   The `<IsBulkImportSupported>` property was added. It specifies whether to enable or disable bulk user import.
-   The following properties were added. They provide flexibility to customize the connection pooling parameters.

    ```
    <Property name="ConnectionPoolingEnabled">false</Property>
                <Property name="LDAPConnectionTimeout">5000</Property>
                <Property name="ReadTimeout"/>
                <Property name="RetryAttempts"/>
    ```

### `registry.xml` file 

Stored in the <PRODUCT_HOME>/repository/conf/ directory.

The default value was changed to 'false' for the following setting: `<versionResourcesOnChange>false</versionResourcesOnChange>`.

### `authenticators.xml` file 

Stored in the <PRODUCT_HOME>/repository/conf/security directory.

The following parameter was added under the `<Authenticator>` element to specify the AssertionConsumerServiceURL. This is an optional parameter and is used by the requesting party to build the request. For more information, see [Authenticators Configuration](https://docs.wso2.com/display/IS510/How+To%3A+Login+to+WSO2+Products+via+Identity+Server#HowTo:LogintoWSO2ProductsviaIdentityServer-Authenticatorsconfiguration).

```
<Parameter name="AssertionConsumerServiceURL">https://localhost:9443/acs</Parameter>
```

## API changes

The following section describes changes made to admin services in IS 5.1.0 which may affect your migration depending on your client's usage of the admin service.

Removed authorization and changed input parameters of the changePasswordByUser operation exposed through the userAdmin service. 

**Changes to the changePasswordByUser operation**

Make the following change to the client side:

Remove the username and password as authentication headers in the request and send the username, old password and new password inside the SOAP body instead. A sample of the request is shown below.

```
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://org.apache.axis2/xsd">
   <soapenv:Header/>
   <soapenv:Body>
      <xsd:changePasswordByUser>
         <!--Optional:-->
         <xsd:userName>admin</xsd:userName>
         <!--Optional:-->
         <xsd:oldPassword>adminpassword</xsd:oldPassword>
         <!--Optional:-->
         <xsd:newPassword>adminnewpassword</xsd:newPassword>
      </xsd:changePasswordByUser>
   </soapenv:Body>
</soapenv:Envelope>
```

-   How it used to be

    This operation was previously an admin service where the user had to be authenticated before running the operation (i.e, only a user with login permissions could perform a password change). In that case, the user had to use an authentication mechanism (his/her username and current password) to execute the operation and the input parameters were as follows:

    - old password
    - new password

-   How it is now

    Authentication is no longer required for this operation, which means all users (including those without login permissions) can perform this operation. Therefore, the input parameters are now as follows:

    - username (username of the user whose password needs to be changed)
    - old password
    - new password

## Recommended

Note that the following files located in the <IS_HOME>/repository/conf/ folder in 5.0.0 have been moved to the <IS_HOME>/repository/conf/identity/ folder in 5.1.0 onwards:

- provisioning-config.xml
- identity.xml
- /security/identity-mgt.properties