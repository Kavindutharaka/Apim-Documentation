# Migration resources for WSO2 Identity Server

This directory contains the migration documentation and resources for WSO2 Identity Server.

--------------------------------------

## Migration Docs

See the instructions given below to get the migration docs (markdown files) that are required for each migration scenario.

- Go to the `identity-server/migration-docs` folder and select the version number to find the migration docs of each version.
- Depending on from which prior version you are migrating, you need the following docs to identify the changes between versions:
    -   All previous IS versions upto IS 5.7.0 has a **What has changed** document, which details the changes between version.
    -   All IS versions prior 5.7.0 has a **Configuration Changes - WSO2 IS v1 to v2** document, which details the changes between the versions.

## Migration Resources

See the instructions given below to get the migration client, DB scripts, and other resources required.

### Migration client

To get the migration client for WSO2 IS, go to the [migration-resources repository](https://github.com/wso2-enterprise/identity-migration-resources/releases) and download the latest release.

The above migration client applies to the following migration docs:

- Older versions (pre-5.7.0) to 5.8.0
- 5.7.0 to 5.8.0
- 5.9.0
- 5.10.0
- 5.11.0
- 6.0.0
- 6.1.0

### Scripts

To get the DB scripts and other scripts that are referred from the migration docs, go to the `identity-server/migration-resources` folder and select the required version (to which the customer is migrating).