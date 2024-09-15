
# AWS Network Load Balancer (NLB) Setup with Terraform

This project sets up a Network Load Balancer (NLB) using Terraform and connects it to two EC2 instances. The NLB listens on port 80 and forwards traffic to the target instances securely through a specific security group.

## Tools Used:
- **Terraform**: Used for infrastructure as code (IaC) to automate the provisioning of the NLB, target groups, and security groups.
- **AWS EC2**: Two EC2 instances are used as targets for the load balancer.
- **AWS Network Load Balancer (NLB)**: Provides high availability and network-level traffic routing to the EC2 instances.

## Resources Created:
- **Network Load Balancer (NLB)**: The NLB listens on port 80 and distributes traffic to two EC2 instances.
- **Target Groups**: A target group is created for the EC2 instances, which are attached to the NLB.
- **Security Group Rule**: Ingress rules are applied to allow traffic on port 80 only from the NLB to the EC2 instances.

## Infrastructure Setup:
1. **Subnets**: The NLB is configured with two subnets for high availability.
2. **EC2 Instances**: Two EC2 instances are attached to the target group and receive traffic on port 80.
3. **Security**: A security group rule ensures that only traffic from the NLB's VPC (CIDR: `192.168.0.0/16`) is allowed to reach the instances on port 80.

## Prerequisites:
- AWS CLI configured with appropriate permissions.
- Terraform installed on your local machine.

## How to Use:

1. **Clone the Repository**:
   Clone the repository that contains the Terraform scripts for setting up the NLB.

   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Modify Configuration (if needed)**:
   Update the EC2 instance IDs, subnet IDs, and VPC ID in the `main.tf` file if you need to work with different resources.

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
   - Check the **NLB** under EC2 > Load Balancers.
   - Verify that the **Target Group** has your instances registered and in a healthy state.
   - Test accessing your application via the NLB’s DNS name on port 80.

## Configuration Details:

- **Load Balancer**: `my-nlb`
- **Subnets**: 
  - Subnet 1: `subnet-0fdd0dd87a683963c`
  - Subnet 2: `subnet-074d384774bfc4b40`
- **VPC**: `vpc-0158e9502a72fe166`
- **Target Instances**: 
  - `i-0f5566fb146579346`
  - `i-0c10b10d32a315c59`
- **Security Group**: `sg-02a18275ff7e54631`
- **Allowed Traffic**: CIDR Block: `192.168.0.0/16` (VPC CIDR)

## Cleanup:
To destroy the resources created by Terraform, run:

```bash
terraform destroy
```

This will remove the NLB, target groups, and other resources created by the script.

## Troubleshooting:
- **NLB Not Responding**: Check if the target instances are in a healthy state within the target group.
- **Access Denied**: Ensure the correct security group rules are in place to allow traffic from the NLB.

## Author:
This setup was created as part of a project to automate the deployment of a Network Load Balancer on AWS using Terraform.
