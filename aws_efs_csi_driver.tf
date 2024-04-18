module "aws_efs_csi_driver" {
  source                              = "github.com/mohamedezz96/Terraform-Modules/EKS-Tools/AWS-EFS-CSI-Driver"
  aws_efs_csi_driver_version          = "2.5.7"
  eks_issuer                          = data.aws_eks_cluster.eks_data.identity[0].oidc[0].issuer
  values_file                         = "./aws_efs_csi_driver.yaml"
}
