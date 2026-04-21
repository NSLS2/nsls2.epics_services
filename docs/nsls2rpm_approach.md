# EPICS Services RPM Packaging Strategy

## Problem

The `nsls2.epics_services` Ansible collection currently builds every EPICS
service **from source on each target host**. This means every beamline host
needs Maven, Gradle, npm, and JDK installed as build tools, clones upstream
git repos, and runs full builds during deployment. As we scale to 30+
beamline hosts, this creates:

- **Long deploy times** -- Maven builds take minutes per service, per host.
- **Build tool sprawl** -- Maven (400 MB), Gradle, npm on production machines.
- **Fragile deployments** -- network issues, Maven Central outages, or upstream
  repo changes can break builds mid-deploy.
- **No rollback path** -- if a new version breaks, there's no quick way to
  revert without rebuilding the old version from source.
- **Version drift** -- builds on different hosts at different times may produce
  subtly different artifacts.

## Proposed Solution

**Build once in CI, package as RPMs, install everywhere.**

Each EPICS service gets packaged as an RPM in the
[nsls2rpms](https://github.com/NSLS2/nsls2rpms) repository. Jenkins builds
the RPMs from source and publishes them to the NSLS-II internal RPM
repository. Target hosts install via `dnf install`.

### What goes into the RPM

| Contents | Example (channelfinder) |
|----------|------------------------|
| Compiled artifact | `/opt/epics-tools/services/channelfinder/ChannelFinder-5.0.0.jar` |
| Run script | `/opt/epics-tools/services/channelfinder/run-cf.sh` |
| systemd unit | `/usr/lib/systemd/system/channelfinder.service` |
| Example config | `/etc/epics-services/cf.properties.example` |
| Service account | `csstudio` (created by RPM scriptlet) |

### What Ansible still does

The RPM provides the **binary artifact and service plumbing**. Ansible
provides the **site-specific configuration**:

- Template config files with host-specific values (ports, hostnames,
  credentials, Elasticsearch endpoints, etc.)
- Manage TLS certificates
- Configure firewall rules (nftables)
- Enable/start services
- Handle per-beamline overrides (alarm config names, CA address lists, etc.)

### Before vs After

**Before (build from source):**
```
clone repo -> install Maven -> install JDK -> mvn clean install ->
  copy JAR -> create systemd unit -> template config -> start service
```

**After (RPM):**
```
dnf install nsls2-channelfinder -> template config -> start service
```

## Service-to-RPM Mapping

| Service | Build Tool | Artifact | RPM Name |
|---------|-----------|----------|----------|
| ChannelFinder | Maven | `ChannelFinder-5.0.0.jar` | `nsls2-channelfinder` |
| Phoebus Olog | Maven | `service-olog-6.0.1.jar` | `nsls2-phoebus-olog` |
| Phoebus Alarm (all 3) | Maven | 3 JARs from Phoebus tree | `nsls2-phoebus-alarm` |
| Save & Restore | Maven | `service-save-and-restore-5.0.2.jar` | `nsls2-save-restore` |
| PVWS + DBWR | Maven | `pvws.war` + `dbwr.war` | `nsls2-phoebus-web-runtime` |
| Phoebus Products (beamlines) | Maven | Product JAR + launcher | `nsls2-phoebus-beamlines` |
| Phoebus Products (accl) | Maven | Product JAR + launcher | `nsls2-phoebus-accl` |
| Archiver Appliance (beamline) | Gradle | Pre-deployed 4 Tomcat instances | `nsls2-archiver-appliance-single` |
| Archiver Appliance (accelerator) | Gradle | Pre-deployed 4 Tomcat instances | `nsls2-archiver-appliance-cluster` |
| Olog Web Client | npm | Built frontend | `nsls2-olog-webclient` |
| RecSync | Make | Python package | `nsls2-recsync` |
| Shift | Pre-built | `Shift-1.1.war` | `nsls2-shift` |

## Dependency RPMs

Some runtime dependencies are not available as standard RHEL RPMs across
all versions (8/9/10). These are also packaged in nsls2rpms to guarantee
consistent versions regardless of RHEL version:

| Dependency | Issue | RPM Name |
|-----------|-------|----------|
| JDK 25 | Not in RHEL 8/9 repos | `nsls2-jdk-25` |
| Tomcat 10 | RHEL 8/9 only have Tomcat 9 (javax, not jakarta) | `nsls2-tomcat` |
| Kafka | No upstream RPM anywhere | `nsls2-kafka` |
| procServ | EPICS-specific, not in any distro repo | `nsls2-procserv` |

Dependencies that are well-served by external vendor repos do NOT need
nsls2rpms packaging:

- **Elasticsearch** — Elastic's own yum repo, version-pinned
- **MongoDB** — MongoDB's own yum repo, version-pinned
- **Node.js** — NodeSource repo
- **MariaDB** — standard RHEL repos

With both service and dependency RPMs in nsls2rpms, the `epics_services_rpm_only`
fallback logic in the collection's dependency roles becomes unnecessary —
every required package is available as an RPM on all RHEL versions.

## RPM Packaging Conventions

### Naming

All packages use the `nsls2-` prefix to distinguish them from any upstream
packages.

### Versioning

Follow the upstream project's version with an NSLS-II snapshot release
identifier:

```
nsls2-channelfinder-5.0.0-1^20260408.1.el10.noarch.rpm
                    ^^^^^  ^ ^^^^^^^^ ^  ^^^
                    |      | |        |  |
                    |      | |        |  RHEL version (noarch for Java)
                    |      | |        NSLS-II release counter
                    |      | Build date
                    |      Base release
                    Upstream version
```

### Directory Layout

Each service follows the existing NSLS-II directory convention:

```
/opt/epics-tools/services/<service_name>/
    <artifact>.jar              # compiled artifact
    run-<service>.sh            # startup script
/usr/lib/systemd/system/
    <service_name>.service      # systemd unit
/etc/epics-services/
    <service>.properties.example  # example config (not active)
```

Active configuration files remain at
`/opt/epics-tools/services/<service_name>/` and are managed by Ansible
(not owned by the RPM). The RPM installs a `.example` file as a reference.

### Dependencies

RPM `Requires` declarations handle runtime dependencies:

```spec
Requires: java-25-openjdk-headless
Requires: procServ
```

Build-time dependencies (Maven, Gradle) are `BuildRequires` only -- they are
needed on the Jenkins build host, not on production machines.

### Service Account

The RPM creates the `csstudio` service account if it doesn't exist:

```spec
%pre
getent group csstudio >/dev/null || groupadd -r csstudio
getent passwd csstudio >/dev/null || \
    useradd -r -g csstudio -d /opt/epics-tools -s /sbin/nologin csstudio
```

## Workflow

### Building and Publishing a New RPM

1. Update the `.spec` file version in `nsls2rpms/<service>/SPECS/`.
2. Build the SRPM locally:
   ```shell
   rpmbuild --define "_topdir $PWD" -bs ./SPECS/nsls2-channelfinder.spec
   ```
3. Upload to Jenkins:
   ```shell
   curl -v 'https://jenkins.nsls2.bnl.gov/job/ingest_srpm_to_build/buildWithParameters' \
     -F "incoming=@./SRPMS/nsls2-channelfinder-5.0.0-1^20260408.1.el10.src.rpm" \
     --user "$USER:$TOKEN"
   ```
4. Jenkins builds the RPM and publishes to the NSLS-II RPM repo.

### Upgrading a Service

1. Update `shared.yml` version (e.g., `cf_version: "ChannelFinder-5.1.0"`).
2. Build and publish new RPM (steps above).
3. Run Ansible:
   ```shell
   ansible-playbook deploy_epics_services.yml -l epics-services-tst.nsls2.bnl.gov
   ```
   Ansible does: `dnf install nsls2-channelfinder-5.1.0` + re-templates configs.

### Rolling Back

```shell
dnf downgrade nsls2-channelfinder-5.0.0
systemctl restart channelfinder
```

## Impact on Ansible Roles

### Collection roles (`nsls2.epics_services`)

Each service role shrinks significantly. The build-from-source path is
replaced by a `package` task:

```yaml
# Before: ~60 lines of git clone + Maven build + artifact copy
# After:
- name: Install ChannelFinder
  ansible.builtin.package:
    name: "nsls2-channelfinder-{{ cf_version | regex_replace('^ChannelFinder-', '') }}"
    state: present

- name: Template ChannelFinder configuration
  ansible.builtin.template:
    src: cf.properties.j2
    dest: /opt/epics-tools/services/channelfinder/cf.properties
  notify: Restart channelfinder
```

The `maven_dep` role is no longer needed on any target host.
All services AND Phoebus desktop products are now available as RPMs.
Maven, Gradle, and npm are only needed on the Jenkins build host.

### `deploy_epics_services` role (ansible repo)

No structural changes needed. The orchestration role already delegates to
collection roles -- those roles just get simpler internally.

## Pilot Services

**ChannelFinder** and **Phoebus Olog** are the first two pilots because:

- Single JAR output (simplest packaging)
- Well-defined upstream release tags
- Already have clean systemd unit templates
- Cover Maven build path (most common across services)

Spec files: `nsls2rpms/channelfinder/` and `nsls2rpms/phoebus-olog/`.

## Additional Specs

**Phoebus Alarm** (`nsls2rpms/phoebus-alarm/`) packages all three alarm
components (alarm-server, alarm-logger, alarm-config-logger) from a single
Phoebus source build. Kafka topic creation and alarm preferences remain
Ansible-managed since they are site-specific.

**Archiver Appliance** is split into two RPMs:

- `nsls2-archiver-appliance-single` (`nsls2rpms/archiver-appliance-single/`)
  — for beamline hosts. Ships 4 pre-deployed Tomcat instances with fixed
  identity (`appliance0`) and standard ports. Ansible configures storage
  paths, MariaDB, and EPICS CA per beamline.

- `nsls2-archiver-appliance-cluster` (`nsls2rpms/archiver-appliance-cluster/`)
  — for accelerator nodes. Same 4 pre-deployed instances, but with a
  placeholder identity. Ansible configures per-node identity, the shared
  `appliances.xml` cluster membership, and per-node storage paths.

The two packages conflict (`Conflicts:` in the spec) so only one can be
installed per host. Both eliminate the Gradle build from target hosts.

## Migration Path

All service RPM specs are now available in `nsls2rpms/`. The migration
proceeds in phases by validation, not by packaging:

1. **Phase 1 (pilot):** Build and test ChannelFinder and Phoebus Olog RPMs
   on `epics-services-tst`. Collection roles gain an `rpm` task path
   alongside the existing `source` path, controlled by a new flag (e.g.,
   `epics_services_use_rpms`). Note: the existing `epics_services_rpm_only`
   flag only controls dependency installation fallbacks, not service builds.
2. **Phase 2:** Validate Phoebus Alarm, Save & Restore, Web Runtime, and
   Olog Web Client RPMs. Add RPM task paths to their collection roles.
3. **Phase 3:** Validate Archiver Appliance (single + cluster) and RecSync
   RPMs. Validate Shift RPM (legacy JDK 8 service).
4. **Phase 4:** Remove source-build task paths from collection roles.
   Remove `maven_dep` / build tool roles from service role dependencies.
