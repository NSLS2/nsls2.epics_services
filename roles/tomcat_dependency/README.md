tomcat_dependency
=================

Install a general tomcat services
Based on role
<https://github.com/jmutai/tomcat-ansible>

Requirements
------------
OpenJDK 11
role: jdk_dependency

Role Variables
--------------

| Variable                        | Type   | Description                                                                                      |
|---------------------------------|--------|--------------------------------------------------------------------------------------------------|
| `tomcat_dest`                   | string | The installation location of the tomcat server                                                   |
| `tomcat_ssl_enabled`            | bool   | Enable the NIO SSL/TLS connector (default: `false`)                                              |
| `tomcat_ssl_port`               | int    | HTTPS listen port (default: `4443`)                                                              |
| `tomcat_ssl_keystore_file`      | string | Path to the Java keystore file (required when SSL is enabled)                                    |
| `tomcat_ssl_keystore_password`  | string | Keystore password (default: `changeit`)                                                          |
| `tomcat_apr_enabled`            | bool   | Enable the APR lifecycle listener (default: `false`)                                             |
| `tomcat_health_check_enabled`   | bool   | Enable the HealthCheckValve at `/health` (default: `false`, requires Tomcat >= 9.0.55)           |
