.DEFAULT_GOAL := help

# Default Loki version
DEFAULT_VERSION := 6.29.0
LOKI_VERSION ?= $(DEFAULT_VERSION)
LOKI_OUTPUT_YAML := vendor/loki.yaml
VALUES_FILE := $(CURDIR)/values.yaml

.PHONY: all clean manifests check-tools

all: check-tools clean manifests

.PHONY: init
init:
	helm repo add grafana https://grafana.github.io/helm-charts
	helm repo update

.PHONY: manifests
manifests:
	@echo "Removing previous $(LOKI_OUTPUT_YAML)..."
	rm -f $(LOKI_OUTPUT_YAML)
	@echo "Pulling Loki YAML (Version: $(LOKI_VERSION)) from Helm chart..."
	helm repo update
	helm template loki --values $(VALUES_FILE) --namespace loki  grafana/loki --version $(LOKI_VERSION)  > $(LOKI_OUTPUT_YAML)

.PHONY: check-tools
check-tools:
	@command -v helm >/dev/null 2>&1 || { echo >&2 "helm is not installed. Aborting."; exit 1; }

# Help target to display usage information
.PHONY: help
help:
	@echo "Makefile for pulling Loki YAML"
	@echo ""
	@echo "Targets:"
	@echo "  init        : Add Loki helm chart repository"
	@echo "  manifests   : Pull Loki YAML from Helm chart with specified values.yaml and remove the old Loki YAML"
	@echo "  check-tools : ensure required tools are installed"
	@echo "  help        : Display this help message"
