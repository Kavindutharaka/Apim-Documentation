# Configuration Migration Process

When migrating API-M from an older version to a newer one, it is crucial to move the configurations enabled in the older version to the newer version to maintain the behavior of the features of the new product as same in previous version.

Under this step we will move the configurations in the old `deployment.toml` file to the new `deployment.toml` file. However, this is not straight forward and several considerations must be taken into account:

- The configuration names in the older version may have undergone name changes in the newer version.
- Some configurations available in the older version may not be present in the newer version.
- Behavior of several configurations may have changed between versions.

Hence, you may have to rename some configurations, change some configurations while moving them and will be able to drop some configurations.

## Guidelines

- Do not copy entire configuration files from the current version of WSO2 API Manager to the new one, as some configuration files may have changed. Instead, redo the configuration changes in the new configuration files.

- You do not have to add/move a configuration to the `deployment.toml` file unless you want to modify the server’s default value. Default values for all the configurations can be found in the `<API-M-HOME>/repository/resources/conf/default.json` file.

- Follow the the steps under configuration migration to smoothly migrate the old configurations to the new server.

- **If you currently operate a distributed deployment and are planning to transition to a new distributed deployment**, you must transfer configurations between each existing profile and its corresponding new profile. Essentially, you need to repeat the steps outlined under configuration migration for each profile.

- **In case of a K8s deployment**, you might not have separate TOML files, and instead, you may have configured the configurations in the HELM `values.yaml`. In such cases, proceed with the configuration migration steps, but make adjustments where necessary and do the changes directly within the YAML files as required.

- You may familiarize yourself with the [New Configuration Model](https://apim.docs.wso2.com/en/latest/reference/understanding-the-new-configuration-model/#!) to gain a clear understanding of how the APIM config model operates(This is a must if you are migrating from a version prior to 3.x.).





