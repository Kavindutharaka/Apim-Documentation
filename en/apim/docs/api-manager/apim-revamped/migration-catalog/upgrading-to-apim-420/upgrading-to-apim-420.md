# Upgrading to API Manager 4.2.0

To start the migration you are required to perform the following,


1. Follow the [API-M Migration Guidelines](../../general-guidelines.md) to get an understanding of the API-M migration process.

2. Understand what has changed between the API-M versions
   - Go through [what-has-changed](../../what-has-changed.md/#major-changes-in-api-manager-420) document and identify major changes between versions. 
   - Find more details about the API-M 4.2.0 release on the [About this release](https://apim.docs.wso2.com/en/4.2.0/get-started/about-this-release/) page.

3. Download [WSO2 API Manager 4.2.0](https://wso2.com/api-manager) and unzip it. From this point onward this directory will be referred as `<API-M_4.2.0_HOME>` directory.

4. Update API-M 4.2.0 to the [latest U2](https://apim.docs.wso2.com/en/4.2.0/administer/updating-wso2-api-manager/#wso2-updates-20) update level. 

   - **If you have a planning to have a distributed deployment**, make sure to create separate copies of APIM for profiles, optimize each as per the [documentation](https://apim.docs.wso2.com/en/4.2.0/install-and-setup/setup/distributed-deployment/product-profiles/#method-1-optimizing-before-starting-the-server), and then update each.

   - **If you are working with a K8s deployment**, ensure you use the latest Docker images of the latest API-M version. Refer to the [API-M K8s documentation](https://apim.docs.wso2.com/en/latest/install-and-setup/install/deploying-api-manager-with-kubernetes-or-openshift-resources/) for guidance.


5. Follow the relevant out of the following to continue the migration process.
    - [Upgrading from API-M 3.0.0 to 4.2.0](upgrading-from-300-to-420/upgrading-from-300-to-420.md)
    - [Upgrading from API-M 3.1.0 to 4.2.0](upgrading-from-310-to-420/upgrading-from-310-to-420.md)
    - [Upgrading from API-M 3.2.0 to 4.2.0](upgrading-from-320-to-420/upgrading-from-320-to-420.md)
    - [Upgrading from API-M 4.0.0 to 4.2.0](upgarding-from-400-to-420/upgrading-from-400-to-420.md)
    - [Upgrading from API-M 4.1.0 to 4.2.0](upgrading-from-410-to-420/upgrading-from-410-to-420.md)
