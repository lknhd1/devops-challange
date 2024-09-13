# Terraform Infrastructure for Guestbook Application

This repository contains Terraform configurations for deploying a guestbook application in the Azure cloud using Azure resources such as Cosmos DB, Virtual Networks, and Key Vault.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Structure](#structure)
- [Outputs](#outputs)
- [License](#license)

## Overview

The infrastructure is designed to support a guestbook application with the following Azure services:
- Azure Cosmos DB with MongoDB API
- Azure Key Vault
- Azure Virtual Network and Subnets for secure communication
- Azure Resource Group for logical organization of resources

## Prerequisites

Before deploying the infrastructure, ensure you have the following:

- An Azure account with sufficient privileges to create resources.
- [Terraform](https://www.terraform.io/downloads.html) installed (version >= 1.9.0 and < 1.10.0).
- Azure CLI installed and configured on your machine.

## Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/lknhd1/devops-challange.git
   cd devops-challange/infrastructure

2. Update terraform.tfvars file with desired values:
   ```bash
   ## General
   app_name = "guestbook-sea"
   region   = "southeastasia"
   
   ## App Service
   service_sku_name = "B1"
   repo_url         = "github.com/lknhd1/devops-challange"
   branch           = "main"
   ```

3. Initialize Terraform:
   ```
   terraform init
   ```

4. Plan the deployment to see what resources will be created:
   ```
   terraform plan
   ```

5. Apply the configuration to create the resources:
   ```
   terraform apply
   ```
6. Confirm the application of the changes.

## Structure
The main Terraform configuration files are organized as follows:

* `terraform.tfvars`: Variables for configuring the deployment.
* `provider.tf`: Provider configurations for Terraform to interact with Azure.
* `main.tf`: Resource group definition.
* `db.tf`: Definitions for Cosmos DB resources.
* `network.tf`: Network configuration, including Virtual Network and Subnets.
* `key_vault.tf`: Key Vault resources and access policies.
* `output.tf`: Outputs for key resources and connection strings.

## Outputs
After the deployment completes, you can find the following outputs:
* `app_service_url`: The URL of the deployed app service.
* `cosmosdb_mongo_connection_string`: The connection string for Cosmos DB (sensitive value).
