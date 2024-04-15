# Terraform-AWS-EFS-CSI-Driver
This repository contains Terraform code for deploying an AWS EFS CSI Driver.

## Getting Started

To get started, follow these instructions:

### Prerequisites

- Terraform installed on your local machine. You can download it from [here](https://www.terraform.io/downloads.html).
- An AWS account with appropriate permissions to create resources.
- Set the following Terraform variables as environment variables on your machine:

    ```bash
    export TF_VAR_cluster_ca_cert="EKS-CA"
    export TF_VAR_cluster_endpoint="EKS-Endpoint"
    export TF_VAR_cluster_endpoint="cluster_name"
    ```

    Replace `EKS-CA` with the actual cluster's CA certificate, and `EKS-Endpoint` with the actual endpoint of your EKS cluster.

### Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/mohamedezz96/Terraform-AWS-EFS-CSI-Driver.git
    ```
2. Change into the project directory:

    ```bash
    cd Terraform-AWS-EFS-CSI-Driver
    ```
### Configuration
#### aws_efs_csi_driver.tf
- `aws_efs_csi_driver_version`: The version of the EFS CSI Driver Helm Chart to use.
- `aws_efs_csi_driver_role_name`: The name of the IAM role that will be created for the EFS CSI Driver controller.
- `aws_efs_controller_sa_name`: The name of the Kubernetes serviceaccount that will be created for the EFS CSI Driver controller.
- `aws_efs_node_sa_name`: The name of the Kubernetes serviceaccount that will be created for the EFS CSI Driver Node.
- `values_file`: The path to the YAML file containing additional configuration values for the AWS EFS CSI Driver.

### Deployment

Once configured, you can deploy the ALB controller by running:

```bash
terraform init
terraform plan
terraform apply --auto-approve
```




