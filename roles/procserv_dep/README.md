# procserv_dep

Installs procServ from RPM packages.

## Usage

```yaml
- name: Install procServ
  ansible.builtin.include_role:
    name: nsls2.epics_services.procserv_dep
```

## Depended on by

- `nsls2.epics_services.channelfinder_api`
- `nsls2.epics_services.phoebus_alarm_svc`
- `nsls2.epics_services.phoebus_olog_api`
- `nsls2.epics_services.phoebus_olog_ui`
- `nsls2.epics_services.save_restore_api`
