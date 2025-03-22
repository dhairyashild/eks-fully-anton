####        https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate



data "tls_certificate" "example" {
  url = aws_eks_cluster.example.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "example" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.example.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.example.identity[0].oidc[0].issuer
}


# data "tls_certificate" "example" {                              #### Fetches the TLS certificate from the OpenID Connect (OIDC) issuer URL of your Amazon EKS cluster.
#   url = aws_eks_cluster.example.identity[0].oidc[0].issuer    #### This process ensures that only requests from trusted OIDC provider can assume IAM roles & access AWS resources securely.
# }                                                             #### give ur cluster block name in above line


# resource "aws_iam_openid_connect_provider" "example" {
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = [data.tls_certificate.example.certificates[0].sha1_fingerprint]
#   url             = aws_eks_cluster.example.identity[0].oidc[0].issuer
# }
