resource "local_file" "ansible_inventory" {
  filename = "${path.root}/../../ansible/inventory/hosts.ini"
  content  = templatefile("${path.module}/inventory.tpl", {
    control_ip = aws_instance.control_plane.private_ip
    worker_ips = aws_instance.workers[*].private_ip
  })
}

