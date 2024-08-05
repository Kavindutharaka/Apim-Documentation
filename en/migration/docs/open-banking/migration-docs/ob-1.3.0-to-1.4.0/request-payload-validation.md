# Request Payload Validation

Request Payload Validation adds flexibility to validate an incoming request against any customisations done to the swagger definition. You need to republish the API to apply the swagger based validations.

> **Note**
> 
> Follow the steps below to use the Request Payload Validation feature, if you haven't applied the WUM update released on June 25, 2019 (06-25-2019). 

1. Go to the API Manager **Management Console** at https://<WSO2_OB_APIM_HOST>:9443/carbon.

2. Navigate to the **Extensions** tab and click **Lifecycles**.

![lifecyle](https://docs.wso2.com/download/attachments/126563863/Lifecycle.png?version=1&modificationDate=1567591700000&api=v2)

3. Click **View/Edit** of **APILifeCycle**.

4. Add the following changes to the XML file, under the respective tags to enable publishing the swagger as a local entry in the `<WSO2_OB_APIM_HOST>/repository/deployment/server/synapse-configs/default/local-entries` directory.

- In the `state id= "Published"` element, add a new execution element under `transitionExecution` data with the properties below:

    ```
    <state id="Published">
        <datamodel>
            <data name="transitionExecution">
                <execution forEvent="Publish"
               class="com.wso2.finance.open.banking.api.executor.OBAPIPublisherExecutor"></ execution>
            </data>
        </datamodel>
    </state>
    ```

- In the state `id="Created"` element, under `data name="transitionExecution"` find the default execution class value for event `Publish`. Replace that default execution class with `com.wso2.finance.open.banking.api.executor.OBAPIPublisherExecutor` as follows:

    ```
    <state id="Created">
        <datamodel>
            <data name="transitionExecution">
                <execution forEvent="Publish"
          class="com.wso2.finance.open.banking.api.executor.OBAPIPublisherExecutor"></  execution>
            </data>
        </datamodel>
    </state>
    ```

5. Republish the APIs.

   You need to republish the API to apply the swagger based validations. Therefore, follow the steps below:

   a. Sign in to the API Publisher at `https://<WSO2_OB_APIM_HOST>:9443/publisher`  using the credentials of a user, whose role is an API Publisher. For more information on users and roles, see [here](https://docs.wso2.com/display/OB130/Configuring+Users+and+User+Stores).

   b. Select the respective API and click **Edit API**.

   ![edit-api](https://docs.wso2.com/download/thumbnails/126561936/EditAPI.png?version=1&modificationDate=1567336182000&api=v2)

   c. You are redirected to the **Design** phase. Click the **Edit Source button** under   the **API Definition** section.

   ![edit-source](https://docs.wso2.com/download/attachments/126561936/EditSource.png?version=1&modificationDate=1567337710000&api=v2)

   d. Click **Apply Changes** to save the changes and go back to the **Design** page.

   ![apply-changes-button](https://docs.wso2.com/download/attachments/126561936/ApplyChangesButton.png?version=1&modificationDate=1567686061000&api=v2)

   e. Scroll down and click **Save**.

   f. Click **Next: Implement > Next: Manage** and **Save and Publish**.