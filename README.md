# Azure Terraform Labs

A comprehensive collection of hands-on Terraform labs designed to teach Infrastructure as Code (IaC) on Microsoft Azure. This repository contains 16 progressive labs covering everything from basic Azure resource deployment to advanced Terraform concepts.

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Labs Structure](#labs-structure)
- [Getting Started](#getting-started)
- [Lab Descriptions](#lab-descriptions)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## 🎯 Overview

This repository provides a structured learning path for mastering Terraform on Azure. Each lab focuses on specific Terraform concepts and Azure resources, with practical examples and hands-on exercises. Whether you're new to Terraform or looking to enhance your Infrastructure as Code skills, these labs will guide you through essential concepts and best practices.

## ✅ Prerequisites

Before starting these labs, ensure you have:

- **Azure Account**: Active Azure subscription ([Create a free account](https://azure.microsoft.com/free/))
- **Azure CLI**: Installed and configured ([Installation guide](https://github.com/Azure/azure-cli))
- **Terraform**: Version 1.0+ installed ([Download](https://www.terraform.io/downloads))
- **Code Editor**: VS Code or similar IDE
- **Basic Knowledge**: Understanding of cloud computing concepts and command-line interfaces

### Initial Setup

1. Install Azure CLI following the instructions at https://github.com/Azure/azure-cli
2. Authenticate with Azure:
   ```bash
   az login
   ```
3. Create a service principal for Terraform:
   ```bash
   az ad sp create-for-rbac --name "terraform-labs" --role Contributor --scopes /subscriptions/{subscription-id}
   ```
   Save the output (`appId`, `password`, `tenant`) for authentication.

## 📚 Labs Structure

The repository contains 16 labs organized in progressive difficulty:

### Beginner Labs
- **Lab 0**: Azure Account Setup
- **Lab 1**: IDE Configuration
- **Lab 2**: First Resource Deployment
- **Lab 3**: Dynamic Infrastructure Deployment

### Intermediate Labs
- **Lab 4**: Deploy Nginx & Save IP Output
- **Lab 5**: Remote Backend Configuration
- **Lab 6**: Terraform Modules (Dev/Prod)
- **Lab 7**: Resource Dependencies (`depends_on`)
- **Lab 8**: Count & Count Index

### Advanced Labs
- **Lab 9**: Terraform `foreach` Loops
- **Lab 10**: Conditional Expressions
- **Lab 11**: Terraform Workspaces
- **Lab 12**: Terraform Console
- **Lab 13**: Dynamic Blocks
- **Lab 14**: Terraform Graph Visualization
- **Lab 15**: Terraform Plan Files
- **Lab 16**: Importing Existing Resources

## 🚀 Getting Started

### Quick Start

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd azure-terraform
   ```

2. **Navigate to a lab directory**:
   ```bash
   cd lab2-First\ resource\ deployment
   ```

3. **Initialize Terraform**:
   ```bash
   terraform init
   ```

4. **Format and validate configuration**:
   ```bash
   terraform fmt
   terraform validate
   ```

5. **Plan infrastructure changes**:
   ```bash
   terraform plan
   ```

6. **Apply configuration**:
   ```bash
   terraform apply -auto-approve
   ```

7. **Clean up resources**:
   ```bash
   terraform destroy -auto-approve
   ```

## 📖 Lab Descriptions

### Lab 0: Create Azure Account
Set up your Azure account and prepare your environment for Terraform development.

### Lab 1: IDE Configuration
Configure your development environment with proper tools and extensions for Terraform development.

### Lab 2: First Resource Deployment
Deploy your first Azure resource using Terraform. Learn the basic Terraform workflow and commands.

**Resources**: Resource Group

### Lab 3: Deploy Dynamic Infrastructure
Learn to use variables and data sources to create dynamic, reusable Terraform configurations.

**Resources**: Storage Account, Resource Group

### Lab 4: Deploy Nginx & Save IP Output
Deploy a virtual machine with Nginx web server and capture the public IP address using outputs.

**Resources**: VM, Public IP, Network Interface

### Lab 5: Remote Backend
Configure Azure Storage as a remote backend for storing Terraform state files securely.

**Concepts**: State management, remote backends, collaboration

### Lab 6: Terraform Modules
Create reusable modules and deploy infrastructure across multiple environments (dev/prod).

**Modules**: 
- Resource Group
- Network
- Network Security Group
- Public IP
- Virtual Machine
- Storage Account

### Lab 7: Resource Dependencies
Master explicit resource dependencies using `depends_on` to control resource creation order.

### Lab 8: Count & Count Index
Use `count` and `count.index` to create multiple similar resources efficiently.

### Lab 9: Terraform `foreach`
Leverage `for_each` loops for creating multiple resources from maps and sets.

### Lab 10: Conditional Expressions
Implement conditional logic in Terraform using ternary operators and dynamic resource creation.

### Lab 11: Terraform Workspaces
Manage multiple environments (dev, staging, prod) using Terraform workspaces.

### Lab 12: Terraform Console
Use the Terraform console for testing expressions and debugging configurations.

### Lab 13: Dynamic Blocks
Create dynamic nested blocks to reduce code repetition and increase flexibility.

### Lab 14: Terraform Graph
Visualize resource dependencies using `terraform graph` and GraphViz.

### Lab 15: Terraform Plan Files
Save and use Terraform plan files for approval workflows and consistent deployments.

### Lab 16: Import Existing Resources
Import existing Azure resources into Terraform state management.

## 💻 Usage

### General Workflow

Each lab follows a standard workflow:

```bash
# Navigate to lab directory
cd labXX-lab-name

# Initialize Terraform (download providers)
terraform init

# Format code (optional but recommended)
terraform fmt

# Validate syntax
terraform validate

# Preview changes
terraform plan

# Apply changes
terraform apply -auto-approve

# Destroy resources (cleanup)
terraform destroy -auto-approve
```

### Customizing Variables

Most labs use variables defined in `variables.tf` and values in `terraform.tfvars`:

```hcl
# terraform.tfvars
location    = "East US"
environment = "dev"
```

You can override variables during apply:

```bash
terraform apply -var="location=West Europe" -var="environment=prod"
```

## 🛠️ Common Commands

| Command | Description |
|---------|-------------|
| `terraform init` | Initialize working directory |
| `terraform fmt` | Format code to canonical style |
| `terraform validate` | Validate configuration syntax |
| `terraform plan` | Show execution plan |
| `terraform apply` | Apply configuration changes |
| `terraform destroy` | Destroy managed infrastructure |
| `terraform output` | Display output values |
| `terraform show` | Show current state |
| `terraform graph` | Generate dependency graph |

## 🤝 Contributing

Contributions are welcome! If you'd like to add new labs or improve existing ones:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-lab`)
3. Commit your changes (`git commit -m 'Add new lab on XYZ'`)
4. Push to the branch (`git push origin feature/new-lab`)
5. Open a Pull Request

## ⚠️ Important Notes

- **Cost Management**: Remember to destroy resources after completing labs to avoid unnecessary Azure charges
- **Naming Conventions**: Storage account names must be 3-24 characters, lowercase letters and numbers only
- **State Files**: Never commit `.tfstate` files to version control
- **Credentials**: Keep Azure credentials secure and never commit them to the repository

## 📄 License

This project is available for educational purposes. Feel free to use and modify for your learning journey.

## 🙋 Support

If you encounter issues or have questions:
1. Check the lab-specific `note.txt` files for additional guidance
2. Review Terraform documentation at [terraform.io](https://www.terraform.io/docs)
3. Consult Azure provider documentation at [registry.terraform.io](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

---

**Happy Learning! 🚀**

*Master Infrastructure as Code with Terraform on Azure*
