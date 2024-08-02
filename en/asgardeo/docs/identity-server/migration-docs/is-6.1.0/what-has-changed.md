# What Has Changed
WSO2 Identity Server 6.1.0 brings a range of improvements. The following aspects have changed in WSO2 IS 6.1.0 compared to the previous WSO2 IS versions.

This page provides details about the behavioral changes from WSO2 IS version 6.0.0 to 6.1.0.

> **If you are migrating from an older version of Identity Server**
>
> To find the changes introduced in the previous versions, you can refer to the following documents:
>  - **What Has Changed in IS 6.0.0**
>  - **What Has Changed in IS 5.11.0**
>  - **What Has Changed in IS 5.10.0**
>  - **What Has Changed in IS 5.9.0**
>  - **Migrating Configurations to IS 5.8.0** section in the **Upgrading From an Older Version of WSO2 IS** document

## Enable account locking for the TOTP authenticator
With WSO2 IS 6.1.0, account locking will be enabled by default for invalid login attempts through the TOTP authenticator. With this change, the user account will be locked if the user tries to log in by entering invalid TOTP codes exceeding the configured maximum failed attempt count.

If you need to disable account locking for the TOTP authenticator, add the following configuration to the `deployment.toml` file.

``` java
[authentication.authenticator.totp.parameters]
EnableAccountLockingForFailedAttempts = false
```

## Error headers of rest APIs
With WSO2 IS 6.1.0, the `realm user` field will not be available in the `www-Authenticate` header for rest API error responses.

If you need to have the `WWW-Authenticate` header with the `realm user` variable, add the following configuration to the `deployment.toml` file.

```java
[rest_api_authentication]
add_realm_user_to_error = true
```

> **Note**
>
> Even though the above configuration adds the realm user variable, it will not be sent in the 401 error response to adhere to the [HTTP specification](https://httpwg.org/specs/rfc9110.html#rfc.section.11.6.1).

## New email template for account activation
With WSO2 IS 6.1.0, users will receive a confirmation email on successful account activation after a user completes the ask password flow.

When you migrate from a previous version, you need to [add an email template](https://is.docs.wso2.com/en/6.1.0/guides/tenants/customize-automated-mails/#add-an-email-template-type) to be able to use this feature. Be sure to use `accountActivationSuccess` as the **Template Type Display Name** for the email template that you add.

## Adaptive script cookie format change
With WSO2 IS 6.1.0, the method of encrypting the adaptive script cookie has changed to ensure better security. With this change, the previously created cookies will be invalidated and need to be created again.

If you need to revert to the previous behavior where the old cookies remain valid and the older encryption method is used, add the following config to the `deployment.toml` file.

> **Important**
>
> In WSO2 IS versions 5.11.0 and 6.0.0, you can use the parameters listed below for the specified methods if you want to use special characters in cookie values. If these parameters are enabled in your WSO2 IS 5.11.0 or WSO2 IS 6.0.0 version, do not use the `enableAdaptiveScriptCookieLegacyMode=true` configuration in the `deployment.toml` when you migrate to the latest.
>
> | Method | Parameter |
> |--------|-----------|
> | `setCookie` | `encryptWithoutDecoding : true` |
> | `getCookieValue` | `decryptWithoutEncoding : true` |
>

```java
[system.parameter]
enableAdaptiveScriptCookieLegacyMode=true
```

## Masking logs
With WSO2 IS 6.1.0, sensitive information on log files are masked at the time of logging.

If a user needs to disable the masking, they have to apply the following config into the `deployment.toml` and restart the server.

```java
[masking_logs]
enabled = false
```




