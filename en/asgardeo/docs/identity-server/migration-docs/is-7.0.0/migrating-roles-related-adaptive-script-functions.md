# Migrating roles related adaptive script functions

With the introduction of V2 roles with audience support, new adaptive script functions are introduced to handle the role-related operations which were previously handled with scripts compatible with the V1 implementation. Although using the previous adaptive script functions will not impact migrating applications, this may result in unexpected behavior with the usage of application audience roles and changes to the roles assigned to the applications. Therefore, it is recommended to migrate the role-related adaptive script functions after the migration. The following adaptive script functions are introduced to handle the role related operations in the new authorization model.

- `assignUserRolesV2`: This function is used to assign a V2 role to a user during a dynamic authentication. Previous usages of `assignUserRoles` function should be migrated to the new `assignUserRolesV2` function.
- `hasAnyOfTheRolesV2`: This function is used to check whether the user has any of the given V2 roles. Previous usages of `hasAnyOfTheRoles` function should be migrated to the new `hasAnyOfTheRolesV2` function.
- `removeUserRolesV2`: This function is used to remove a V2 role from a user during a dynamic authentication. Previous usages of `removeUserRoles` function should be migrated to the new `removeUserRolesV2` function.
