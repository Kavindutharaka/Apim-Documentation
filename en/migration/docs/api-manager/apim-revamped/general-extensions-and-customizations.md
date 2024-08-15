# Extensions and Customizations Migration Process

This document outlines the migration process required to migrate extensions and customizations when upgrading APIM from an older version to a newer version.

It's essential to note that migrating extensions and customizations is more complex than resource and artifact migration. Simply copying and pasting custom jars or dependency jars between versions may not be enough due to potential changes in APIs and extension points. As a result, the level of effort in this step will vary based on the extent of customization in your current API-M Deployment.

## Guidelines

- Identify all the customizations you have used in the current API-M deployment.

- Check if your customizations are now supported out-of-the-box in the latest version. You can refer to the [What has Changed](what-has-changed.md) document and the official [API-M documentation](https://apim.docs.wso2.com/en/latest/get-started/about-this-release/) for this purpose. If you need assistance, don't hesitate to reach out to [WSO2 Support](https://support.wso2.com/jira/secure/Dashboard.jspa).

- **If your customizations are already available in the latest version**, you can ignore these customizations in the new version.

- **If any custom requirement is not available in the latest version**, you'll need to migrate the customization to support the latest product version.
  
- **If you currently operate a distributed deployment and are planning to transition to a distributed deployment**, you are required to move all customizations and extensions from each existing profile and its corresponding new profile.

- **In case of a K8s deployment,** in the previous version's K8s environment, you may have mounted custom artifacts and/or you may have created custom product Docker images with the jars embedded. You can adopt the same approach used in previous versions when applying customizations.