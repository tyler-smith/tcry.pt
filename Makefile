export ENV ?= production
export ANSIBLE_CONFIG ?= $(shell pwd)/ansible.cfg
export ANSIBLE_REQUIREMENTS ?= $(shell pwd)/ansible/requirements.yml

CONTAINER_BIN ?= docker
ANSIBLE_GALAXY_BIN ?= ansible-galaxy
ANSIBLE_PLAYBOOK_BIN ?= ansible-playbook

BUILD_ENV_CONTAINER_IMAGE_NAME ?= tcr.pt/build-env

VAULT_UNSEALED_PATH ?= $(shell pwd)/secrets/vault
VAULT_SEALED_PATH ?= $(shell pwd)/ansible/playbooks/config/vault

.PHONY: install build_env build_env_image build_env_sh
.PHONY: ssh_agent vault_seal vault_unseal

install: ## Install external dependencies
	@ansible-galaxy collection install -r ${ANSIBLE_REQUIREMENTS}
	@ansible-galaxy role install -r ${ANSIBLE_REQUIREMENTS}

build_env_image: ## Builds the build env container image
	@${CONTAINER_BIN} build -t ${BUILD_ENV_CONTAINER_IMAGE_NAME} .

build_env: ## Install the build env in the current environment
	@${ANSIBLE_GALAXY_BIN} collection install -r ansible/requirements.yml
	@${ANSIBLE_GALAXY_BIN} role install -r ansible/requirements.yml
	@${ANSIBLE_PLAYBOOK_BIN} -i localhost, ansible/playbooks/build-env.yml

build_env_sh: ## Starts a shell inside the build env
	@${CONTAINER_BIN} run --rm -it \
		-v $(shell pwd):/code \
		-v $SSH_AUTH_SOCK:/ssh-agent \
		-e SSH_AUTH_SOCK=/ssh-agent \
		${BUILD_ENV_CONTAINER_IMAGE_NAME}

ssh_agent: ## Create a new ssh agent with the ansible controller key
	@eval "$(ssh-agent -s)"
	@ssh-add secrets/ssh-compute.sec

vault_seal: ## Seal all ansible-vault secrets
	@(cd ${VAULT_UNSEALED_PATH} && find . -name '*.yml' -exec ansible-vault encrypt {} --output ${VAULT_SEALED_PATH}/{} \;)

vault_unseal: ## Unseal all ansible-vault secrets
	@(cd ${VAULT_SEALED_PATH} && find . -name '*.yml' -exec ansible-vault decrypt {} --output ${VAULT_UNSEALED_PATH}/{} \;)

##
## Help
##
.DEFAULT_GOAL := help
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
