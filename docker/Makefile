DOCKER_REPO ?= "tylersmith"
DOCKER_TAG ?= $(git rev-parse --short HEAD)

define build
	echo "Building ${DOCKER_REPO}/$(1):${DOCKER_TAG}..."
	docker build -t ${DOCKER_REPO}/$(1):${DOCKER_TAG} - < Dockerfile.$(1)
endef

.PHONY: all git-http-backend php-with-git

all: git-http-backend php-with-git ## Build all images

git-http-backend: ## Build git-http-backend image
	@$(call build,git-http-backend)

php-with-git: ## Build php-with-git image
	@$(call build,php-with-git)

##
## Help
##
.DEFAULT_GOAL := help
.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
