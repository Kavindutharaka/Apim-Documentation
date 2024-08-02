# Fraud Detection

Fraud Detection is for transaction monitoring mechanisms to detect unauthorized or fraudulent transactions and generate alerts. It also exempts the security requirements of strong customer authentication based on the identified level of risk and recurrence of the payment transaction.

Open the `<WSO2_OB_KM_HOME>/repository/conf/finance/open-banking.xml` and `<WSO2_OB_APIM_HOME>/repository/conf/finance/open-banking.xml` files to enable Fraud Detection:

1. Set the `<IsEnabled>` property under `<FraudDetection>` to true to enable the feature.

2. Replace the `<WSO2_OB_BI_HOST>` place holder with the hostname of the Business Intelligence server.

    ```
    <BIServer>
        <!-- Include all configurations related to OBBI component -->
        <FraudDetection>
            <!-- Include all configurations related to Fraud Detection -->
 
            <!-- Enable FD in WSO2 Open Banking-->
            <IsEnabled>true</IsEnabled>
            <!-- Configurations related to FD Receivers-->
            <Receivers>
                <!-- Administrator username to login to the remote BI server. -->
                <Username>admin@wso2.com@carbon.super</Username>
                <!-- Administrator password to login to the remote BI server. -->
                <Password>wso2123</Password>
                <!-- Receiver URLs of the Siddhi Apps used to validate for FD.-->
                <FraudDetectionURL>http://<WSO2_OB_BI_HOST>:8007/FraudDetectionApp/FraudDetectionStream</FraudDetectionURL>
                <InvalidSubmissionURL>http://<WSO2_OB_BI_HOST>:8006/InvalidSubmissionsApp/InvalidSubmissionsStream</InvalidSubmissionURL>
            </Receivers>
        </FraudDetection>
    </BIServer>
    ```

3. Open the `<WSO2_OB_BI_HOME>/deployment/siddhi-files/FraudStatusUpdaterApp.siddhi` file and update `<localhost>` in the receiver URL with the hostname of your WSO2 OB BI server.

4. Open the `<WSO2_OB_BI_HOME>/conf/dashboard/deployment.yaml`. Add the `APIM-alerts.enabled` and `wso2-is-analytics` configurations under `analytics.solutions` and set as `false`. Once you add the configurations, the `deployment.yaml` file should be as follows:

```
    analytics.solutions:
        IS-analytics.enabled: false
        APIM-analytics.enabled: true
        EI-analytics.enabled: false
        APIM-alerts.enabled: false
        wso2-is-analytics: false
```

5. Open the `<WSO2_OB_BI_HOME>/conf/worker/deployment.yaml` file and configure `auth.configs`:

    - username: `admin@wso2.com@carbon.super`
    - password: `d3NvMjEyMw==` (Password is `wso2123`. Make sure you encode the password with Base64).

    ```
    auth.configs:
        type: 'local'
        userManager:
            adminRole: admin
            userStore:
                users:
                -
                    user:
                        username: admin@wso2.com@carbon.super
                        password: d3NvMjEyMw==
                        roles: 1
                roles:
                -
                    role:
                        id: 1
                        displayName: admin
    ```

6. Once you configure the TRA and FD modules, start the servers in the order of:

    1. Dashboard profile in WSO2 OB BI
    2. Worker profile in WSO2 OB BI
    3. WSO2 OB KM
    4. WSO2 OB APIM