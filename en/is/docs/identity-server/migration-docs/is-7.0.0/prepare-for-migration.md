# Preparing for migration

Before you start the migration, see the instructions given here.

> **Note**
>
> In this section, `<OLD_IS_HOME>` is the directory where the current WSO2 Identity Server resides in, and `<NEW_IS_HOME>` is the directory where WSO2 Identity Server 6.1.0 resides in.

## Prerequisites

1. Review what has changed in this release. For a detailed list of changes from WSO2 IS version 6.1.0 to 7.0.0, see the document on [What Has Changed](what-has-changed.md).

2. Before you migrate, refer to the **Migration Process** document to get an understanding of the migration process.

## Prepare for tenant qualified URLs and tenanted Sessions

>**Note :** This preparation is only applicable if you are migrating from a multi-tenant setup.

WSO2 Identity Server now supports tenant-qualified URLs for all the endpoints exposed from the product. This enables clear
isolation between tenants; especially with managing non conflicting tenant bound user sessions and provides the
capability to easily configure routing rules.

Application in tenants except the super tenant should be prepared to support the tenanted qualified URLs.

Migration details are included in the
[Migrating applications for tenanted qualified URLs](migrating-applications-for-tenanted-qualified-urls.md) document. This should be done before the migration process.

## Prepare for Groups and Roles separation

>**Note :** This preparation is only applicable if you are migrating from a prior version before WSO2 Identity Server 5.11.0 or from a new version without enabling group role separation migration.

With WSO2 Identity Server 5.11.0, groups and roles are separated. For more information, see the document on [What Has Changed in 5.11.0](../is-5.11.0/migrating-what-has-changed.md). Also, you may or may not have opted not to use the new groups and roles feature in your WSO2 IS 5.11.0, WSO2 IS 6.0.0 or WSO2 IS 6.1.0 migrations.

>**Note :** The group role separation is now mandatory from WSO2 IS 7.0.0 onwards.

### Overview

Following changes have been made to the product claims.

<table>
    <tr>
        <th>Claim</th>
        <th>Change</th>
        <th>Description</th>
    </tr>
    <tr>
        <td>wso2.role</td>
        <td>Modified</td>
        <td>
            <ul>
                <li>Removed <b>supported by default</b>.</li>
                <li>Updated display name to <b>Roles and groups</b>.</li>
                <li>Updated description to <b>Include both userstore groups and internal roles</b>.</li>
            </ul>
        </td>
    </tr>
    <tr>
        <td>wso2.roles</td>
        <td>New</td>
        <td>
            <ul>
                <li>Display name: <b>Roles</b>.</li>
                <li>AttributionID <b>Roles</b>.</li>
                <li>Description <b>Roles</b>.</li>
            </ul>
        </td>
    </tr>
    <tr>
        <td>wso2.roles</td>
        <td>New</td>
        <td>
            <ul>
                <li>Display name: <b>Roles</b>.</li>
                <li>AttributionID <b>Roles</b>.</li>
                <li>Description <b>Roles</b>.</li>
                <li><b>Supported by default</b> configured as <code>true</code>.</li>
                <li><b>read-only</b> configured as <code>true</code>.</li>
            </ul>
        </td>
    </tr>
    <tr>
        <td>wso2.groups</td>
        <td>Modified</td>
        <td>
            <ul>
                <li><b>Supported by default</b> configured as <code>true</code>.</li>
                <li><b>read-only</b> configured as <code>true</code>.</li>
            </ul>
        </td>
    </tr>
    <tr>
        <td>OIDC group</td>
        <td>Modified</td>
        <td>
            Mapped local claim to the <code>wso2.groups</code> claim.
        </td>
    </tr>
    <tr>
        <td>OIDC roles</td>
        <td>New</td>
        <td>
            Mapped to the <code>wso2.roles</code> local claim.
        </td>
    </tr>
    <tr>
        <td>SCIM2 roles.default</td>
        <td>Modified</td>
        <td>
            Mapped to the <code>wso2.roles</code> local claim.
        </td>
    </tr>
</table>

Note that the following abbreviations are used in the sections below.

