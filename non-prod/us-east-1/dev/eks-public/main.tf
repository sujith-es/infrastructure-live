
# ---------------------------------------------------------------------------------------------------------------------
# MODULE PARAMETERS
# These are the variables we have to pass in to use the module. This defines the parameters that are common across all
# environments.
# ---------------------------------------------------------------------------------------------------------------------
module "eks-public" {

  source = "git@github.com:sujith-es/infrastructure-modules.git//aws-eks-blueprint?ref=v0.0.3"
  # source = "../../../../../infrastructure-modules/aws-eks-blueprint"
   

  aws_region              = "us-east-1"
  cluster_name            =  "aws-blueprint"
  vpc_cidr            =  "10.1.0.0/16"
  eks_cluster_version            =  "1.27"
  cluster_endpoint_public_access            =  true
  resource_tags            =  { 
                              project     = "project-alpha",
                              environment = "dev"
                            }
  instance_types = ["t3a.2xlarge"]
  managed_node_min_size= 3
  managed_node_max_size=6
  managed_node_desired_size = 3


  # TODO: To avoid storing your DB password in the code, set it as the environment variable TF_VAR_master_password
}