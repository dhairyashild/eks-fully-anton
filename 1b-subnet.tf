resource "aws_subnet" "pub-1a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
availability_zone = local.az1             # I add
map_public_ip_on_launch = true            # I add - and  in a subnet, the map_public_ip_on_launch attribute is used to control whether
                                          # newly launched instances in that subnet should be assigned a public IP address by default.


  tags = {
   "kubernetes.io/role/elb"	= "1"    # I add  ===This tag is used by the ALBC to automatically discover which subnets can be utilized 
                                     # for creating ELB. If tags are not present, you encounter errors-"could not find any suitable
                                     # subnets for creating the ELB" 
      
   Name = "${local.eks_name}-public-sub-1a"         # I add

   "kubernetes.io/cluster/${local.eks_name}"=	"shared" # tag indicates that resources (like security groups and subnets) are owned 
                                                      # by specified Kubernetes cluster.

                                                      #  Use "owned" when the subnet is dedicated to a single EKS cluster.
                                                       # Use "shared" when the subnet is used by multiple EKS clusters or other resources.

  }
}

resource "aws_subnet" "pvt-1a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
availability_zone = local.az1                  
  tags = {
   "kubernetes.io/role/internal-elb"	= "1"  # tag allows the ALBC to automatically discover which subnets can be used for creating 
                      #internal load balancers (e.g., Network Load Balancers or Application Load Balancers with an internal scheme).

      Name = "${local.eks_name}-pvt-sub-1a"           # When you create a Kubernetes service of type LoadBalancer with the appropriate
                                      # annotations, the AWS Load Balancer Controller automatically provisions an internal load balancer.

   "kubernetes.io/cluster/${local.eks_name}"=	"shared"  # However, it relies on the kubernetes.io/role/internal-elb tag to determine 
            # which subnets are suitable for the internal load balancer.It ensures that only resources belonging to cluster are considered
            # for operations like scaling and load balancing, which helps maintain a clean and efficient infrastructure setup.

  }
}










kubernetes.io/cluster/<my-cluster>: shared or owned) to link AWS resources (like security groups and subnets) to a specific EKS cluster.

Identifies Cluster Ownership: It tells EKS and  AWS Load Balancer Controller which resources belong to particular EKS cluster.
shared value: Means the resource (subnet or security group) can be used by multiple EKS clusters in the same VPC.
owned value: Means the resource is exclusively managed and used by a single EKS cluster.
Security Groups: If many SG attached to node-groups then Exactly 1 security group attached to worker nodes must have this tag.

Subnets: Tagging subnets with this is optional for newer AWS Load Balancer Controller versions (2.1.2+), 
but recommended if you have multiple clusters in the same VPC, share subnets with other AWS services, or want precise control over load balancer provisioning.




# kubernetes.io/cluster/my-cluster=shared  =  This tag enables multiple EKS clusters to use the same subnets,
#allowing for efficient resource sharing and management across different clusters within the same VPC.

# The annotation kubernetes.io/role/internal-elb: "1"  = designates a node for internal ELB use in a Kubernetes cluster,
#facilitating efficient traffic distribution within the cluster's private network for enhanced communication between services.

# in a subnet, the map_public_ip_on_launch = attribute is used to control whether newly launched instances in that subnet 
#should be assigned a public IP address by default.






The rule is different for Security Groups vs. Subnets.

For Subnets: Use shared. 
owned ===  not used in prod for sub

Subnets are foundational infrastructure shared by many services (EKS, RDS, etc.). 
You don't want a cluster deletion to impact your entire network.
For new clusters,this tag is not required by EKS.It only needed for legacy tooling/very specific advanced use cases.You can often omit it.


For Security Groups: Use owned. 
The cluster-specific node security group is not shared infrastructure. 
It is created for and dedicated to a single cluster. 
Its lifecycle should be tied to the cluster it belongs to for clean-up and security isolation.

# Create a security group for EKS worker nodes
resource "aws_security_group" "eks_nodes" {
  name_prefix = "eks-nodes-" # Creates a unique name (e.g., eks-nodes-sg123abc)
  vpc_id      = aws_vpc.eks_vpc.id

  # This SG must allow inbound communication from the EKS control plane
  # on the port used for node registration and health checks.
  # The EKS service will automatically create rules in this SG.
  # We only define the initial setup here.

  tags = {
    # This is the CRITICAL tag that identifies this SG as managed by the cluster
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"                                #####################

    # Optional: Name tag for human identification
    Name = "${var.cluster_name}-node-sg"
  }

  # It's good practice to let Terraform know this SG might have rules managed

