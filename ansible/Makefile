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
	@ssh-add ../secrets/ssh-compute.sec

encrypt: ## Encrypt all ansible-vault secrets
	@ls playbooks/vault/*.yml | xargs -L 1 -I{} ansible-vault encrypt --vault-password-file=${ANSIBLE_VAULT_PASSWORD_FILE} {} || true

decrypt: ## Decrypt all ansible-vault secrets
	@ls playbooks/vault/*.yml | xargs -L 1 -I{} ansible-vault decrypt --vault-password-file=${ANSIBLE_VAULT_PASSWORD_FILE} {} || true

##
## Execute plays
##
.PHONY: infrastructure compute

ANSIBLE_FLAGS ?= "-vvv"
ANSIBLE_CMD ?= ansible-playbook --key-file=../secrets/ssh-compute.pub --vault-password-file=${ANSIBLE_VAULT_PASSWORD_FILE} ${ANSIBLE_FLAGS}

infrastructure: compute ## Initialize and deploy all resources

compute: ## Initialize and compute resources
	@${ANSIBLE_CMD} -i inventories/production.yml playbooks/compute.yml

##
## Help
##
.DEFAULT_GOAL := help
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
