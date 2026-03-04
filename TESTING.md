Testing Roles Against arcapp1-dev
==================================

This document describes how to build, deploy, and verify roles from the
`nsls2.epics_services` collection using the NSLS-II test infrastructure.

## Infrastructure

| Host | Purpose |
| --- | --- |
| `runansible1.nsls2.bnl.gov` | Ansible control node; runs playbooks |
| `arcapp1-dev.nsls2.bnl.gov` | Target test host for EPICS services |

### Two-repo setup

Testing involves **two separate repositories**:

| Repository | Location (local) | Location (runansible1) | Purpose |
| --- | --- | --- | --- |
| `nsls2.epics_services` | `/home/asligar/git_projects/nsls2.epics_services` | installed as a collection | Generic Ansible collection containing the EPICS service roles. Roles have no NSLS-II-specific defaults. |
| `ansible` (fork: `sligara7/ansible`) | `/home/asligar/git_projects/ansible` | `/nsls2/users/asligar/ansible` | NSLS-II site-specific playbooks and inventory. Contains `deploy_epics_services.yml` with port overrides, credentials, AD config, etc. |

The **deploy playbook** (`deploy_epics_services.yml`) lives in the `ansible`
repo on the `phoebus-alarm` branch. It imports roles from the
`nsls2.epics_services` collection and provides site-specific variable
overrides (port conflicts, AD URLs, DB passwords, etc.).

The **collection** (`nsls2.epics_services`) is built locally, copied to
`runansible1`, and installed to `/nsls2/users/asligar/ansible/collections/`.
This path takes precedence over `~/.ansible/collections/`.

### Keeping the playbook in sync

The deploy playbook is edited on `runansible1` during testing. To sync
changes back to the local checkout:

```bash
# On runansible1 — commit and push
ssh runansible1.nsls2.bnl.gov \
  "cd /nsls2/users/asligar/ansible && \
   git add deploy_epics_services.yml && \
   git commit -m 'Update deploy playbook' && \
   git push"

# Locally — pull the changes
cd /home/asligar/git_projects/ansible
git checkout phoebus-alarm
git pull
```

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
| Shift (GlassFish) | `shift_glassfish.service` | 11080 | 11443 | — |

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
| `phoebus_web_runtime_service` | Yes | Blocked | — | GitHub HTTPS 401 from arcapp1-dev; needs PAT in vault |
| `save_restore_service` | Yes | Blocked | — | Needs pre-built JAR from `cs_studio_phoebus` (GitHub blocked) |
| `shift_service` | Yes | Yes | Yes | Ports 11080/11443/11848 on arcapp1-dev |

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

- **GitHub HTTPS 401 from arcapp1-dev:** Git clone operations to
  `github.com` fail with `could not read Username` because GitHub
  returns HTTP 401 for unauthenticated git-over-HTTPS. This blocks
  `phoebus_web_runtime_service` (clones PVWS/DBWR) and
  `save_restore_service` (needs JAR from `cs_studio_phoebus` build).
  **Fix:** Store a GitHub PAT in Ansible Vault and inject it into
  repo URLs in the deploy playbook:
  ```yaml
  pvws_repo: "https://{{ github_token }}@github.com/ControlSystemStudio/pvws.git"
  ```

- **AA blocked on RHEL 8:** Archiver Appliance 2.2.1 requires Tomcat 10+
  (Jakarta EE / `jakarta.servlet`), but RHEL 8's Tomcat RPM is v9
  (`javax.servlet`). RHEL 10 ships Tomcat 10.1+ as an RPM.
  `arcapp1-dev` must be re-provisioned to RHEL 10 before AA
  deployment can resume.
