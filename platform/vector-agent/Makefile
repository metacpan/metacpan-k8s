.DEFAULT_GOAL := help

# Default Vector version
DEFAULT_VERSION := 0.37.0
VECTOR_VERSION ?= $(DEFAULT_VERSION)
VECTOR_AGENT_OUTPUT_YAML := vendor/vector-agent.yaml
AGENT_VALUES_FILE := $(CURDIR)/values.yaml

.PHONY: all clean manifests check-tools

all: check-tools clean manifests

.PHONY: init
init:
	helm repo add vector https://helm.vector.dev
	helm repo update

.PHONY: manifests
manifests:
	@echo "Removing previous $(VECTOR_AGENT_OUTPUT_YAML)..."
	rm -f $(VECTOR_AGENT_OUTPUT_YAML)
	@echo "Pulling Vector YAML (Version: $(VECTOR_VERSION)) from Helm chart..."
	helm repo update
	helm template vector --values $(AGENT_VALUES_FILE) --namespace vector-agent  vector/vector --version $(VECTOR_VERSION)  > $(VECTOR_AGENT_OUTPUT_YAML)

.PHONY: upgrade
upgrade:
	@echo "Removing previous $(VECTOR_AGENT_OUTPUT_YAML)..."
	rm -f $(VECTOR_AGENT_OUTPUT_YAML)
	@echo "Pulling Vector YAML (Version: $(VECTOR_VERSION)) from Helm chart..."
	helm repo update
	helm upgrade --values $(AGENT_VALUES_FILE) --namespace vector-agent vector/vector  > $(VECTOR_AGENT_OUTPUT_YAML)

.PHONY: check-tools
check-tools:
	@command -v helm >/dev/null 2>&1 || { echo >&2 "helm is not installed. Aborting."; exit 1; }

# Help target to display usage information
.PHONY: help
help:
	@echo "Makefile for pulling Vector YAML"
	@echo ""
	@echo "Targets:"
	@echo "  init        : Add Loki helm chart repository"
	@echo "  manifests   : Pull Vector YAML from Helm chart with specified values.yaml and remove the old Vector YAML"
	@echo "  upgrade     : Pull Vector YAML from Helm chart with specified values.yaml and upgrade the old Vector YAML"
	@echo "  check-tools : ensure required tools are installed"
	@echo "  help        : Display this help message"
