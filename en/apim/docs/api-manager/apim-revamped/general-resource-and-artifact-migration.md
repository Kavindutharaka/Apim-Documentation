# Resource and Artifact Migration Process

During this step, we'll be migrating various resources and artifacts from the older version of API-M to the newer one. 

You will be able to **simply copy certain resources from the previous API-M and place them in the appropriate folders in the newer version**. Please consult the steps under resource and artifact migration to determine precisely what needs to be copied and transferred to the new version.

Please note that this step doesn't cover migrating customizations and extensions, as it will be addressed later.

## Guidelines

- Please only transfer the specified resources and artifacts outlined in this step. Refrain from moving any other resources between versions, as certain resources are automatically generated within the new version during the data migration process. 
  - For instance, you should not manually transfer tenant folders from the old version to the new one. These folders will be created automatically during the subsequent data migration process, which is explained later.

- **If you are using a K8s deployment**, you may need to create a custom product image by copying the required resources and artifacts, and then use that image for deployment.