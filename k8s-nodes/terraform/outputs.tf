output "control_plane_ip" {
  value = aws_instance.control_plane.private_ip
}

output "worker_ips" {
  value = aws_instance.workers[*].private_ip
}

output "ansible_inventory" {
  value = templatefile("${path.module}/inventory.tpl", {
    control_ip = aws_instance.control_plane.private_ip
    worker_ips = aws_instance.workers[*].private_ip
  })
}

