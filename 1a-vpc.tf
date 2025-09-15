resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"           # it should not clash with other vpc
  enable_dns_support   = true                    # EFS CSI DRIVER NEEDS IT
  enable_dns_hostnames = true
}


#The VPC must have DNS hostname and DNS resolution support. Otherwise, nodes can't register to your cluster.-this is from aws website,
below gpt and antonputr info
#If DNS hostname and DNS resolution are not enabled in the VPC, nodes will not be able to register to the cluster.-gpt
# With enable_dns_support = true, the web server can resolve domain names to IP addresses,
allowing it to access other services and the internet.
# With enable_dns_hostnames = true, the web server is assigned a public DNS hostname (e.g., ec2-203-0-113-25.compute-1.amazonaws.com),
which you can use to access the server from your browser or other services.
#   cidr_block           = "10.0.0.0/16"           # it should not clash with other vpc
# /16 = 65000 ip              /19= 8000 ip aprox



# if eks not there we have to manage controlplane using kops

