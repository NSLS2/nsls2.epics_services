# Example orchestration role

This collection provides generic, reusable roles. A site-specific
**orchestration role** in your playbook repository wires them together,
sets enable flags, and provides site defaults (ports, paths,
authentication).

Below is a complete example showing the expected structure.

## Directory layout

```
your-ansible-repo/
├── deploy_epics_services.yml          # Playbook
├── host_vars/
│   └── epics-host.example.com.yml     # Per-host overrides
└── roles/
    └── deploy_epics_services/
        ├── defaults/main.yml          # Enable flags + site defaults
        └── tasks/
            ├── main.yml               # Dispatches to per-service files
            ├── phoebus_alarm.yml
            ├── phoebus_olog.yml
            ├── channelfinder.yml
            ├── recceiver.yml
            ├── aa.yml
            ├── phoebus_web_runtime.yml
            └── shift.yml
```

## Playbook

```yaml
# deploy_epics_services.yml
---
- name: Deploy EPICS Services
  hosts: all
  roles:
    - deploy_epics_services
```

## defaults/main.yml

Enable flags default to `false`. Override per host via `host_vars/`.

```yaml
---
# Enable flags — set to true to deploy each service
deploy_phoebus_alarm: false
deploy_phoebus_olog: false
deploy_channelfinder: false
deploy_recceiver: false
deploy_aa: false
deploy_phoebus_web_runtime: false
deploy_shift: false

# Shared
epics_services_account: csstudio

# Centralized dependency versions / paths
jdk_version: "21"
java_home: "/usr/lib/jvm/java-{{ jdk_version }}-openjdk"
maven_version: "3.9.9"
mvn_home: "/opt/epics-tools/lib/apache-maven-{{ maven_version }}"

# Dependency service connections
es_host: "localhost"
es_port: 9200
kafka_server: "localhost"
kafka_port: 9092
zookeeper_port: 2181
mongod_host: "localhost"
mongod_port: 27017

# Application ports — HTTP / HTTPS
olog_http_port: 9080
olog_https_port: 9443
cf_http_port: 7080
cf_https_port: 7443
tomcat_http_port: 10080

# Shift Service
http_port: 11080
https_port: 11443
admin_port: 11848
shift_jdbc_server: "localhost"
shift_jdbc_dbname: "shift"
shift_jdbc_user: "shift"
shift_jdbc_password: "shift"
configure_mysql: true

# Archiver Appliance
mgmt_port: 16065
engine_port: 16066
etl_port: 16067
data_retrieval_port: 16068
cluster_inetport: 16070

# procServ ports
phoebus_alarm_server_procServ_port: "60046"
phoebus_alarm_logger_procServ_port: "60047"
phoebus_alarm_config_logger_procServ_port: "60048"
olog_procServ_port: 60049
olog_webclient_procServ_port: 60050
cf_procServ_port: 60051

# RecCeiver / ChannelFinder
recsync_addr_list: "127.255.255.255:5049"
cf_url: "http://localhost:{{ cf_http_port }}/ChannelFinder"
cf_user: admin
cf_password: adminPass

# Phoebus Alarm
alarm_config: "Accelerator"

# Phoebus Olog — authentication (override for your site)
ad_enabled: false
ldap_enabled: false
```

## tasks/main.yml

```yaml
---
- name: Deploy Phoebus Alarm
  ansible.builtin.include_tasks: phoebus_alarm.yml
  when: deploy_phoebus_alarm | bool

- name: Deploy Phoebus Olog
  ansible.builtin.include_tasks: phoebus_olog.yml
  when: deploy_phoebus_olog | bool

- name: Deploy ChannelFinder
  ansible.builtin.include_tasks: channelfinder.yml
  when: deploy_channelfinder | bool

- name: Deploy RecCeiver
  ansible.builtin.include_tasks: recceiver.yml
  when: deploy_recceiver | bool

- name: Deploy Archiver Appliance
  ansible.builtin.include_tasks: aa.yml
  when: deploy_aa | bool

- name: Deploy Phoebus Web Runtime
  ansible.builtin.include_tasks: phoebus_web_runtime.yml
  when: deploy_phoebus_web_runtime | bool

- name: Deploy Shift Service
  ansible.builtin.include_tasks: shift.yml
  when: deploy_shift | bool
```

## Per-service task files

Each file lists the dependency roles first, then the service role.
Dependency roles are idempotent — if multiple services share a
dependency, it runs once and skips on subsequent calls.

### tasks/phoebus_alarm.yml

```yaml
---
# Dependencies: JDK, Maven, Elasticsearch, Kafka, CS-Studio Phoebus

- name: Install JDK dependency
  ansible.builtin.include_role:
    name: nsls2.epics_services.jdk_dependency

- name: Install Maven dependency
  ansible.builtin.include_role:
    name: nsls2.epics_services.maven_dependency

- name: Install Elasticsearch dependency
  ansible.builtin.include_role:
    name: nsls2.epics_services.elasticsearch_dependency

- name: Install Kafka dependency
  ansible.builtin.include_role:
    name: nsls2.epics_services.kafka_dependency

- name: Build CS-Studio Phoebus products
  ansible.builtin.include_role:
    name: nsls2.epics_services.cs_studio_phoebus

- name: Deploy Phoebus Alarm service
  ansible.builtin.include_role:
    name: nsls2.epics_services.phoebus_alarm_service
```

