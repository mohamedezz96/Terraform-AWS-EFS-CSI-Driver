module "aws_efs_csi_driver" {
  source                              = "github.com/mohamedezz96/Terraform-Modules/EKS-Tools/AWS-EFS-CSI-Driver"
  aws_efs_csi_driver_version          = "2.5.7"
  eks_issuer                          = data.aws_eks_cluster.eks_data.identity[0].oidc[0].issuer
  aws_efs_controller_sa_name          = "aws-efs-controller-sa"
  aws_efs_node_sa_name                = "aws-efs-node-sa"
  aws_efs_csi_driver_role_name        = "aws-efs-csi-driver-role"
  values_file                         = "./values/aws_efs_csi_driver.yaml"
}
