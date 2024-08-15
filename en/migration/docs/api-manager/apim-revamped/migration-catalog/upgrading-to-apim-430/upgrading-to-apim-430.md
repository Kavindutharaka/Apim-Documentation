# Upgrading to API Manager 4.3.0

To start the migration you are required to perform the following,

> **Important**
>
>   **If you are migrating from a version prior to 4.2.0**, you need to first migrate to 4.2.0 and then migrate to the latest version. For example, if you are migrating from 3.2.0 to 4.3.0, you need to first migrate to 4.2.0 and then migrate to 4.3.0.


1. Follow the [API-M Migration Guidelines](../../general-guidelines.md) to get an understanding of the API-M migration process.

2. Find more details about the API-M 4.3.0 release on the [About this release](https://apim.docs.wso2.com/en/latest/get-started/about-this-release/) page.

3. Download [WSO2 API Manager 4.3.0](https://wso2.com/api-manager) and unzip it. From this point onward this directory will be referred as `<API-M_4.3.0_HOME>` directory.

4. Update API-M 4.3.0 to the [latest U2](https://apim.docs.wso2.com/en/latest/administer/updating-wso2-api-manager/#wso2-updates-20) update level.

    - **If you have a plan to configure a distributed deployment**, make sure to create separate copies of APIM for profiles, optimize each as per the [documentation](https://apim.docs.wso2.com/en/latest/install-and-setup/setup/distributed-deployment/product-profiles/#method-1-optimizing-before-starting-the-server), and then update each.

    - **If you are working with a K8s deployment**, ensure you use the latest Docker images of the latest API-M version. Refer to the [API-M K8s documentation](https://apim.docs.wso2.com/en/latest/install-and-setup/install/deploying-api-manager-with-kubernetes-or-openshift-resources/) for guidance.


5. Navigate through the following link and follow the instructions to continue the migration process.
    - [Upgrading from API-M 4.2.0 to 4.3.0](upgrading-from-420-to-430/upgrading-from-420-to-430.md)

