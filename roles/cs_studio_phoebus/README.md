Phoebus
=======

Build and install Phoebus products along with required libraries.

Role Variables
--------------

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `cs_studio_phoebus_repo` | string | `https://github.com/ControlSystemStudio/phoebus.git` | Core Phoebus repository |
| `cs_studio_phoebus_version` | string | `master` | Branch/tag for core Phoebus |
| `cs_studio_phoebus_dest` | string | `/opt/css/lib/phoebus` | Destination for core Phoebus |
| `cs_studio_phoebus_products_repo` | string | `""` | Organization-specific products repository (required) |
| `cs_studio_phoebus_products_version` | string | `main` | Branch/tag for products repo |
| `cs_studio_phoebus_products_dest` | string | `/opt/css/phoebus-products` | Destination for products repo |
| `cs_studio_phoebus_jar` | string | `""` | Path to the product JAR file (required) |
| `cs_studio_phoebus_pref` | string | `""` | Path to the settings.ini file (required) |
| `cs_studio_phoebus_logging` | string | (derived) | Path to logging.properties |
| `cs_studio_phoebus_logback` | string | (derived) | Path to logback.xml |
| `cs_studio_phoebus_owner` | string | `csstudio` | Owner user for files |

Example Playbook
----------------

```yaml
- hosts: servers
  vars:
    cs_studio_phoebus_products_repo: "https://github.com/your-org/your-phoebus-products.git"
    cs_studio_phoebus_products_version: "main"
    cs_studio_phoebus_jar: "/opt/css/phoebus-products/products/your-product/target/your-product.jar"
    cs_studio_phoebus_pref: "/opt/css/preferences/your-beamline/settings.ini"
  roles:
    - nsls2.epics_services.cs_studio_phoebus
```

Dependencies
------------

- `cs_studio_preferences`
- `cs_studio_bobs`
- `epics_tools_libs`