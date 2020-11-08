##
## Help
##
.DEFAULT_GOAL := help
.PHONY: help
help:
	@grep -E '^[a-zA-Z_\-\.]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: init fmt plan apply show inventory_hosts destroy clean

ENV ?= production
TF_IMAGE ?= hashicorp/terraform:light

docker_run_args := --rm -it \
	-e TF_CLI_CONFIG_FILE="/terraform.rc" \
	-v $(shell echo ~)/.terraform.d/credentials.tfrc.json:/terraform.rc \
	-v $(shell pwd)/../:/tcrypt \
	-w /tcrypt/tf/env/${ENV} \
	$(TF_IMAGE)

TF_BIN := docker run ${docker_run_args}
TF_BIN_WITH_ACCESS := docker run -e TF_VAR_provider_do_token=${DO_TOKEN} -e TF_VAR_provider_do_spaces_access_id=${DO_SPACES_TF_ACCESS_ID} -e TF_VAR_provider_do_spaces_secret_key=${DO_SPACES_TF_SECRET_KEY} ${docker_run_args}

init: ## Initialize module
	@${TF_BIN_WITH_ACCESS} init

fmt: ## Format code correctly
	@${TF_BIN} fmt

plan: ## Plan changes
	@${TF_BIN_WITH_ACCESS} plan

apply: ## Apply plan changes
	@${TF_BIN_WITH_ACCESS} apply

show: ## Show state
	@${TF_BIN_WITH_ACCESS} show

state.json: ## Create state.json from current state
	@${TF_BIN_WITH_ACCESS} show -json -no-color 2>&1 > state.json || echo rm -f state.json

inventory_hosts: state.json ## Create hosts section for Ansible inventory from the state
	@ruby ../scripts/make_inventory_hosts.rb state.json

rebuild_inventory_hosts: clean ## Create hosts section for Ansible inventory from the state and write it to disk
	@echo "Building new inventory hosts..."
	@make inventory_hosts > ../ansible/inventories/${ENV}/hosts.yml
	@echo "Wrote new inventory hosts:"
	@echo ""
	@cat ../ansible/inventories/${ENV}/hosts.yml


destroy: ## Destroy all resources
	@${TF_BIN_WITH_ACCESS} destroy ${TF_PROVIDER_VARS}

clean: ## Clean up old artifacts
	@(rm plan.out &> /dev/null && echo "Deleted plan.out") || echo "No plan.out to delete"
	@(rm state.json &> /dev/null && echo "Deleted state.json") || echo "No state.json to delete"
