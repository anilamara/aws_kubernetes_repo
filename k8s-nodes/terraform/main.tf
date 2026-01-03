terraform {
  backend "s3" {
    bucket         = "anil-terraform-states-ap-south-1"
    key            = "k8s-cluster/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

