# AWS IAM ROLE= AWS IAM ROLE + ASSUME ROLE POLICY ATTACHING TO THIS ROLE(it can be given by datablock also for openid connector) +
#PRINCIPAL(WHO ASSUME )

# ABOVE  CRUX= IAM ROLE CREATION ON CONSOLE ONLY. CONSOLE GIVES ROLE WITH ASSUME ROLE DIRECTLY BUT TERRAFORM ADDED EXTRA 
#STEP TO GIVE ASSUMEROLE POLICY TO ROLE
 
# EXAMPLE--   "Principal": {
#              "Service": "eks.amazonaws.com",                      #  ADDED SERVICE
#               "AWS": "arn:aws:iam::123456789012:user/devops"      #  ADDED IAM USER
#            }
#               "Action": "sts:AssumeRole"                          # THEN THIS IS FIX LINE
# AWS IAM ASSUME ROLE CREATION FOR EKS SERVICE SO EKS CAN GET POLICIES ATTACHED TO THAT ASSUME ROLE.
# WE NOT CREATE 

resource "aws_iam_role" "example" {
  name = "eks-cluster-example"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"        ###### read Q1 below
  role       = aws_iam_role.example.name
}

# Q1---  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"  why need to attach this policy to eks ?
# Cluster Management: The policy grants necessary permissions for EKS to create and manage Kubernetes clusters and associated resources.
# Service Integration: It allows EKS to interact with other AWS services like VPC, IAM, and EC2, essential for cluster operations
