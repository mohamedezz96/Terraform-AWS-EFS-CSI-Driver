module "aws_efs_csi_driver" {
  source                              = "github.com/mohamedezz96/Terraform-Modules/EKS-Tools/AWS-EFS-CSI-Driver?ref=aws-efs-with-driver"
  aws_efs_csi_driver_version          = "2.5.7"
  eks_issuer                          = data.aws_eks_cluster.eks_data.identity[0].oidc[0].issuer
  values_file                         = "./aws_efs_csi_driver.yaml"
  create_efs                          = true
  cluster_name                        = var.cluster_name
  eks_vpc_id                          = "vpc-0a1b2c3d4e5f6g7h8"
  eks_worker_node_subnets             = ["subnet-0a1b2c3d4e5f6g7h8", "subnet-0a1b2c3d4e5f6g7h9"]
}
