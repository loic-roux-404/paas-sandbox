Playbook-paas
============

Platform as service infrastructure provisioning

Composed of tree parts

- [Core services](./core)
- [Ansible playbook](./ansible)
- [Packer templates](./packer)
- [Utils: infra-scripts](./infra-scripts)

## Monorepo

We use bazel to release app in separate parts
All process is runned by CI so dependencies will never appear in local.

Install project with : `./tools/go.sh`