### tasks/phoebus_olog.yml

```yaml
---
# Dependencies: JDK, Maven, Elasticsearch, MongoDB

- name: Install JDK dependency
  ansible.builtin.include_role:
    name: nsls2.epics_services.jdk_dependency

- name: Install Maven dependency
  ansible.builtin.include_role:
    name: nsls2.epics_services.maven_dependency

- name: Install Elasticsearch dependency
  ansible.builtin.include_role:
    name: nsls2.epics_services.elasticsearch_dependency

- name: Install MongoDB dependency
  ansible.builtin.include_role:
    name: nsls2.epics_services.mongodb_dependency

- name: Deploy Phoebus Olog service
  ansible.builtin.include_role:
    name: nsls2.epics_services.phoebus_olog_service

- name: Deploy Phoebus Olog web client
  ansible.builtin.include_role:
    name: nsls2.epics_services.phoebus_olog_webclient_service
```

### tasks/channelfinder.yml

```yaml
---
# Dependencies: JDK, Maven, Elasticsearch

- name: Install JDK dependency
  ansible.builtin.include_role:
    name: nsls2.epics_services.jdk_dependency

- name: Install Maven dependency
  ansible.builtin.include_role:
    name: nsls2.epics_services.maven_dependency

- name: Install Elasticsearch dependency
  ansible.builtin.include_role:
    name: nsls2.epics_services.elasticsearch_dependency

- name: Deploy ChannelFinder service
  ansible.builtin.include_role:
    name: nsls2.epics_services.channelfinder_service
```

### tasks/recceiver.yml

RecCeiver depends on ChannelFinder at runtime. If both are deployed on
the same host, include ChannelFinder's dependencies and service first.

```yaml
---
# Dependencies: JDK, Maven, Elasticsearch, ChannelFinder

- name: Install JDK dependency
  ansible.builtin.include_role:
    name: nsls2.epics_services.jdk_dependency

- name: Install Maven dependency
  ansible.builtin.include_role:
    name: nsls2.epics_services.maven_dependency

- name: Install Elasticsearch dependency
  ansible.builtin.include_role:
    name: nsls2.epics_services.elasticsearch_dependency

- name: Deploy ChannelFinder service
  ansible.builtin.include_role:
    name: nsls2.epics_services.channelfinder_service

- name: Deploy RecCeiver service
  ansible.builtin.include_role:
    name: nsls2.epics_services.recceiver_service
```

### tasks/aa.yml

```yaml
---
# Dependencies: JDK, Tomcat, MariaDB JDBC connector

- name: Install JDK dependency
  ansible.builtin.include_role:
    name: nsls2.epics_services.jdk_dependency

- name: Install Tomcat dependency
  ansible.builtin.include_role:
    name: nsls2.epics_services.tomcat_dependency

- name: Install MariaDB JDBC dependency
  ansible.builtin.include_role:
    name: nsls2.epics_services.mariadb_dependency

- name: Deploy Archiver Appliance service
  ansible.builtin.include_role:
    name: nsls2.epics_services.aa_service
```

### tasks/phoebus_web_runtime.yml

```yaml
---
# Dependencies: JDK, Maven, Tomcat

- name: Install JDK dependency
  ansible.builtin.include_role:
    name: nsls2.epics_services.jdk_dependency

- name: Install Maven dependency
  ansible.builtin.include_role:
    name: nsls2.epics_services.maven_dependency

- name: Install Tomcat dependency
  ansible.builtin.include_role:
    name: nsls2.epics_services.tomcat_dependency

- name: Deploy Phoebus Web Runtime service
  ansible.builtin.include_role:
    name: nsls2.epics_services.phoebus_web_runtime_service
```

### tasks/shift.yml

Shift uses JDK 8 (not the shared `jdk_dependency`) because GlassFish 5
requires the `javax.*` API.

```yaml
---
# Dependencies: JDK 8, MariaDB JDBC connector

- name: Install OpenJDK 8
  become: true
  ansible.builtin.package:
    name: java-1.8.0-openjdk-devel
    state: present

- name: Install MariaDB JDBC dependency
  ansible.builtin.include_role:
    name: nsls2.epics_services.mariadb_dependency

- name: Deploy Shift service
  ansible.builtin.include_role:
    name: nsls2.epics_services.shift_service
```

## host_vars example

Enable services per host and override any defaults:

```yaml
# host_vars/epics-host.example.com.yml
---
deploy_phoebus_alarm: true
deploy_channelfinder: true
deploy_recceiver: true
alarm_config: "MyFacility"
```

## Usage

```bash
ansible-playbook deploy_epics_services.yml -l epics-host.example.com
```
