# Copilot Instructions for Ontology Repository

## Repository Overview

This monorepo contains automation tooling for homelab infrastructure:
- `automations/nxs-homelab-ansible/` - Ansible playbooks and roles for Proxmox VE management
- `automations/nix-black-magic/` - Nix-based development environments
- `automations/upgraded-barnacle/` - Legacy/reference Ansible setup

## Development Workflow

### Single-Role Development Cycle

**CRITICAL**: Work on ONE role at a time through the complete cycle before moving to the next:

1. **Understand** - Read the role, understand its purpose, check related playbooks
2. **Refactor** - Make necessary changes to the role
3. **Test** - Run the playbook against a real host to verify
4. **Lint** - Run `just lint` to catch issues
5. **Commit** - Commit with conventional commit message
6. **Repeat** - Only move to next role after completing the cycle

### Git Workflow

```bash
# After making changes to a role:
cd automations/nxs-homelab-ansible

# 1. Lint first
just lint

# 2. Stage and commit
git add books/roles/<role-name>/
git commit -m "feat(<role-name>): description of changes"

# 3. Push when ready (can batch multiple commits)
git push

# 4. Check CI status
just ci-status      # Recent runs
just ci-current     # Status of current HEAD
```

### Running Playbooks

```bash
# Set site (default: nexus)
export SITE=nexus

# Run a playbook against all hosts in its target group
just run-book <playbook-name>

# Run against a specific host (preferred for testing)
just run-book-targeted <playbook-name> <hostname>

# Examples:
just run-book-targeted pve-nag-removal nxs-pve-01
just run-book-targeted proxmox-nag-removal nxs-pve-01
just run-book-targeted pve-storage nxs-pve-01
```

### Testing Changes

1. **Always test on a real host** before committing
2. **Run twice** to verify idempotency (second run should show `changed=0`)
3. **Check the actual result** on the host if the playbook claims success

```bash
# Ad-hoc commands to verify state on hosts
ansible <hostname> -i sites/$SITE/inventory --vault-password-file .vault-password \
  -e @sites/$SITE/vault.yml -m shell -a "<command>"
```

## Ansible Conventions

### Project Structure

```
books/                    # Playbooks
  pve-*.yml              # Proxmox-related playbooks
  roles/                 # Roles
    <role-name>/
      defaults/main.yml  # Default variables
      tasks/main.yml     # Main tasks
      meta/main.yml      # Role metadata
      molecule/          # Molecule tests (if present)
    _shared/             # Shared tasks included by multiple roles
      tasks/
        detect_proxmox_version.yml

sites/                   # Site-specific configuration
  <site-name>/
    inventory            # Ansible inventory
    vault.yml            # Encrypted secrets
    group_vars/          # Group variables
```

### Variable Precedence

- Use `inventory_hostname` for targeting the current host
- Avoid hardcoding hostnames in defaults (e.g., DON'T do `default('nxs-pve-01')`)
- Map vault variables in `group_vars/` to role-expected variable names
- Playbooks load vault via `vars_files: ["../sites/{{ lookup('env', 'SITE') }}/vault.yml"]`

### Role Design Principles

1. **Idempotent** - Running twice should produce no changes on second run
2. **Version-aware** - Detect Proxmox version and adapt behavior
3. **Delegate correctly** - API calls run on target host (use `inventory_hostname`), not localhost
4. **Lint compliant** - Must pass `ansible-lint` with production profile

### Common Patterns

```yaml
# Include shared version detection
- name: Include shared Proxmox version detection
  ansible.builtin.include_tasks: "{{ role_path }}/../_shared/tasks/detect_proxmox_version.yml"

# Idempotency check before making changes
- name: Check if already configured
  ansible.builtin.shell: |
    grep -q 'MARKER' /path/to/file && echo 'configured' || echo 'unconfigured'
  register: config_status
  changed_when: false

# Only apply if not already done
- name: Apply configuration
  ansible.builtin.shell: |
    # ... commands ...
  when: config_status.stdout == 'unconfigured'
  changed_when: true
```

### Lint Suppressions

When sed or shell is truly required (e.g., complex text manipulation):
```yaml
- name: Task description  # noqa: command-instead-of-module
  ansible.builtin.shell: |
    sed -i '...' /path/to/file
  changed_when: true
```

## Research Approaches

### For Proxmox-related tasks

1. Check [community-scripts/ProxmoxVE](https://github.com/community-scripts/ProxmoxVE) for proven approaches
2. Look at `tools/pve/post-pve-install.sh` for common patterns
3. Test patterns against actual Proxmox files before implementing

### Finding actual file contents on hosts

```bash
# Check what patterns exist in a file
ansible <host> ... -m shell -a "grep -n 'pattern' /path/to/file | head -20"

# View specific lines
ansible <host> ... -m shell -a "sed -n '610,625p' /path/to/file"
```

## Common Mistakes to Avoid

1. **Don't overcomplicate** - If a simple solution works, use it
2. **Don't delegate API calls to localhost** when running on Proxmox hosts
3. **Don't assume vault variables are directly available** - check group_vars mappings
4. **Don't use `ansible_connection: local`** when SSH to target is needed
5. **Don't skip linting** - CI will fail if lint doesn't pass locally
6. **Don't batch unrelated changes** - one role per commit for clean history

## CI Pipeline

The CI runs on push to main:
- yamllint
- ansible-lint (production profile)

Check status:
```bash
just ci-status     # List recent runs
just ci-current    # Check current commit's status
just ci-run <id>   # Get details of specific run
```

## Justfile Quick Reference

```bash
just                    # List all recipes
just lint               # Run yamllint + ansible-lint
just preflight          # Check environment is ready
just run-book <name>    # Run playbook for all hosts
just run-book-targeted <name> <host>  # Run for specific host
just ci-status          # Check CI status
just ci-current         # CI status for current commit
just edit-vault         # Edit encrypted vault
just decrypt / encrypt  # Decrypt/encrypt vault
```
