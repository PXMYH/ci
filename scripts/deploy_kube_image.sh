#!/usr/bin/env bash

# connect to host
echo "$HOST_PRIVATE_KEY" > host_priv.pem
chmod 400 host_priv.pem

cat << EOF > install_kube.sh
  sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add 
  deb http://apt.kubernetes.io/ kubernetes-xenial main 

  apt-get update -y
  apt-get install -y kubelet kubeadm kubectl kubernetes-cni
EOF

chmod +x install_kube.sh

echo "install_kube.sh content:"
cat install_kube.sh

scp -o "StrictHostKeyChecking no" -o "UserKnownHostsFile /dev/null" -i host_priv.pem install_kube.sh ubuntu@$HOST_IP:~
ssh -o "StrictHostKeyChecking no" -o "UserKnownHostsFile /dev/null" -i host_priv.pem ubuntu@$HOST_IP 'bash -s' < install_kube.sh