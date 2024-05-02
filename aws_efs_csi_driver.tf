module "aws_efs_csi_driver" {
  source                              = "git::https://github.com/mohamedezz96/Terraform-Modules.git//EKS-Tools/AWS-EFS-CSI-Driver?ref=awsefswithdriver"
  aws_efs_csi_driver_version          = "2.5.7"
  eks_issuer                          = data.aws_eks_cluster.eks_data.identity[0].oidc[0].issuer
  values_file                         = "./aws_efs_csi_driver.yaml"
  create_efs                          = true
  cluster_name                        = var.cluster_name
  eks_vpc_id                          = "vpc-0e800103104bc9746"
  eks_worker_node_subnets             = ["subnet-04062694caacec616", "subnet-01ebdb343ec45d1da","subnet-08270493fa020ae2b"]
}
