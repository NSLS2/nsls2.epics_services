# jdk21_dep

Installs JDK 21 alongside the main JDK (managed by `jdk_dep`).

Required by services whose build toolchain pins to `languageVersion=21`
(e.g. Archiver Appliance 2.x Gradle build). The Java 21 install lives in
`/usr/lib/jvm/` so Gradle's toolchain auto-detection can find it without
any extra configuration. The default runtime JDK from `jdk_dep` is not
changed.

**Installation strategy:**

1. Probes whether `java-21-openjdk` is available via `dnf list available`
2. If available, installs the system OpenJDK RPM
3. Otherwise installs Adoptium Temurin 21 via the Adoptium yum repo

Any install failure surfaces immediately at the offending task (no
`ignore_errors`).

## Exported fact

| Fact | Value | When |
|------|-------|------|
| `java_home_21` | `/usr/lib/jvm/java-21-openjdk` | OpenJDK RPM path |
| `java_home_21` | `{{ jdk21_temurin_java_home }}` (default `/usr/lib/jvm/temurin-21-jdk`) | Temurin fallback path |

## Usage

```yaml
- name: Install JDK 21 (parallel to runtime JDK)
  ansible.builtin.include_role:
    name: nsls2.epics_services.jdk21_dep
```

## Depended on by

- `nsls2.epics_services.aa_api` — AA's Gradle build requires Java 21
  for the toolchain, even when the runtime is JDK 25.
