# Changelog

## 1.0.1

- Genericize all service and dependency roles (remove NSLS-II-specific defaults)
- Consolidate AA sub-roles into single `aa_service` role
- Add `tomcat_dependency` and `mariadb_dependency` roles
- Add `collections/requirements.yml` for dependency management
- Use handlers instead of inline restarts
- Idempotent builds gated by git clone changes

## 1.0.0

- Initial release with service, dependency, and build roles
