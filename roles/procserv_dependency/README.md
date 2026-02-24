# procserv_dependency

Installs procServ from RPM packages.

## Usage

```yaml
- name: Install procServ
  ansible.builtin.include_role:
    name: nsls2.epics_services.procserv_dependency
```

## Depended on by

- `nsls2.epics_services.channelfinder_service`
- `nsls2.epics_services.phoebus_alarm_service`
- `nsls2.epics_services.phoebus_olog_service`
- `nsls2.epics_services.phoebus_olog_webclient_service`
- `nsls2.epics_services.save_restore_service`
