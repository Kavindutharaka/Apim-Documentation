# WSO2 Open Banking Berlin (Upgrading from 1.3.0 to 1.3.3)

- Go to the API Publisher (`https://<WSO2_OB_APIM_HOST>:9443/publisher`), add the following API properties to the already deployed APIs and republish them. For more information, see [Deploying APIs for Berlin](https://docs.wso2.com/display/OB150/Deploying+APIs+for+Berlin).

| **Property Name** | **Property Value**  |
|-------------------|---------------------|
| ob-spec           | berlin              |
| ob-api-type       | psd2                |
