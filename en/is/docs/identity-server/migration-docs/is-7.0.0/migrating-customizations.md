# Migrating customizations

>**Note :**
>This section is only applicable if you have customizations in extension points of IS.
> Reach out to our support team through your [support account](https://support.wso2.com/jira/secure/Dashboard.jspa) for assistance with other customizations.

## Custom provisioning handlers

If you have written custom provisioning handlers by implementing `ProvisioningHandler` interface, you need to implement
the `handleWithV2Roles` method in the `ProvisioningHandler` interface. This method is used to handle provisioning with
V2 roles. The `handle` method is used to handle provisioning with V1 roles. The `handle` method is deprecated and it 
cannot be used to handle provisioning with V2 roles. Therefore, you need to implement the `handleWithV2Roles` method to
handle provisioning with V2 roles.
