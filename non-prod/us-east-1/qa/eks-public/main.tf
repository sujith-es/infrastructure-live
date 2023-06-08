provider "aws" {
  region = local.aws_region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.1"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.21"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10"
    }
  }

  # # Variables cannot not be used here. Hence hardcoded the values
  # backend "s3" {
  #   bucket         = "pace-tr-terraform-state-dont-delete"
  #   key            = "pace-devops/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "pace-tr-terraform-locks-dont-delete"
  #   encrypt        = true
  # }

  required_version = "~> 1.4"
}

locals {
  aws_region = "us-east-2"
  aws_eks_cluster_name = "qa-eks-use2-pace"
}

# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module.
# ---------------------------------------------------------------------------------------------------------------------
module "eks-public" {

   source = "git@github.com:sujith-es/infrastructure-modules.git//aws-eks-blueprint?ref=v1.0.0"
  # source = "../../../../../infrastructure-modules/aws-eks-blueprint"


  aws_region                     = local.aws_region
  cluster_name                   = local.aws_eks_cluster_name
  vpc_cidr                       = "10.1.0.0/16"
  eks_cluster_version            = "1.27"
  cluster_endpoint_public_access = true
  resource_tags = {
    project     = "project-alpha",
    environment = "qa"
  }
  instance_types            = ["t3a.2xlarge"]
  managed_node_min_size     = 3
  managed_node_max_size     = 6
  managed_node_desired_size = 3


  # AWS EKS Blueprint Add-ons. aws_ebs_csi_driver, aws_load_balancer_controller
  enable_argocd = true
  enable_karpenter = true
  enable_argo_rollouts = true

  # **** BELOW are enabled by Default. DO NOT CHANGE ******
  # enable_amazon_eks_aws_ebs_csi_driver = true
  # enable_aws_load_balancer_controller  = true
  # enable_cert_manager                  = true  
  # enable_metrics_server                = true  

  # Admin Team and Users to add to admin IAM group and in K8s aws-auth
  admin_team_name = "pace-eks-admin-team"
  admin_team_users_arn = ["arn:aws:sts::860602188711:assumed-role/AWSReservedSSO_AdministratorAccess_cba8f873db8c16f0/ust-sujith-surendran",
    "arn:aws:sts::860602188711:assumed-role/AWSReservedSSO_AdministratorAccess_cba8f873db8c16f0/ust-divya-mathew"
  ]

}
