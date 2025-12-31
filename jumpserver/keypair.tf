resource "aws_key_pair" "jump" {
  key_name   = "jumpserver-key"
  public_key = file("${path.module}/keys/jumpserver.pub")
}

