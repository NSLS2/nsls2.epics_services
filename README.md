# NSLS2 EPICS Services Collection

An Ansible collection for deploying EPICS middle-layer services and CS-Studio/Phoebus applications.

## Installation

```bash
ansible-galaxy collection install nsls2.epics_services
```

Or add to your `requirements.yml`:

```yaml
collections:
  - name: nsls2.epics_services
    version: ">=1.0.0"
```

## Requirements

- Ansible >= 2.15
- Python >= 3.9

### Collection Dependencies

See `collections/requirements.yml` for required collections:
- community.general
- ansible.posix
- containers.podman
- community.mysql
- community.mongodb

## Included Roles

### CS-Studio / Phoebus Display

| Role | Description |
|------|-------------|
| `cs_studio_bobs` | Deploy Phoebus .bob display files |
| `cs_studio_bobs_web` | Deploy Phoebus web .bob display files |
| `cs_studio_bobs_web_cache` | Flush Phoebus web runtime cache |
| `cs_studio_phoebus` | Build and install Phoebus products |
| `cs_studio_preferences` | Deploy CS-Studio/Phoebus preferences |

### EPICS Services

| Role | Description |
|------|-------------|
| `epics_tools_libs` | Install JDK and Maven dependencies |
| `epics_tools_services_aa_cluster` | Archiver Appliance cluster deployment |
| `epics_tools_services_cf` | ChannelFinder service |
| `epics_tools_services_elastic` | Elasticsearch service |
| `epics_tools_services_kafka` | Kafka and Zookeeper services |
| `epics_tools_services_mongo` | MongoDB service |
| `epics_tools_services_phoebus_alarm` | Phoebus Alarm Server |
| `epics_tools_services_phoebus_olog` | Phoebus Olog (operational logging) |
| `epics_tools_services_phoebus_olog_webclient` | Olog web client |
| `epics_tools_services_phoebus_web_runtime` | Phoebus Display Builder Web Runtime |
| `epics_tools_services_recceiver` | RecSync/RecCeiver for ChannelFinder |
| `epics_tools_services_save_restore` | PV Save and Restore service |
| `epics_tools_services_shift` | Shift management service |
| `epics_tools_services_tomcat` | Tomcat application server |

## Usage

This collection provides **generic, parameterized roles** that require organization-specific configuration. Roles have sensible defaults but many require you to provide values for:

- Repository URLs
- Authentication servers (AD/LDAP)
- Network addresses
- SSL certificates
- Service hostnames

### Example Playbook

```yaml
---
- hosts: epics_services
  vars_files:
    - /path/to/your/organization/vars.yml

  tasks:
    - name: Install JDK and Maven
      ansible.builtin.include_role:
        name: nsls2.epics_services.epics_tools_libs

    - name: Deploy Phoebus BOB files
      ansible.builtin.include_role:
        name: nsls2.epics_services.cs_studio_bobs

    - name: Deploy ChannelFinder
      ansible.builtin.include_role:
        name: nsls2.epics_services.epics_tools_services_cf
```

### Organization-Specific Variables

Create a variables file with your organization's configuration:

```yaml
# Example organization variables
cs_studio_bobs_config:
  base_repo: "https://github.com/your-org"
  repos:
    - "your-bobs-repo"

cs_studio_preferences_config:
  repo: "https://github.com/your-org/your-preferences.git"

phoebus_logback: "/opt/css/your-phoebus/config/logback.xml"

ad_url: "ldap://your-ad-server.example.com"
ad_domain: "example.com"
```

See individual role READMEs for complete variable documentation.

## Related Repositories

For NSLS-II specific deployments, see:
- [epics_services_host_vars](https://github.com/NSLS2/epics_services_host_vars) - NSLS2-specific configuration

## License

BSD-3-Clause

## Contributing

Issues and pull requests welcome at https://github.com/NSLS2/nsls2.epics_services
