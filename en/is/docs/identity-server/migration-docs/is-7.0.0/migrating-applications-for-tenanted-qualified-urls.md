# Migrating applications for tenanted qualified URLs

>**Note :**
>This section is only applicable for multi-tenant setups.

WSO2 Identity Server 7.0.0 enables tenant qualified URLs and tenanted sessions in the applications. This enables clear
isolation between tenants; especially with managing non-conflicting tenant bound user sessions and provides the 
capability to easily configure routing rules. 

The applications used in tenants except the super tenant
should be migrated to support the tenant qualified URLs by updating the server endpoints with the tenanted path.

For example, the `/authorize` endpoint for the tenant `abc.com` should be updated as 
`https://localhost:9443/t/abc.com/oauth2/authorize`.
