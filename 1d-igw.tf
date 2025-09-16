resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${local.eks_name}-igw"
  }
}


#Differences Between Managed by EKS and Self-Managed Kubernetes deals on Control Plane Management only:
#Managed by EKS: 
#AWS fully manages the control plane, including components like the API server and etcd,
#ensuring high availability, automatic scaling, and regular updates without user intervention.

#Self-Managed Kubernetes: 
#Users are responsible for setting up, maintaining, and managing the control plane, 
#which includes handling upgrades, scaling, and ensuring high availability.
