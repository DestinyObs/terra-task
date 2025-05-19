# Terraform AWS Infrastructure for Web Application

## Overview

This project provides a clean, modular, and reusable Terraform setup to provision the basic AWS infrastructure required for a web application. It includes separate modules for **networking (VPC)** and **compute (EC2 instance)** resources, with infrastructure organized for two environments: **development (dev)** and **production (prod)**.

The Terraform state files are stored remotely in **Amazon S3 buckets**, ensuring safe and centralized state management for collaboration and CI/CD integration.

---

## Project Structure

The directory structure is designed to isolate concerns and maximize reusability and modularity:

```
.
├── compute
│   └── ec2
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── providers.tf
├── network
│   └── vpc
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── providers.tf
├── env
│   ├── dev
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── backend.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tfvars
│   └── prod
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── providers.tf
│       ├── backend.tf
│       ├── terraform.tfvars
│       └── backend.tfvars
├── main.tf
├── providers.tf
└── backend.tf
```

---

## Folder and File Descriptions

### 1. **compute/ec2/**

* **main.tf:** Contains the resource definitions for the EC2 instance(s), including AMI, instance type, subnet association, security groups, and tags.

* **variables.tf:** Defines all the variables used in the EC2 module, such as instance type, AMI ID, subnet IDs, key names, etc., allowing parameterization.

* **outputs.tf:** Exports useful information about the created EC2 instance(s), such as the public IP, instance ID, and DNS name, so they can be consumed by other modules or outputs.

* **providers.tf:** Specifies the AWS provider configuration scoped for the compute module, allowing provider version locking or region defaults if needed.

### 2. **network/vpc/**

* **main.tf:** Defines the VPC resource, subnets, route tables, internet gateway, and other networking components necessary to form the virtual network.

* **variables.tf:** Lists configurable parameters like CIDR blocks, subnet configurations, availability zones, and tags, facilitating environment-specific customization.

* **outputs.tf:** Exposes outputs such as the VPC ID, subnet IDs, and route table IDs that are required for associating compute resources and routing.

* **providers.tf:** Contains the AWS provider configuration for the networking module.

### 3. **env/dev/** and **env/prod/**

Each environment folder holds environment-specific configuration and is structured as a standalone Terraform project:

* **main.tf:** Calls and wires together the modules for network and compute, passing environment-specific variables.

* **variables.tf:** Declares environment-specific variables and inputs for modules.

* **outputs.tf:** Aggregates outputs from the modules to expose environment-level info.

* **providers.tf:** Configures the AWS provider for the environment, including region and authentication.

* **backend.tf:** Defines the remote state backend configuration for Terraform, specifying the S3 bucket, key, and region for storing the Terraform state file.

* **terraform.tfvars:** Holds environment-specific variable values such as VPC CIDR, instance types, AMI IDs, etc.

* **backend.tfvars:** Contains sensitive backend configuration details such as the S3 bucket name, key (state file path), and region. This is used to decouple sensitive info from code and enable easy switching between backends.

---

## Remote State Management Using S3

Terraform's remote state is stored in an **S3 bucket**, enabling safe state locking and collaboration. This setup ensures that:

* Terraform state files are **centralized** and not stored locally on developer machines.
* Multiple users and CI pipelines can work safely without corrupting state.
* State locking is enabled (via DynamoDB, if configured) to avoid race conditions.

### Important: You must **create the S3 buckets before running `terraform init`**

Terraform requires the S3 bucket for remote state to exist **before** initialization because:

* It needs to access the bucket to read and write the state.
* Terraform cannot create the bucket itself when configuring the backend.

---

### How to create the S3 buckets:

You can create the S3 buckets manually via AWS CLI or AWS Console.

**Example CLI command for US East (N. Virginia) region (us-east-1):**

```bash
aws s3api create-bucket --bucket terra-task-dev-state --region us-east-1
aws s3api create-bucket --bucket terra-task-prod-state --region us-east-1
```

> For regions other than `us-east-1`, add the `--create-bucket-configuration LocationConstraint=<region>` flag.

---

## Usage Instructions

### 1. Prepare your AWS Credentials

* Set your AWS Access Key ID and Secret Access Key securely.
* You can export them as environment variables or use the AWS CLI configured profiles.

Example:

```bash
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
```

---

### 2. Create the S3 Buckets for Remote State

Run the AWS CLI commands to create the buckets needed for storing Terraform state for each environment as shown above.

---

### 3. Initialize Terraform in the Environment Folder

Example for the development environment:

```bash
cd env/dev
terraform init
```

This will initialize Terraform with the remote backend pointing to the S3 bucket you created.

---

### 4. Plan and Apply Infrastructure

After initialization:

```bash
terraform plan
terraform apply
```

This will create the entire infrastructure stack for that environment:

* VPC and networking components via the network module
* EC2 instance(s) via the compute module

Repeat the same steps for the `prod` environment in `env/prod`.

---

### 5. Modifying Infrastructure

* Change variables in `terraform.tfvars` for environment-specific customizations.
* Run `terraform plan` to see proposed changes.
* Run `terraform apply` to apply changes safely.

---

## Reusability and Modularity

* Each module (compute, network) is **self-contained** and reusable across environments.
* Variables allow **customizing resources** without changing module code.
* Outputs allow easy **integration** between modules.
* Environment folders fully **isolate** dev and prod configs.
* Backend config is **decoupled** via `.tfvars` files for security and flexibility.

---

## Troubleshooting

### Common Errors

* **S3 bucket does not exist:**
  Make sure the S3 bucket you referenced in `backend.tf` exists before running `terraform init`.

* **InvalidLocationConstraint when creating buckets:**
  For `us-east-1`, do not specify the `LocationConstraint` parameter.

* **Access denied errors:**
  Verify AWS credentials and permissions for S3 and EC2.

---

## Summary

This Terraform project provides:

* Modularized infrastructure code for **VPC and EC2**.
* Environment isolation for **dev** and **prod**.
* Remote state management using **S3 buckets**.
* Fully parameterized and reusable Terraform modules.
* Secure backend configuration using `.tfvars` files.

Use this as a solid foundation for building scalable and maintainable AWS infrastructure for your web applications.

---

If you have any questions or need further help with Terraform, feel free to ask.

---

# End of README
