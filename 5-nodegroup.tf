resource "aws_eks_node_group" "example" {
  cluster_name    = "${local.env}-${local.eks_name}"     
  node_group_name = "example"
  node_role_arn   = aws_iam_role.example-1.arn
  subnet_ids      = [aws_subnet.pvt-1a.id, aws_subnet.pvt-1a.id]   

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

capacity_type = "ON_DEMAND"
instance_types = ["t2.micro"]
labels = {
    role = "general"
}        

lifecycle {
  ignore_changes = [ scaling_config[0].desired_size ]
}
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
  ]
}










# resource "aws_eks_node_group" "example" {
#   cluster_name    = "${local.env}-${local.eks_name}"                # add this urself . So give  name 
#   node_group_name = "example"
#   node_role_arn   = aws_iam_role.example.arn
#   subnet_ids      = aws_subnet.example[*].id                        # add this urself. so give in ARRAY, MEAN [] GIVE SUBNET IN SQUARE BLOCK. u may use single zone to reduce cost also but there is small chance of failure

#   scaling_config {                                               # this will create auto scaling group suddenly after cluster ready- before we crate autoscaler but ASG start working after autoscaler added.
#     desired_size = 1                                       # desired size property in ASG updated on aws by eks autoscaler
#     max_size     = 2                                      # until autoscaler added on eks this wont work
#     min_size     = 1
#   }

#   update_config {
#     max_unavailable = 1                      ##### Ensures a safe rolling update of EKS node group by limiting number of nodes that taken offline simultaneously to one.
#   }
# capacity_type = "ON_DEMAND"                # add this urself
# instance_types = "t2.micro"                # add this urself
# labels = {                                 # add this urself. we can use them on pod affinity and node selectors
#     role = "general"
# }  
 
# lifecycle {                                               # add this urself. so when scaling happen due to auto-scaler terraform apply command not reverse back scaling to original desired size.            
#   ignore_changes = [ scaling_config[0].desired_size ]
# }
#   # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
#   # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
#   depends_on = [
#     aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
#   ]
# }




#DIFFERENCE IN AWS Managed Node Group & Self-Managed Node Group

#1
# AWS Managed Node Group: Automatically handles scaling and integrates with AWS EKS control plane.
# Self-Managed Node Group: Requires manual scaling and uses AWS Auto Scaling groups with separate configuration.

#2
# AWS Managed Node Group: Automatically updates nodes with EKS version upgrades.
# Self-Managed Node Group: Requires manual updates for nodes and Kubernetes version upgrades.

#3
#AWS Managed Node Group= what we created in this code
#resource "aws_eks_node_group" "managed" {}
#Self-Managed Node Group
#resource "aws_autoscaling_group" "self_managed" {}
