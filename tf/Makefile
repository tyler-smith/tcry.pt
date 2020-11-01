##
## Help
##
.DEFAULT_GOAL := help
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: init fmt plan apply show destroy clean

TF_ENV ?= production
TF_IMAGE ?= hashicorp/terraform:light

docker_run_args := --rm -it -e TF_CLI_CONFIG_FILE="/root/terraform.rc" -v $(shell echo ~)/.terraform.d/credentials.tfrc.json:/root/terraform.rc -v $(shell pwd):/tf -w /tf/env/${TF_ENV} $(TF_IMAGE)
TF_BIN := docker run ${docker_run_args}
TF_BIN_WITH_ACCESS := docker run -e TF_VAR_provider_do_token=${DO_TOKEN} -e TF_VAR_provider_do_spaces_access_id=${DO_SPACES_TF_ACCESS_ID} -e TF_VAR_provider_do_spaces_secret_key=${DO_SPACES_TF_SECRET_KEY} ${docker_run_args}

init: ## Initialize module
	@${TF_BIN} init

fmt: ## Format code correctly
	@${TF_BIN} fmt

plan: ## Plan changes
	${TF_BIN_WITH_ACCESS} plan -out plan.out

apply: ## Apply planned changes
	@${TF_BIN_WITH_ACCESS} apply plan.out

show: ## Show state
	@${TF_BIN} show

destroy: ## Destroy all resources
	@${TF_BIN} destroy ${TF_PROVIDER_VARS}

clean: ## Clean up old artifacts
	@(rm plan.out &> /dev/null && echo "Removed plan.out") || echo "No plan.out to delete"
