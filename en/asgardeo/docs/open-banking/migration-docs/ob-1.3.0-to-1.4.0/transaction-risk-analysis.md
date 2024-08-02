# Transaction Risk Analysis (TRA)

Transaction Risk Analysis enables analyzing the risk level based on predefined rules and exempts the user from having to provide the second factor.

1. Open the `<WSO2_OB_KM_HOME>/repository/conf/finance/open-banking.xml` and `<WSO2_OB_APIM_HOME>/repository/conf/finance/open-banking.xml` files to enable Transaction Risk Analysis (TRA):

   a. Set the `<IsEnabled>` property under `<TRA>` to true to enable the TRA feature.

   b. Replace the `<WSO2_OB_BI_HOST>` place holder with the hostname of the Business   Intelligence server.

   c. To enable TRA for:

   - payments, set the `<PaymentValidationEnabled>` property to `true`
   - accounts, set the `<AccountValidationEnabled>` property to `true`

   d. The configurations related to TRA Receivers are under the `<Receivers>` property. You may use the default WSO2 Open Banking Business Intelligence server username and password. Replace the placeholders in `<TRAAccountValidationURL>` and  `<TRAPaymentValidationURL>` properties to set the Account and Payment validation URLs respectively.

    ```
    <BIServer>
        <!-- Include all configurations related to OBBI component -->
        <TRA>
            <!-- Include all configurations related to Transaction Risk Analysis -->
    
            <!-- Enable TRA in WSO2 Open Banking-->
            <IsEnabled>true</IsEnabled>
            <!-- following configurations are used to enable TRA for specific flows only-->
            <!-- Enable TRA for Payments-->
            <PaymentValidationEnabled>true</PaymentValidationEnabled>
            <!-- Enable TRA for Accounts-->
            <AccountValidationEnabled>true</AccountValidationEnabled>
            <!-- Configurations related to TRA Receivers-->
            <Receivers>
                <!-- Administrator username to login to the remote BI server. -->
                <Username>admin@wso2.com@carbon.super</Username>
                <!-- Administrator password to login to the remote BI server. -->
                <Password>wso2123</Password>
                <!-- Receiver URLs of the Siddhi Apps used to validate for TRA.-->
                <TRAAccountValidationURL>http://<WSO2_OB_BI_HOST>:8007/    TRAAccountValidationApp/TRAValidationStream</TRAAccountValidationURL>
                <TRAPaymentValidationURL>http://<WSO2_OB_BI_HOST>:8007/    TRAPaymentValidationApp/TRAValidationStream</TRAPaymentValidationURL>
            </Receivers>
            <TimePeriodOfRecurringPayment>90</TimePeriodOfRecurringPayment>
            <MaxFrequencyOfTransactionsWithoutSCA>5</MaxFrequencyOfTransactionsWithoutSCA>
            <TotalAmountLimitOfTransactionsWithoutSCA>100</    TotalAmountLimitOfTransactionsWithoutSCA>
            <LastSCATimeLimit>90</LastSCATimeLimit>
            <TransactionAmountLimit>30</TransactionAmountLimit>
        </TRA>
    </BIServer>
    ```

2. Make the following changes to the files given below.

   a. Open the `<WSO2_OB_BI_HOME>/deployment/siddhi-files/TRAAccountValidationApp.siddhi` file.

    - Update the `<WSO2_OB_BI_HOST>` placeholder in the receiver URL, with the hostname of your WSO2 OB BI server.

        ```
        receiver.url='http://<WSO2_OB_BI_HOST>:8007/TRAAccountValidationApp/TRAValidationStream'
        ```

   b. Open the `<WSO2_OB_BI_HOME>/deployment/siddhi-files/TRAPaymentValidationApp.siddhi` file.

    - Update the `<WSO2_OB_BI_HOSTNAME>` placeholder in the receiver URL, with the hostname of your WSO2 OB BI server.

        ```
        receiver.url='http://<WSO2_OB_BI_HOST>:8007/TRAPaymentValidationApp/TRAValidationStream'
        ```