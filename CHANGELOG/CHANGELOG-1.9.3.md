## SUSE Storage v1.9.3 Release Notes

SUSE Storage 1.9.3 introduces several improvements and bug fixes that are intended to improve system quality, resilience, stability and security.

The SUSE Storage team appreciates your contributions and expects to receive feedback regarding this release.

> [!NOTE]
> For more information about release-related terminology, see [Releases](https://github.com/rancher/suse-storage/releases).

## Installation

>  [!IMPORTANT]
**Ensure that your cluster is running Kubernetes v1.25 or later before installing SUSE Storage v1.9.3.**

You can install SUSE Storage using a variety of tools, including Rancher, Kubectl, and Helm. For more information about installation methods and requirements, see [Installation](https://documentation.suse.com/cloudnative/storage/1.9/en/installation-setup/installation/installation.html) in the SUSE Storage documentation.

## Upgrade

>  [!IMPORTANT]
**Ensure that your cluster is running Kubernetes v1.25 or later before upgrading from SUSE Storage v1.9.x (< v1.9.3) to v1.9.3. To upgrade from Longhorn v1.8.x to SUSE Storage v1.9.3, please refer to the [Migration](#improvement) section.**

SUSE Storage only allows upgrades from supported versions. For more information about upgrade paths and procedures, see [Upgrade](https://documentation.suse.com/cloudnative/storage/1.9/en/upgrades/longhorn-components/upgrade-longhorn-manager.html) in the SUSE Storage documentation.

## Migration

To migrate Longhorn to SUSE Storage, please refer to the procedures described in the [Migrating to SUSE Storage](https://documentation.suse.com/cloudnative/storage/1.9/en/migration/migration.html) documentation.

## Post-Release Known Issues

For information about issues identified after this release, see [Release-Known-Issues](https://github.com/longhorn/longhorn/wiki/Release-Known-Issues).

## Post-Release Known Issues

For information about issues identified after this release, see [Release-Known-Issues](https://github.com/longhorn/longhorn/wiki/Release-Known-Issues).

## Resolved Issues

### Improvement

- [BACKPORT][v1.9.3][FEATURE] [Dependency] aws-sdk-go v1.55.7 is EOL as of 2025-07-31 — plan to migrate to v2? [12182](https://github.com/longhorn/longhorn/issues/12182) - @mantissahz @roger-ryao
- [BACKPORT][v1.9.3][IMPROVEMENT] improve error logging for failed mounting during node publish volume [12034](https://github.com/longhorn/longhorn/issues/12034) - @COLDTURNIP @yangchiu
- [BACKPORT][v1.9.3][IMPROVEMENT] The `auto-delete-pod-when-volume-detached-unexpectedly` should only focus on the kuberentes builtin workload. [12122](https://github.com/longhorn/longhorn/issues/12122) - @derekbit
- [BACKPORT][v1.9.3][IMPROVEMENT] Avoid repeat engine restart when there are replica unavailable during migration [11947](https://github.com/longhorn/longhorn/issues/11947) - @yangchiu @shuo-wu
- [BACKPORT][v1.9.3][IMPROVEMENT] Collect Logs from the Host Directory Defined by the Setting `log-path` [11748](https://github.com/longhorn/longhorn/issues/11748) - @c3y1huang @roger-ryao

### Bug
- [BACKPORT][v1.9.3][BUG] Backup target metric is broken [12090](https://github.com/longhorn/longhorn/issues/12090) - @mantissahz @roger-ryao
- [BACKPORT][v1.9.3][BUG] Replicas accumulate during engine upgrade [12116](https://github.com/longhorn/longhorn/issues/12116) - @c3y1huang @chriscchien
- [BACKPORT][v1.9.3][BUG] RWX volume causes process uninterruptable sleep [11956](https://github.com/longhorn/longhorn/issues/11956) - @COLDTURNIP @chriscchien
- [BACKPORT][v1.9.3][BUG] Backing image download gets stuck after network disconnection [11720](https://github.com/longhorn/longhorn/issues/11720) - @COLDTURNIP @chriscchien
- [BACKPORT][v1.9.3][BUG] Test case `test_recurring_jobs_when_volume_detached_unexpectedly` failed: backup completed but progress did not reach 100% [11556](https://github.com/longhorn/longhorn/issues/11556) - @yangchiu @mantissahz
- [BACKPORT][v1.9.3][BUG] Fix SPDK v25.05 CVE issue [11974](https://github.com/longhorn/longhorn/issues/11974) - @derekbit @roger-ryao
- [BACKPORT][v1.9.3][BUG] panic: runtime error: invalid memory address or nil pointer dereference [signal SIGSEGV: segmentation violation code=0x1 at longhorn-engine/pkg/controller/control.go:218 +0x2de [12087](https://github.com/longhorn/longhorn/issues/12087) - @roger-ryao
- [BACKPORT][v1.9.3][BUG] Unable to complete uninstallation due to the remaining backuptarget [12063](https://github.com/longhorn/longhorn/issues/12063) - @mantissahz @roger-ryao
- [BACKPORT][v1.9.3][BUG] NPE error during recurring job execution [11927](https://github.com/longhorn/longhorn/issues/11927) - @yangchiu @shuo-wu
- [BACKPORT][v1.9.3][BUG] DR volume gets stuck in `unknown` state if engine image is deleted from the attached node [11999](https://github.com/longhorn/longhorn/issues/11999) - @yangchiu @shuo-wu
- [BACKPORT][v1.9.3][BUG] Volume gets stuck in `attaching` state if engine image image is not deployed on one of nodes [11997](https://github.com/longhorn/longhorn/issues/11997) - @yangchiu @shuo-wu
- [BACKPORT][v1.9.3][BUG] longhorn-engine's UI panics [11900](https://github.com/longhorn/longhorn/issues/11900) - @derekbit @chriscchien
- [BACKPORT][v1.9.3][BUG] Volume is unable to upgrade if the number of active replicas is larger than `volumme.spec.numberOfReplicas` [11896](https://github.com/longhorn/longhorn/issues/11896) - @yangchiu @derekbit
- [BACKPORT][v1.9.3][BUG] Longhorn fails to create Backing Image Backup on ARM platform [11573](https://github.com/longhorn/longhorn/issues/11573) - @COLDTURNIP

## Contributors

- @COLDTURNIP 
- @c3y1huang 
- @chriscchien 
- @derekbit 
- @mantissahz 
- @roger-ryao 
- @shuo-wu 
- @yangchiu 
- @innobead
- @sushant-suse
- @rebeccazzzz
- @forbesguthrie
- @recena
- @marcosbc
