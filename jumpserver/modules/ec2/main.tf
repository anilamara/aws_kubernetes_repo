resource "aws_instance" "this" {
  ami                    = "ami-03f4878755434977f"
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name

  user_data_base64 = filebase64("${path.module}/../../user_data.sh")

  tags = {
    Name = "jumpserver"
  }
}