* wso2.role claim = http://wso2.org/claims/role
* wso2.roles claim = http://wso2.org/claims/roles
* wso2.groups claim = http://wso2.org/claims/groups

### Enable Groups and Roles separation

Consider the following with the enablement of the groups and roles separation.

> **Note**
>
> * All claim configurations are already configured OOTB in the fresh pack and will be done via the migration client for migrating deployments. No need to configure these manually.
> * Any custom external claim mapped to the wso2.role claim should be mapped to either wso2.roles or wso2.groups claim as per the requirement of the custom use case.
> * Our recommendation is to fix any consuming client to become compatible with these changes. But if somehow the above configs need to be reverted (possibly in a migrated deployment), it can be done via the Identity Server [Claim Management REST APIs](https://is.docs.wso2.com/en/6.1.0/apis/claim-management-rest-api/).

-   **Utilizing carbon kernel level support**

    The following abstract userstore manager APIs: `getUserClaimValues()`, `getUsersClaimValues()`,
    `getUserClaimValuesWithID()`, `getUsersClaimValuesWithID()` now support both ```wso2.roles``` and ```wso2.groups``` claims properly. We recommend modifying custom extensions to request wso2.roles or wso2.groups via the above APIs rather depending on wso2.role claim.

-   **Service provider role mapping and identity provider role mapping restrictions**

    We recommend removing existing SP and IdP role mappings that use groups, and utilize roles to achieve the same functionality.

-   **OIDC group claim return groups**

    OIDC group claim does not return internal roles anymore. We recommend modifying applications and custom extensions to utilize this behavior. If roles are required, use the OIDC roles claim.

-   **Obtaining roles via the SAML assertion**

    We recommend applications and custom extensions to switch from wso2.role to the wso2.roles claim in the SAML assertion.

-   **SCIM2 roles.default claim returns roles and groups claim return groups**

    Previously, the ```roles.default``` claim in SCIM2 returned both groups and roles as it was mapped to the wso2.roles claim. It is now mapped to the ```wso2.roles``` claim, where only roles are returned. In order to get groups, `urn:ietf:params:scim:schemas:core:2.0:User:groups` claim should be used instead since, with this improvement, it is returning groups as intended.

-   **Groups and roles in SCIM2 user response**

    Previously users and roles in the SCIM2 user response returned as a single comma-separated entity. However, that has changed, and now they return as separate complex entities. We recommend modifying clients that consume this response.

## Disabling versioning in the registry configuration
If there are frequently updating registry properties, having the versioning enabled for
registry resources in the registry can lead to unnecessary growth in the registry-related
tables in the database. To avoid this, we have disabled versioning by default from WSO2 Identity
Server 6.0.0 onward.

Therefore, when migrating to WSO2 IS 7.0.0 from a version prior to IS 6.0.0, it is **required** to turn off the registry versioning in your current WSO2 IS and run the below scripts against the database that is used by the registry.

> **Turning off registry versioning in your current WSO2 IS and running the scripts**
>
> Open the `registry.xml` file in the `<OLD_IS_HOME>/repository/conf` directory. Set the `versioningProperties`, `versioningComments`, `versioningTags` and `versioningRatings` false.
>
>   ```
>   <staticConfiguration>
>         <versioningProperties>false</versioningProperties>
>         <versioningComments>false</versioningComments>
>         <versioningTags>false</versioningTags>
>         <versioningRatings>false</versioningRatings>
>   </staticConfiguration>
>   ```
>
>>  **Warning**
>>
>>  If the above configurations are already set as `false`, you should not run the below scripts.
>
>  When the above configurations are turned off, we need to remove the versioning details from the database in order for the registry resources to work properly. Select the relevant DB type and run the script against the DB where the registry resides.
>
>   **DB Scripts**
>
>   The following database scripts are provided by the WSO2 team.
>
>   | DB type      | Script name |
>   | ----------- | ----------- |
>   | H2      | `1_H2.h2.db`     |
>   | DB2   | `2_DB2.db2`        |
>   | MSSQL | `3_MSSQL.sql` |
>   | MySQL | `4_MySQL.sql` |
>   | Oracle | `5_Oracle.sql` |
>   | PostgreSQL | `6_PostgreSQL.sql` |
