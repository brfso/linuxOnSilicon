# Kubernetes Learning Environment on Apple Silicon (M1/M2)

This project prepares an ARM64 Linux virtual machine using QEMU and Vagrant on macOS (M1/M2). It automatically installs Kubernetes and deploys NGINX pods, providing a lightweight learning environment to explore and practice Kubernetes concepts.

---

## 🧰 Prerequisites

- Apple Silicon Mac (M1 or M2)
- macOS 12.6.3 or higher
- [Homebrew](https://brew.sh/)
- Git

---

## 🚀 Getting Started

Follow these steps to get your Kubernetes environment up and running:

### 1. Clone or Fork the Repository

```bash
git clone https://github.com/brfso/linuxOnSilicon.git
cd linuxOnSilicon

### 2.  Run the Bootstrap Script
This will install QEMU, Vagrant, and the necessary Vagrant plugin:


```bash
./bootstrap.sh

### 3. Start the Virtual Machine
This will initialize the ARM64 Linux environment, configure Kubernetes, and deploy NGINX pods.
```bash
vagrant up

### 4. Access the Linux VM
```bash
vagrant ssh

Once inside, Kubernetes is ready for use!

---
## 📚 Useful Kubernetes Commands

| Task                          | Command                                                                 |
|-------------------------------|-------------------------------------------------------------------------|
| List NGINX pods               | `kubectl get pods -l app=nginx`                                        |
| Access a specific container   | `kubectl exec --stdin --tty <pod-name> -- /bin/bash`                   |
| View logs of a container      | `kubectl logs <pod-name>`                                              |
| Get pod IPs                   | `kubectl get pods -o wide`                                             |
| Generate 404 on NGINX         | `curl http://<pod-ip>/XPTO`                                            |





