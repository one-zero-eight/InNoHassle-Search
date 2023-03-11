CURRENT_DIR=$(shell pwd)
BIN_DIR=${CURRENT_DIR}/bin
PACKAGE=github.com/one-zero-eight/Search/cmd/app
GOLANGCI_LINT_VERSION:=$(shell golangci-lint --version 2> /dev/null)
GOOSE_VERSION:=$(shell goose --version 2> /dev/null)

# Some colors for formatting
CLR_GREEN=\033[32m

##@ Common

# The help target prints out all targets with their descriptions organized
# beneath their categories. The categories are represented by '##@' and the
# target descriptions by '##'. The awk commands is responsible for reading the
# entire set of makefiles included in this invocation, looking for lines of the
# file as xyz: ## something, and then pretty-format the target and help. Then,
# if there's a line with ##@ something, that gets pretty-printed as a category.
#
# Source: https://www.padok.fr/en/blog/beautiful-makefile-awk
.PHONY: help
help:  ## display this message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Development

.PHONY: build
build:  ## build application
	go build -o ${BIN_DIR}/app ${PACKAGE}

.PHONY: run
run: build  ## run application
	go run ${PACKAGE}

.PHONY: lint
lint: golangci-lint-installed  ## run linters
	@golangci-lint run && echo "${CLR_GREEN}ok"


# Helpers

.PHONY: golangci-lint-installed
golangci-lint:
ifndef GOLANGCI_LINT_VERSION
	@echo "golangci-lint is not installed (https://golangci-lint.run/usage/install/)" && exit 1
endif

.PHONY: gooose-installed
gooose-installed:
ifndef GOOSE_VERSION
	@echo "goose is not installed (https://pressly.github.io/goose/)" && exit 1
endif
