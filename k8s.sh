#!/bin/bash
# Script to configure ntp and timezone for brasil
# Fernando Oliveira
# Created at: 2025-05-20

#
# Source: https://facsiaginsa.com/kubernetes/install-kubernetes-single-node
#
echo "*****************************************"
echo " Starting script: ${0}"
echo " Confgure Kubernets with Containerd"
echo " Executing commands in: ${HOME}\n"
echo "*****************************************"
sudo su modprobe overlay
sudo su modprobe br_netfilter
sudo lsmod | egrep 'br_netfilter|overlay'

sudo cat > /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

sudo apt update > /dev/null 2>&1
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates > /dev/null 2>&1

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt update > /dev/null 2>&1
sudo apt install docker containerd -y > /dev/null 2>&1

sudo mkdir /etc/containerd/
containerd config default > /etc/containerd/config.toml

sudo sed -i -e's/SystemdCgroup = false/SystemdCgroup = true/g' /etc/containerd/config.toml

sudo systemctl stop containerd
sudo systemctl daemon-reload
sudo systemctl start containerd
sudo systemctl enable containerd

sudo apt -y install curl vim git wget apt-transport-https gpg > /dev/null 2>&1

sudo mkdir -m 755 /etc/apt/keyrings
sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt update > /dev/null 2>&1
sudo apt -y install kubelet=1.31.2-1.1 kubeadm=1.31.2-1.1 kubectl=1.31.2-1.1 > /dev/null 2>&1
#sudo apt -y install kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

sudo kubectl version --client && sudo kubeadm version

sudo systemctl enable kubelet

sudo echo "127.0.0.1 k8s-endpoint" >> /etc/hosts

sudo kubeadm config images pull
sudo kubeadm init --pod-network-cidr=10.1.0.0/16 --control-plane-endpoint k8s-endpoint:6443


mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/config


sudo kubeadm join k8s-endpoint:6443 --token 7sibm4.kcawyjy2sakmpgjv \
        --discovery-token-ca-cert-hash sha256:c8ec1014a80209ba540c16451135b920b8ee82d717ae8df16d88b81564a321dc \
        --control-plane --ignore-preflight-errors=all


sudo kubeadm join k8s-endpoint:6443 --token 7sibm4.kcawyjy2sakmpgjv \
        --discovery-token-ca-cert-hash sha256:c8ec1014a80209ba540c16451135b920b8ee82d717ae8df16d88b81564a321dc --ignore-preflight-errors=all

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.4/manifests/tigera-operator.yaml
wget https://raw.githubusercontent.com/projectcalico/calico/v3.26.4/manifests/custom-resources.yaml

sed -i -e's/192.168.0.0/10.1.0.0/g' custom-resources.yaml
kubectl apply -f custom-resources.yaml
kubectl taint nodes $(hostname) node-role.kubernetes.io/control-plane:NoSchedule-
kubectl get nodes
kubectl get pod --all-namespaces
