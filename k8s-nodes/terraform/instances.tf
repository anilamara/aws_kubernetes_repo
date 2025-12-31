data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "control_plane" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = aws_key_pair.k8s_cluster.key_name


  vpc_security_group_ids = [aws_security_group.k8s_nodes.id]

  tags = {
    Name = "k8s-control-plane"
    Role = "control-plane"
  }
}

resource "aws_instance" "workers" {
  count         = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = aws_key_pair.k8s_cluster.key_name

  vpc_security_group_ids = [aws_security_group.k8s_nodes.id]

  tags = {
    Name = "k8s-worker-${count.index + 1}"
    Role = "worker"
  }
}

