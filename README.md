Playbook-paas
============

Platform as service infrastructure provisioning

Composed of multiple parts

- [Core services](./core)
- [Ansible playbook](./ansible)
- [Packer templates](./packer)
- [Infra scripts](./infra-scripts)

## Monorepo

We use bazel by the intermediary of bazelisk to release app in separate parts

All process is runned by CI so dependencies will never appear in local.

Install project with :
- bash / zsh : `./infra-scripts/tools/go.sh $(pwd)`
- fish : `./infra-scripts/tools/go.sh (pwd)`

Now you can run commands with : `bazelisk`, for a less confuse use you can do

- fish: `echo 'alias bazel="bazelisk"' >> ~/.config/fish/config.fish`
- bash / zsh : `echo 'alias bazel="bazelisk"' >> ~/.bash_profile`
