# Migrating SaaS Applications

>**Note :** This section is only applicable if you are using SaaS applications in current setup and if you using the SaaS application to retrieve the system scopes to users.

In previous IS versions including 6.1.0, it was possible to create SaaS applications accessible to all users in all the tenants.
This functionality enabled users from other tenants to obtain tokens via the application.
Further, it was possible to obtain tokens with system scopes based on their roles in the respective tenants through the SaaS application.

With WSO2 IS 7.0.0, SaaS applications are deprecated with the introduction of productized B2B capabilities.
While users from other tenants can still log in via previous SaaS applications and obtain tokens, 
the new authorization model in IS 7.0.0, no longer issue system scopes to the users from other tenants.

If you are using SssS applications to issue system scopes to users from other tenants, you need to migrate the existing SaaS applications using one of the below options.

- Multi tenant mode - Application must be created in all the tenants. This changes the access URL of the application for the other tenants. IS management APIs need to be authorized and roles need to be assigned to the application.
- B2B mode - This changes the architecture of the current solution. B2B structure needs to be created and applications must be shared with the relevant organizations.

Reach out to our support team through your [support account](https://support.wso2.com/jira/secure/Dashboard.jspa) for assistance.