resource "aws_key_pair" "k8s_cluster" {
  key_name   = "k8s-cluster-key"
  public_key = file("/home/ubuntu/.ssh/k8s-cluster-key.pub")

  tags = {
    Name    = "k8s-cluster-key"
    Project = var.project_name
  }
}

