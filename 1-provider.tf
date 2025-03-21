 #### aws configure & gave values so we can access aws
provider "aws" {
    region = local.region                        
}

#####below code for version set for provider
terraform {
  required_version = ">= 1.0.0"     # terraform CLI version

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.49"            # terra accept 5.49 and value greater but ~ this symbbol avoids tera to use next MAJOR VERSION  here inthis case its 6.0.(eg. ~>1.2 then it accept 1.2 to 1.9 but not accept 2.0 or afterit)
    }
  }
}





# terraform { required_version = ">= 1.0.0" } block in a Terraform configuration file specifies the version constraints for the Terraform CLI (Command Line Interface) that should be used to run the configuration. 


# Every module can have different versions, just like providers or any other software component. Module versions are managed independently from each other, and they can be updated and versioned according to the module's development lifecycle and release schedule







