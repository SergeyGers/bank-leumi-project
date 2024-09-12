
# AWS EC2 Instance Setup with Apache and Elastic IP using Terraform

This project provisions an EC2 instance in AWS using Terraform. The instance runs Apache on port 80 and is assigned a static Elastic IP. The security group restricts access to HTTP traffic from a specific IP address.

## Tools Used:
- **Terraform**: Used for infrastructure as code (IaC) to automate the provisioning of EC2, Elastic IP, and security groups.
- **AWS EC2**: A single EC2 instance is provisioned and configured to run Apache.
- **Elastic IP**: An Elastic IP is allocated and associated with the EC2 instance to provide a static IP address.

## Resources Created:
- **EC2 Instance**: A t2.micro EC2 instance is provisioned with Ubuntu and Apache installed.
- **Security Group**: Ingress rules are applied to allow HTTP traffic on port 80 only from a specific IP (`91.231.246.50`).
- **Elastic IP**: A static Elastic IP is allocated and attached to the EC2 instance for consistent public access.

## Infrastructure Setup:
1. **EC2 Instance**: The instance is running Ubuntu with Apache installed and automatically started.
2. **Security**: A security group allows HTTP traffic (port 80) only from a specific public IP (`91.231.246.50`).
3. **Elastic IP**: The instance is given a static Elastic IP for consistent and reliable access.

## Prerequisites:
- AWS CLI configured with appropriate permissions.
- Terraform installed on your local machine.
- A valid SSH key pair available in AWS (replace `infinity_key_web` with your key).

## How to Use:

1. **Clone the Repository**:
   Clone the repository that contains the Terraform scripts for setting up the EC2 instance.

   ```bash
   git clone https://github.com/SergeyGers/bank-leumi-project
   cd <repository-directory>
   ```

2. **Modify Configuration (if needed)**:
   Update the AMI, key name, and allowed IP address in the `main.tf` file if you need to work with different resources.

3. **Initialize Terraform**:
   Run the following command to initialize Terraform:

   ```bash
   terraform init
   ```

4. **Plan the Infrastructure**:
   Generate an execution plan to preview the changes Terraform will make:

   ```bash
   terraform plan
   ```

5. **Apply the Changes**:
   Run the following command to apply the Terraform configuration and create the resources:

   ```bash
   terraform apply
   ```

   Confirm the changes by typing `yes` when prompted.

6. **Check the Setup**:
   After the deployment is complete, go to the AWS Management Console:
   - Verify that the EC2 instance is running under EC2 > Instances.
   - Check that the **Elastic IP** is attached to the EC2 instance.
   - Test accessing Apache by visiting `http://<Elastic_IP>` in your browser.

## Configuration Details:

- **EC2 Instance**: `test-ec2`
- **AMI**: `ami-0e86e20dae9224db8` (Ubuntu)
- **Instance Type**: `t2.micro`
- **Elastic IP**: Automatically allocated and attached
- **Security Group**: Restricts HTTP traffic to `91.231.246.50/32`
- **Key Pair**: `infinity_key_web`

## Cleanup:
To destroy the resources created by Terraform, run:

```bash
terraform destroy
```

This will remove the EC2 instance, security group, and Elastic IP.

## Troubleshooting:
- **Unable to Access Apache**: Ensure the security group allows traffic from your IP on port 80.
- **Elastic IP Not Attached**: Check the Terraform output to ensure the Elastic IP was allocated and attached successfully.

## Author:
This setup was created as part of a project to automate the deployment of an EC2 instance running Apache with a static Elastic IP using Terraform.
