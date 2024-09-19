
# bank-leumi-cluster Terraform EKS Setup

This Terraform project sets up an Amazon EKS cluster with managed node groups and a VPC. The configuration also includes adding a Jenkins user to the `aws-auth` ConfigMap to allow access to the cluster.

## Prerequisites

1. **Terraform**: Install Terraform on your local machine.
2. **AWS CLI**: Ensure AWS CLI is installed and configured with sufficient permissions.
3. **kubectl**: Install `kubectl` for managing Kubernetes clusters.
4. **Helm**: Install Helm to manage Kubernetes applications.

## Cluster Configuration Details

- **Region**: `us-east-1`
- **VPC CIDR**: `10.123.0.0/16`
- **Availability Zones**: `us-east-1a`, `us-east-1b`
- **Public Subnets**: `10.123.1.0/24`, `10.123.2.0/24`
- **Private Subnets**: `10.123.3.0/24`, `10.123.4.0/24`
- **Intra Subnets**: `10.123.5.0/24`, `10.123.6.0/24`
- **Managed Node Group**: Three different instance types are supported: `t3.micro`, `t3.small`, `t3.medium`, with a minimum of 2 and a maximum of 4 nodes.

## Steps to Run the EKS Cluster

Follow these steps to set up the EKS cluster:

### 1. Initialize Terraform

```bash
terraform init
```

This command initializes the Terraform configuration and downloads the necessary modules and plugins.

### 2. Apply Terraform Configuration

Run the following command to create the resources:

```bash
terraform apply
```

Type `yes` when prompted to confirm the plan.

This will:
- Create a VPC with public, private, and intra subnets.
- Create an EKS cluster with managed node groups.
- Apply security group rules for the EKS control plane and nodes.
- Add JenkinsUser to the `aws-auth` ConfigMap in Kubernetes to grant admin permissions.

### 3. Configure kubectl to Access the Cluster

Once the cluster is deployed, configure `kubectl` to access your EKS cluster:

```bash
aws eks --region us-east-1 update-kubeconfig --name bank_leumi
```

This command updates the kubeconfig file to use your new EKS cluster.

### 4. Deploy Kubernetes Resources

1. Apply your deployment and service YAML files:

   ```bash
   kubectl apply -f deployment.yaml
   kubectl apply -f service.yaml
   ```

   These files define your application deployment and expose it via a service.

### 5. Install Nginx Ingress Controller using Helm

Add the ingress-nginx Helm chart repository and update it:

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
```

Install the Nginx ingress controller with a Network Load Balancer (NLB):

```bash
helm install nginx-ingress ingress-nginx/ingress-nginx \
  --set controller.service.type=LoadBalancer \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-type"="nlb" \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-scheme"="internet-facing"
```

### 6. Apply Ingress Configuration

Apply your ingress configuration:

```bash
kubectl apply -f ingress.yaml
```

This configures the ingress controller to route traffic to your services.

### 7. Get the NLB DNS Name

After the Nginx ingress controller is deployed, retrieve the DNS name of the NLB:

```bash
kubectl get svc nginx-ingress-ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

This command will return the hostname of the NLB, which you can use to access your application.

## Clean Up Resources

To destroy the infrastructure when you no longer need it, run the following command:

```bash
terraform destroy
```

This will remove all resources created by this Terraform configuration.
