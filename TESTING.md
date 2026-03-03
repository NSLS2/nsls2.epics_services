Testing Roles Against arcapp1-dev
==================================

This document describes how to build, deploy, and verify roles from the
`nsls2.epics_services` collection using the NSLS-II test infrastructure.

## Infrastructure

| Host | Purpose |
| --- | --- |
| `runansible1.nsls2.bnl.gov` | Ansible control node; runs playbooks |
| `arcapp1-dev.nsls2.bnl.gov` | Target test host for EPICS services |

The collection is installed on `runansible1` via `requirements.yml` in
`/nsls2/users/asligar/ansible/collections/`. This path takes precedence
over `~/.ansible/collections/`.

## Step 1 — Build and install the collection

From the local checkout of `nsls2.epics_services`:

```bash
# Build the tarball
ansible-galaxy collection build --force --output-path /tmp/

# Copy to runansible1
scp /tmp/nsls2-epics_services-*.tar.gz runansible1.nsls2.bnl.gov:/tmp/

# Install (must target the correct collections path)
ssh runansible1.nsls2.bnl.gov \
  "ansible-galaxy collection install --force \
   -p /nsls2/users/asligar/ansible/collections/ \
   /tmp/nsls2-epics_services-*.tar.gz"
```

**Important:** The `-p /nsls2/users/asligar/ansible/collections/` flag is
required. Without it, the collection installs to `~/.ansible/collections/`
which is lower priority and the stale copy in `ansible/collections/` will
still be used.

## Step 2 — Edit the deploy playbook

The playbook lives on `runansible1` at:

    /nsls2/users/asligar/ansible/deploy_epics_services.yml

It contains one commented-out section per service. Uncomment only the
service you want to test and comment out the others:

```yaml
# --- Archiver Appliance ---
- name: Deploy Archiver Appliance Service
  hosts: all
  roles:
    - nsls2.epics_services.aa_service
```

**Port conflicts:** Zookeeper's admin port occupies 8080 on the test host.
Override HTTP/HTTPS ports in the playbook `vars:` section (e.g., 7080/7443
for ChannelFinder, 9080/9443 for Olog).

## Step 3 — Run the playbook

```bash
ssh runansible1.nsls2.bnl.gov \
  "cd /nsls2/users/asligar/ansible && \
   ansible-playbook deploy_epics_services.yml \
   -l arcapp1-dev.nsls2.bnl.gov"
```

Add `-v` for verbose output. The playbook connects as `root` (per
`ansible.cfg`) and uses `become_user` where needed.

## Step 4 — Verify on the target host

```bash
ssh root@arcapp1-dev.nsls2.bnl.gov

# Check service status
systemctl status aa_mgmt aa_engine aa_etl aa_retrieval

# Check ports are listening
ss -tlnp | grep -E '16065|16066|16067|16068'

# Test the mgmt API
curl -s http://localhost:16065/mgmt/bpl/getApplianceInfo
```

## Step 5 — Test idempotency

Re-run the playbook. A correct role should produce `changed=0`:

```bash
ssh runansible1.nsls2.bnl.gov \
  "cd /nsls2/users/asligar/ansible && \
   ansible-playbook deploy_epics_services.yml \
   -l arcapp1-dev.nsls2.bnl.gov"
```

Verify the PLAY RECAP shows `changed=0` and no handlers fire.

## Currently deployed services on arcapp1-dev

| Service | systemd unit | HTTP | HTTPS | procServ |
| --- | --- | --- | --- | --- |
| Elasticsearch | `elasticsearch.service` | — | — | — |
| Phoebus Olog | `phoebus_olog.service` | 9080 | 9443 | 60049 |
| Phoebus Olog Webclient | `phoebus_olog_webclient.service` | 3000 | — | — |
| ChannelFinder | `channelfinder.service` | 7080 | 7443 | 60051 |
| AA Mgmt | `aa_mgmt.service` | 16065 | — | — |
| AA Engine | `aa_engine.service` | 16066 | — | — |
| AA ETL | `aa_etl.service` | 16067 | — | — |
| AA Retrieval | `aa_retrieval.service` | 16068 | — | — |

## Genericization and testing progress

Primary service roles are being migrated from NSLS-II-specific defaults
(`beamline_name`, `beamline_id`, computed ports) to generic, portable defaults.
Each role is tracked through three milestones:

- **Genericized** — `beamline_name`/`beamline_id` removed, generic defaults added
- **Deployed** — successfully deployed to `arcapp1-dev`
- **Idempotent** — second run produces `changed=0`

| Role | Genericized | Deployed | Idempotent | Notes |
| --- | --- | --- | --- | --- |
| `phoebus_olog_service` | Yes | Yes | Yes | |
| `phoebus_olog_webclient_service` | Yes | Yes | Yes | |
| `channelfinder_service` | Yes | Yes | Yes | |
| `aa_service` | Yes | Blocked | — | Blocked — requires RHEL 10 (Tomcat 10+ RPM for Jakarta EE / AA 2.2.1) |
| `phoebus_alarm_service` | Yes | — | — | Needs deploy/test |
| `recceiver_service` | Yes | — | — | Needs deploy/test |
| `phoebus_web_runtime_service` | — | — | — | Still uses `beamline_name` |
| `save_restore_service` | — | — | — | Still uses `beamline_name` |
| `shift_service` | — | — | — | Still uses `beamline_name` |

Roles not listed above (dependencies, cs_studio_*, cs_studio_bobs_*) are either
already generic or do not deploy standalone services.

## Troubleshooting

- **Stale collection:** If old task names or `beamline_name` references
  appear in the output, the collection was not updated in the correct path.
  Re-run the install with `-p /nsls2/users/asligar/ansible/collections/`.

- **Maven `.m2` errors:** Ensure `epics_services_account` resolves to a
  user with a writable home directory (default: `csstudio`). Check with:
  ```bash
  ssh runansible1.nsls2.bnl.gov \
    "ansible -m debug -a 'var=epics_services_account' \
     arcapp1-dev.nsls2.bnl.gov"
  ```

- **RPM not found (`mariadb-java-client`, `tomcat`):** Ensure the target
  host has access to RHEL AppStream repos. Check with:
  ```bash
  ssh root@arcapp1-dev.nsls2.bnl.gov "dnf info tomcat mariadb-java-client"
  ```

- **AA blocked on RHEL 8:** Archiver Appliance 2.2.1 requires Tomcat 10+
  (Jakarta EE / `jakarta.servlet`), but RHEL 8's Tomcat RPM is v9
  (`javax.servlet`). RHEL 10 ships Tomcat 10.1+ as an RPM.
  `arcapp1-dev` must be re-provisioned to RHEL 10 before AA
  deployment can resume.
