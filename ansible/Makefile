
ENV="production"

ANSIBLE_VAULT_PASSWORD_FILE ?= "$(shell pwd)/vault-password"
ANSIBLE_FLAGS ?= "-vvv"
ANSIBLE_CMD ?= ansible-playbook \
	-i inventories/${ENV} \
	--key-file=../secrets/ssh-compute.pub \
	--vault-password-file=${ANSIBLE_VAULT_PASSWORD_FILE} \
	${ANSIBLE_FLAGS}

##
## Dev utilities
##
.PHONY: install ssh-add encrypt

install: ## Install collections and roles from Ansible Galaxy
	ansible-galaxy collection install -r requirements.yml
	ansible-galaxy role install -r requirements.yml

ssh-add: ## Add ansible key to SSH agent
	@ssh-add ../secrets/ssh-compute.sec

vault-seal: ## Encrypt all ansible-vault secrets
	@(cd playbooks/config/vault-unsealed && ls *.yml | xargs -L 1 -I{} ansible-vault encrypt --vault-password-file=${ANSIBLE_VAULT_PASSWORD_FILE} {} --output ../vault/{})

vault-unseal: ## Decrypt all ansible-vault secrets
	@(cd playbooks/config/vault && ls *.yml | xargs -L 1 -I{} ansible-vault decrypt --vault-password-file=${ANSIBLE_VAULT_PASSWORD_FILE} {} --output ../vault-unsealed/{})

##
## Execute plays
##
.PHONY: infrastructure compute

infrastructure: compute ## Initialize and deploy all resources

compute: ## Initialize and deploy compute resources
	@${ANSIBLE_CMD} playbooks/compute.yml

##
## Help
##
.DEFAULT_GOAL := help
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
