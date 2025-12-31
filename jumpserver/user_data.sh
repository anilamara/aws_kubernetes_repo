#!/bin/bash

exec > >(tee /var/log/user-data.log) 2>&1
echo "===== Jump Server Setup Started: $(date) ====="

sleep 30
export DEBIAN_FRONTEND=noninteractive

# Update system
apt-get update || true
apt-get upgrade -y || true

# Base packages
apt-get install -y \
  curl wget git vim nano unzip zip jq tree htop tmux net-tools \
  software-properties-common apt-transport-https ca-certificates \
  gnupg lsb-release build-essential || true

# Python
apt-get install -y python3 python3-pip python3-venv python3-dev || true

# Ansible
apt-get install -y ansible || true

# Terraform
if ! command -v terraform >/dev/null; then
  curl -fsSL https://apt.releases.hashicorp.com/gpg \
    | gpg --dearmor -o /usr/share/keyrings/hashicorp.gpg || true
  echo "deb [signed-by=/usr/share/keyrings/hashicorp.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    > /etc/apt/sources.list.d/hashicorp.list
  apt-get update || true
  apt-get install -y terraform || true
fi

# kubectl
curl -fsSL https://dl.k8s.io/release/stable.txt -o /tmp/k8s_version || true
curl -fsSL https://dl.k8s.io/release/$(cat /tmp/k8s_version)/bin/linux/amd64/kubectl \
  -o /usr/local/bin/kubectl || true
chmod +x /usr/local/bin/kubectl

# Helm
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash || true

# AWS CLI v2
if ! command -v aws >/dev/null; then
  curl -fsSL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip || true
  unzip awscliv2.zip || true
  ./aws/install || true
fi

# Argo CD CLI
curl -fsSL -o /usr/local/bin/argocd \
https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64 || true
chmod +x /usr/local/bin/argocd

# Flux CLI
curl -fsSL https://fluxcd.io/install.sh | bash || true

# k9s
curl -fsSL https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz \
  -o /tmp/k9s.tar.gz || true
tar -xzf /tmp/k9s.tar.gz -C /usr/local/bin || true

# kubectx & kubens
git clone https://github.com/ahmetb/kubectx /opt/kubectx || true
ln -sf /opt/kubectx/kubectx /usr/local/bin/kubectx
ln -sf /opt/kubectx/kubens /usr/local/bin/kubens

# stern (pinned version – reliable)
echo "[stern] Installing stern..."
curl -L https://github.com/stern/stern/releases/download/v1.28.0/stern_1.28.0_linux_amd64.tar.gz \
  -o /tmp/stern.tar.gz || true
cd /tmp || exit 0
tar -xzf stern.tar.gz || true
mv stern /usr/local/bin/ || true
chmod +x /usr/local/bin/stern || true

# GitHub Actions Runner (binary only, registration later)
echo "[GitHub Runner] Installing runner..."
mkdir -p /opt/actions-runner
cd /opt/actions-runner || exit 0
curl -L https://github.com/actions/runner/releases/download/v2.322.0/actions-runner-linux-x64-2.322.0.tar.gz \
  -o runner.tar.gz || true
tar xzf runner.tar.gz || true
chown -R ubuntu:ubuntu /opt/actions-runner || true

# Workspace
mkdir -p /home/ubuntu/workspace/{ansible,terraform,k8s-manifests,scripts}
chown -R ubuntu:ubuntu /home/ubuntu/workspace

# SSH key for K8s nodes
sudo -u ubuntu ssh-keygen -t ed25519 \
  -f /home/ubuntu/.ssh/k8s-cluster-key -N "" || true

touch /var/log/user-data-complete
echo "===== Jump Server Setup Finished: $(date) ====="

