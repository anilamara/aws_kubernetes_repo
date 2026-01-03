resource "local_file" "ansible_inventory" {
  filename = "/home/ubuntu/aws_kubernetes_repo/ansible/inventory/hosts.ini"

  content = templatefile("${path.module}/inventory.tpl", {
    control_ip = aws_instance.control_plane.private_ip
    worker_ips = aws_instance.workers[*].private_ip
  })

  depends_on = [
    aws_instance.control_plane,
    aws_instance.workers
  ]
}

