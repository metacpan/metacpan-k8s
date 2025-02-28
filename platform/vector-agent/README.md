# Vector Agent

[Vector](https://github.com/vectordotdev/vector) is a high-performance
observability data pipeline that allows you to collect, transform, and route
all your logs, metrics, and traces. It is designed to be highly efficient and
reliable, making it a great choice for managing observability data at scale.

## Makefile Overview

This Makefile manages the Loki Helm chart, which simplifies the deployment and
management of Loki in a Kubernetes environment. The Makefile provides targets
to automate common tasks such as pulling the latest Loki YAML configuration,
upgrading Loki, and ensure required tools are present.

## Prerequisites

Before using the Makefile, ensure you have the following tools installed:

- `helm`

### Makefile Targets

- **all**: This is the default target that runs `check-tools`, `clean`, and
`manifests` targets in sequence.
- **init**: Adds the Vector Helm repository and updates the Helm repository
index.
- **manifests**: Removes the previous Vector Agent YAML file and pulls the
latest Vector Agent YAML configuration from the Helm chart using the specified
`values.yaml` file.
- **upgrade**: Removes the previous Vector Agent YAML file and upgrades the Loki
deployment using the latest configuration from the Helm chart.
- **check-tools**: Ensures that the required tools (e.g., Helm) are available
on the system.
- **help**: Displays usage information for the Makefile targets.

### Usage

1. **Initialize Helm Repository**

   Before using the Makefile, you need to initialize the Helm repository:

   ```sh
   make init
   ```

2. **Generate Vector Agent Manifests**

   To generate the Vector Agent YAML configuration file, run:

   ```sh
   make manifests
   ```

   This will remove the previous `vector-agent.yaml` file and pull the latest
   configuration from the Helm chart.

3. **Upgrade Vector Agent**

   To upgrade the Vector Agent deployment with the latest configuration, run:

   ```sh
   make upgrade
   ```

   This will remove the previous `vector-agent.yaml` file and upgrade the Loki deployment.

4. **Check Required Tools**

   Ensure the installation of required tools by running:

   ```sh
   make check-tools
   ```

   This will check that Helm is available on your system.

5. **Display Help**

   To display the help message with information about the Makefile targets, run:

   ```sh
   make help
   ```

### Default Variables

- **DEFAULT_VERSION**: The default version of Vector Agent to use (e.g.,
`0.37.0`).
- **VECTOR_VERSION**: The version of Vector Agent to use, which can be
overridden by setting this variable.
- **VECTOR_AGENT_OUTPUT_YAML**: The output file for the Vector Agent YAML
configuration (default: `vendor/vector-agent.yaml`).
- **VALUES_FILE**: The path to the `values.yaml` file used for Helm
configuration.

### Example

To generate the Vector Agent manifests using a specific version and values
file, you can run:

```sh
make VECTOR_VERSION=0.22.1 VALUES_FILE=/path/to/your/values.yaml manifests
```

This will pull the specified version of Vector Agent and use the provided
`values.yaml` file for configuration.
