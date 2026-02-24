aa_build
========

Clones and builds the
[EPICS Archiver Appliance](https://github.com/archiver-appliance/epicsarchiverap)
from source using Gradle.

What it does
------------
- Creates the build directory
- Clones (or updates) the `epicsarchiverap` Git repository at the specified
  version tag
- Cleans any previous build artifacts
- Runs `./gradlew -x sphinx` to produce the distributable `archappl*.tar.gz`

Dependencies
------------
- `aa_dependencies` (provides JDK and Tomcat, required for the Gradle build)

Depended on by
--------------
- `aa_deploy` (consumes the built tar.gz)
- `epics_tools_services_aa` (single-instance orchestrator)
- `epics_tools_services_aa_cluster` (cluster orchestrator)

Role Variables
--------------

This role has no defaults of its own. All variables are expected to be provided
by the calling orchestrator role.

| Variable | Type | Description |
| --- | --- | --- |
| `aa_build_loc` | string | Directory for cloning and building (e.g. `/tmp/aa_tst_build`). |
| `aa_version` | string | Git tag or branch to check out (e.g. `2.2.1`). |
| `aa_java_home` | string | `JAVA_HOME` passed to the Gradle build. |
| `aa_tomcat_home` | string | `TOMCAT_HOME` passed to the Gradle build. |
| `epics_services_account` | string | OS user/group that owns build files. |
