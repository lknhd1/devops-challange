# Devops Challenge

This repository contains source code, Terraform configurations, and CI/CD setups for deploying a guestbook application (based on NodeJS 18) on the Azure cloud using Azure resources such as Cosmos DB, Virtual Networks, and Key Vault.

The deployed version on my azure account and github repository is accessible on this URL: https://guestbook.lknhd.my.id/

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
  - [Infrastructure](#infrastructure)
  - [CI/CD](#cicd)
  - [Monitoring](#monitoring)
  - [Security](#security)
  - [Scalability](#scalability)
- [Bonus](#bonus)
- [Outputs](#outputs)
- [License](#license)

## Overview

The infrastructure is designed to support a guestbook application with the following Azure services:
- Azure Cosmos DB with MongoDB API
- Azure Key Vault
- Azure Virtual Network and Subnets for secure communication
- Azure Resource Group for logical organization of resources

## Prerequisites

Before deploying the guestbook app, ensure you have the following:

- An Azure account with sufficient privileges to create resources.
- [Terraform](https://www.terraform.io/downloads.html) installed (version >= 1.9.0 and < 1.10.0).
- Azure CLI installed and configured on your machine.
- Azure storage container for storing the Terraform state.

## Usage

### Infrastructure

First, let's provision the infrastructure.

1. Clone the repository:
   ```bash
   git clone https://github.com/lknhd1/devops-challange.git
   cd devops-challange/infrastructure
   ```

1. Update the `provider.tf` file with the appropriate values for the Terraform backend configuration:
    
    ```hcl
    backend "azurerm" {
      resource_group_name  = "<your_rg_for_tfstate_storage_account>"
      storage_account_name = "<storage_account_name_for_tfstate>"
      container_name       = "tfstate"
      key                  = "guestbook.tfstate"
    }
    ```
    
2. Customize `terraform.tfvars` with your desired values:
    
    ```hcl
    ## General
    app_name = "guestbook-sea"
    region   = "southeastasia"
    
    ## App Service
    service_sku_name = "B1"
    ```
    
3. Initialize Terraform:
    
    ```bash
    terraform init
    ```
    
3. Set your subscription ID and tenant ID via environment variable:
    ```bash
    export TF_VAR_subscription_id="<changeme>"
    export TF_VAR_tenant_id="<changeme>"
    ```

4. Review the planned resource changes:
    
    ```bash
    terraform plan
    ```
    
5. Deploy the infrastructure:
    
    ```bash
    terraform apply
    ```
    

At this stage, the following resources will be provisioned:

- Azure VNet and Subnet for secure internal communication
- CosmosDB instance using the MongoDB API
- Azure Key Vault for securely storing credentials and connection details
- Azure App Service instance (not yet connected to your GitHub repository)
- Azure Log Analytics for centralized logging (including HTTP access logs and app logs)

### CI/CD Setup

In this repository, CI/CD setup is configured using github workflow that are provided by the Azure App Service. The configuration is defined in this file: [main_guestbook-sea-app.yml](.github/workflows/main_guestbook-sea-app.yml)

To set up CI/CD with your GitHub repository:

1. Push the application source code to your GitHub account:
    
    ```bash
    git remote set-url origin <your_repo_url>
    git push
    ```
    
2. In the Azure portal, navigate to your App Service and select **Deployment Center** from the sidebar.
3. Follow the instructions to link your GitHub repository. Ensure your Azure account is connected to GitHub.
4. Azure will automatically update your GitHub repository with a deployment workflow located at `.github/workflows/<branch>_<app-name>.yaml`.
5. The initial pipeline will start deploying the application. Future deployments can be triggered by pushing changes to the `main` branch, though it's recommended to use Pull Requests (PRs) for updates. Example PRs and pipelines:
    - [PR](https://github.com/lknhd1/devops-challenge/pull/4)
    - [Pipeline](https://github.com/lknhd1/devops-challange/actions/runs/10858991043)
6. To roll back a deployment, use the GitHub PR **revert** option, which will create a new PR that, once merged, triggers a pipeline to deploy the reverted version.
    - [PR](https://github.com/lknhd1/devops-challenge/pull/5)
    - [Pipeline](https://github.com/lknhd1/devops-challange/actions/runs/10859074690)

### Monitoring

- **Alerts:** Configured in [`monitoring_alerting.tf`](./infrastructure/monitoring_alerting.tf).
- **Logs:** Collected in Azure Log Analytics as defined in [`monitoring_logging.tf`](./infrastructure/monitoring_logging.tf).


### Security

- **Database credentials** (username and password) and the **CosmosDB hostname** are securely stored in Azure Key Vault.
- The App Service retrieves these secrets directly from the Key Vault.
- **TLS certificates** for the default domain (`azurewebsites.net`) are automatically provisioned. For a custom domain:
    1. Navigate to the **Custom Domains** section within your App Service in the Azure portal.
    2. Add your custom domain and follow the instructions to update your DNS provider with the provided CNAME and TXT records.
    3. Once the domain is verified, Azure will automatically provision a TLS certificate for the custom domain.
- Other security measures:
  - The CosmosDB instance is configured to be not accessible via internet, only app service subnet is whitelisted

### Scalability

There are two main options for scaling:

1. **Vertical Scaling** (Scaling Up): Increase the resource capacity (CPU/RAM) of your App Service by modifying the `service_sku_name` variable in `terraform.tfvars`, and then apply the configuration changes.
2. **Horizontal Scaling** (Scaling Out): Scale the number of instances of your App Service:
    - **Manual Scaling**: Go to the Azure portal, navigate to your App Service’s **Scale Out** settings, and adjust the instance count using the slider.
    - **Autoscaling**: Configure autoscaling based on performance metrics (e.g., CPU usage or traffic) by setting up rules in the **Scale Out** settings.
    - Configure autoscaling based on performance metrics like CPU usage or traffic.


### Bonus

- **Rollback**: Quickly and easily revert changes using GitHub's PR revert feature, which requires no additional configuration.
- **Disaster Recovery (DRC)**: Ensure high availability and resilience by implementing a multi-region setup with Azure App Service and Azure Cosmos DB. In case of a regional failure:

  1. Update the DNS CNAME to redirect traffic to the alternate region.
  2. Ensure that Azure Cosmos DB is configured with multi-region writes and automatic failover for seamless data replication and continuity.


## Deployed version

Here's the deployed version on my azure account and github repository guestbbok: https://guestbook.lknhd.my.id/