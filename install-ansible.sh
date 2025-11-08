#!/bin/bash
set -e

echo "=== Updating system packages ==="
sudo apt update -y
sudo apt upgrade -y

echo "=== Installing dependencies ==="
sudo apt install -y software-properties-common ca-certificates curl git

echo "=== Adding Ansible official PPA ==="
sudo add-apt-repository --yes --update ppa:ansible/ansible

echo "=== Installing Ansible (latest stable version) ==="
sudo apt install -y ansible

echo "=== Verifying Ansible installation ==="
ansible --version

echo "=== Installation complete! ==="
echo "You can now run your Ansible playbooks."
