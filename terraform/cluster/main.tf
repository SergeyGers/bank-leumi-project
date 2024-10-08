# main.tf

provider "aws" {
  region = local.region
}

locals {
  name   = "bank_leumi"
  region = "us-east-1"

  vpc_cidr = "10.123.0.0/16"
  azs      = ["us-east-1a", "us-east-1b"]

  public_subnets  = ["10.123.1.0/24", "10.123.2.0/24"]
  private_subnets = ["10.123.3.0/24", "10.123.4.0/24"]
  intra_subnets   = ["10.123.5.0/24", "10.123.6.0/24"]

  tags = {
    Example = local.name
  }

	jenkins_user_arn = "arn:aws:iam::141330218853:user/JenkinsUser"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 4.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  intra_subnets   = local.intra_subnets

  enable_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.1"

  cluster_name                   = local.name
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["t3.micro", "t3.small", "t3.medium"]

    attach_cluster_primary_security_group = false
  }

  eks_managed_node_groups = {
    ascode-cluster-wg = {
      min_size     = 2
      max_size     = 4
      desired_size = 3

      instance_types = ["t3.micro", "t3.small", "t3.medium"]
      capacity_type  = "ON_DEMAND"

      tags = {
        ExtraTag = "helloworld"
      }
    }
  }

  tags = local.tags
}

# Add JenkinsUser to aws-auth ConfigMap
resource "null_resource" "add_jenkinsuser_to_auth" {
  depends_on = [module.eks]

  provisioner "local-exec" {
    command = <<EOT
    aws eks --region ${local.region} update-kubeconfig --name ${local.name}
    kubectl patch configmap/aws-auth -n kube-system --type merge -p '{"data":{"mapUsers":"- userarn: ${local.jenkins_user_arn}\n  username: jenkinsuser\n  groups:\n    - system:masters\n"}}'
    EOT
  }
}

# Security group rules
resource "aws_security_group_rule" "allow_cluster_to_node" {
  description              = "Allow control plane to communicate with nodes"
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = module.eks.node_security_group_id
  source_security_group_id = module.eks.cluster_security_group_id
}

resource "aws_security_group_rule" "allow_node_to_node" {
  description              = "Allow nodes to communicate with each other"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  security_group_id        = module.eks.node_security_group_id
  source_security_group_id = module.eks.node_security_group_id
}
