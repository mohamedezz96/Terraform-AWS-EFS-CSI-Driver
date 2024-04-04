data "aws_eks_cluster" "eks_data" {
  name = var.cluster_name
}
