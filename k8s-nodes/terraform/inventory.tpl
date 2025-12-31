[control_plane]
${control_ip}

[workers]
%{ for ip in worker_ips ~}
${ip}
%{ endfor }

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/k8s-cluster-key

