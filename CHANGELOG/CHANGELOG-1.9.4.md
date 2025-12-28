## SUSE Storage v1.9.4 Release Notes

SUSE Storage 1.9.4 introduces several improvements and bug fixes that are intended to improve system quality, resilience, stability and security.

The SUSE Storage team appreciates your contributions and expects to receive feedback regarding this release.

> [!NOTE]
> For more information about release-related terminology, see [Releases](https://github.com/rancher/suse-storage/releases).

## Installation

>  [!IMPORTANT]
**Ensure that your cluster is running Kubernetes v1.25 or later before installing SUSE Storage v1.9.4.**

You can install SUSE Storage using a variety of tools, including Rancher, Kubectl, and Helm. For more information about installation methods and requirements, see [Installation](https://documentation.suse.com/cloudnative/storage/1.9/en/installation-setup/installation/installation.html) in the SUSE Storage documentation.

## Upgrade

>  [!IMPORTANT]
**Ensure that your cluster is running Kubernetes v1.25 or later before upgrading from SUSE Storage v1.9.x (< v1.9.4) to v1.9.4. To upgrade from Longhorn v1.8.x to SUSE Storage v1.9.4, please refer to the [Migration](#improvement) section.**

SUSE Storage only allows upgrades from supported versions. For more information about upgrade paths and procedures, see [Upgrade](https://documentation.suse.com/cloudnative/storage/1.9/en/upgrades/longhorn-components/upgrade-longhorn-manager.html) in the SUSE Storage documentation.

## Migration

To migrate Longhorn to SUSE Storage, please refer to the procedures described in the [Migrating to SUSE Storage](https://documentation.suse.com/cloudnative/storage/1.9/en/migration/migration.html) documentation.

## Post-Release Known Issues

For information about issues identified after this release, see [Release-Known-Issues](https://github.com/longhorn/longhorn/wiki/Release-Known-Issues).

## Post-Release Known Issues

For information about issues identified after this release, see [Release-Known-Issues](https://github.com/longhorn/longhorn/wiki/Release-Known-Issues).

## Resolved Issues

### Bug
- [BACKPORT][v1.9.4][BUG] Block Mode Volume Migration Stuck [12327](https://github.com/longhorn/longhorn/issues/12327) - @COLDTURNIP @yangchiu @shuo-wu
- [BACKPORT][v1.9.4][BUG] invalid memory address or nil pointer dereference (again) [12331](https://github.com/longhorn/longhorn/issues/12331) - @chriscchien @bachmanity1

## Contributors

- @COLDTURNIP 
- @bachmanity1 
- @chriscchien 
- @derekbit 
- @shuo-wu 
- @yangchiu 
- @innobead
- @c3y1huang
- @sushant-suse
- @rebeccazzzz
- @forbesguthrie
- @recena
- @marcosbc
