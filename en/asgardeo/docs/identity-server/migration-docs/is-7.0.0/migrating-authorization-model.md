# Migrating Authorization Model

In the prior versions of WSO2 Identity Server, including 6.1.0, the model of roles and permissions/scopes is used for authorization. Authorization of customer scopes is handled using OAuth2 scopes and role bindings. Authorization of system scopes is handled using internal permissions (using scopes corresponding to permissions) and role to permission assignments.

From IS 7.0.0 onwards, the above authorization capabilities are facilitated using,
- API Resources capable of representing both customer APIs and system APIs and the corresponding scopes.
- API authorization capability that allows authorizing API resources to applications.
- Role to scope assignments.

For more information, Refer to the documentation on [API Authorization](https://is.docs.wso2.com/en/latest/guides/authorization/api-authorization/api-authorization/)

IS 7.0.0 introduces the V2 implementation of roles with audience support enabling you to create both organization audience roles and application audience roles.

For more information, Refer to documentation on [Roles](https://is.docs.wso2.com/en/latest/guides/users/manage-roles/)

Additionally, prior versions of IS including 6.1.0 used IdP role to local role mapping capability for federated user authorization. From IS 7.0.0 onwards, IdP groups capability will be used for the authorization of federated users.

For more information, Refer to documentation on [Managing connections](https://is.docs.wso2.com/en/latest/guides/authentication/#manage-connections)

Additionally, SaaS behavior of the Console and Myaccount applications are changed to non SaaS behavior with the new authorization model.

With the above changes to the authorization model, following migrations are needed to be done to migrate the existing authorization model to the new authorization model.

- Associating tenants to organizations. (This is needed for providing the B2B capabilities and organization audience support of the roles.)
- Migrating the existing roles to V2 roles for audience support and assigning the migrated roles to all the applications.
- Creating system API Resources to represent internal scopes.
- Representing OAuth2 scopes using an API Resource named `User-defined-oauth2-resource` created in each tenant.
- Creating Console and Myaccount applications in each tenant for non SaaS behavior and creating Administrator roles for Console access in each tenant.
- Authorizing the system APIs to management applications considering previous access level.
- Authorizing the created API Resource named `User-defined-oauth2-resource` for OAuth2 scopes in all existing applications.
- Assigning the internal scopes to roles based on the existing permissions of the roles.
- Assigning the OAuth2 scopes to roles based on the existing role bindings of the scopes.
- Migrating the IdP roles to IdP groups and IdP role to local role mappings to IdP groups to local role assignments.
- Migrating the permissions created in applications if there are scope bindings available for those permissions.

Above migrations related to authorization model change will be handled through the migration client.
