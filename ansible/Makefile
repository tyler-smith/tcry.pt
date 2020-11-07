##
## Common config
##

ANSIBLE_VAULT_PASSWORD_FILE ?= ./vault-password
ANSIBLE_VAULT_SECRETS_DIR ?= ./vault

##
## Dev utilities
##
.PHONY: install ssh-add encrypt

install: ## Install collections and roles from Ansible Galaxy
	ansible-galaxy collection install -r requirements.yml
	ansible-galaxy role install -r requirements.yml

ssh-add: ## Add ansible key to SSH agent
	@ssh-add ../secrets/*.sec

encrypt: ## Encrypt all ansible-vault secrets
	@ls playbooks/vault/*.yml | xargs -L 1 -I{} ansible-vault encrypt --vault-password-file=${ANSIBLE_VAULT_PASSWORD_FILE} {} || true

decrypt: ## Decrypt all ansible-vault secrets
	@ls playbooks/vault/*.yml | xargs -L 1 -I{} ansible-vault decrypt --vault-password-file=${ANSIBLE_VAULT_PASSWORD_FILE} {} || true

##
## Execute plays
##
.PHONY: init init-remote-compute

ANSIBLE_TAGS ?= ""
ANSIBLE_CMD ?= ansible-playbook --vault-password-file=${ANSIBLE_VAULT_PASSWORD_FILE} -vvv --tags=${ANSIBLE_TAGS}

init: init-remote-compute ## Initialize all resources

init-remote-compute: ## Initialize remote compute resources
	@${ANSIBLE_CMD} -i inventory playbooks/remote-compute.yml

##
## Help
##
.DEFAULT_GOAL := help
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
