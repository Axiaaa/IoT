# Inception of Things (IoT) - Kubernetes & GitOps Project

![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![Vagrant](https://img.shields.io/badge/vagrant-%231563FF.svg?style=for-the-badge&logo=vagrant&logoColor=white)
![ArgoCD](https://img.shields.io/badge/argo-%23EF7B4D.svg?style=for-the-badge&logo=argo&logoColor=white)
![GitLab](https://img.shields.io/badge/gitlab-%23181717.svg?style=for-the-badge&logo=gitlab&logoColor=white)

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Installation](#installation)
- [Part 1 - K3s and Vagrant](#part-1---k3s-and-vagrant)
- [Part 2 - K3s and Ingress](#part-2---k3s-and-ingress)
- [Part 3 - K3d and ArgoCD](#part-3---k3d-and-argocd)
- [Bonus Part - GitLab CI/CD](#bonus-part---gitlab-cicd)
- [Contributing](#contributing)

## 🎯 Overview

The **Inception of Things (IoT)** project is an in-depth learning project covering Kubernetes, containerization technologies, and GitOps practices. It consists of four progressive parts that cover:

1. **K3s Infrastructure**: Kubernetes cluster deployment with Vagrant
2. **Traffic Management**: Ingress Controller configuration with multiple applications  
3. **GitOps with ArgoCD**: Automated continuous deployment
4. **CI/CD Pipeline**: Complete GitLab + ArgoCD + K3d integration

## 🛠️ Prerequisites

### Required Tools

- **VirtualBox** 7.0+
- **Vagrant** 2.0+
- **Docker** 20.0+
- **kubectl** 1.28+
- **k3d** 5.0+
- **ArgoCD CLI** 2.0+
- **Helm** 3.0+
- **Git** 2.0+

### Automated Installation

Run the installation script to set up all necessary tools:

```bash
chmod +x install.sh
./install.sh
```

### System Requirements

- **RAM**: 8GB minimum (12GB recommended)
- **Disk Space**: 20GB available
- **OS**: Linux (Debian/Ubuntu recommended)
- **Network**: Stable Internet connection

## 📁 Project Structure

```
inception-of-things/
├── install.sh                 # Tools installation script
├── README.md                  # This file
├── p1/                        # Part 1: K3s + Vagrant
│   ├── Makefile
│   ├── Vagrantfile
│   └── scripts/
│       ├── server.sh
│       └── worker.sh
├── p2/                        # Part 2: Ingress Controller
│   ├── Makefile
│   ├── Vagrantfile
│   ├── confs/
│   │   ├── httpd.yaml
│   │   ├── nginx.yaml
│   │   ├── helloworld.yaml
│   │   └── ingress.yaml
│   └── scripts/
│       └── server.sh
├── p3/                        # Part 3: ArgoCD
│   ├── makefile
│   ├── confs/
│   │   ├── k3d.yaml
│   │   ├── configmap.yaml
│   │   └── ingress.yaml
│   └── scripts/
│       └── script.sh
└── bonus/                     # Bonus Part: CI/CD Pipeline
    ├── makefile
    ├── confs/
    │   ├── k3d.yaml
    │   ├── gitlab.yaml
    │   ├── gitlab-ingress.yaml
    │   ├── argo-ingress.yaml
    │   └── configmap.yaml
    └── scripts/
        ├── setup.sh
        └── generatetoken.rb
```

## 🚀 Installation

1. **Clone the project**
   ```bash
   git clone https://github.com/Axiaaa/IoT/
   cd inception-of-things
   ```

2. **Install dependencies**
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

3. **Add your user to Docker group**
   ```bash
   sudo usermod -aG docker $USER
   newgrp docker
   ```

## 📦 Part 1 - K3s and Vagrant

### Objective
Create a K3s cluster with one server and one worker using Vagrant.

### Architecture
- **lcamerlyS** (Server): 192.168.56.110 - 2GB RAM, 2 CPU
- **lcamerlySW** (Worker): 192.168.56.111 - 2GB RAM, 2 CPU

### Deployment

```bash
cd p1
make all          # Create VMs and cluster
make clean        # Destroy VMs
make fclean       # Complete cleanup
```

### Verification

```bash
# On the server VM
vagrant ssh lcamerlyS
sudo kubectl get nodes -o wide
```

**Expected output:**
```
NAME        STATUS   ROLES                  AGE   VERSION
lcamerlyS   Ready    control-plane,master   1m    v1.28.7+k3s1
lcamerlyS   Ready    <none>                 1m    v1.28.7+k3s1
```

## 🌐 Part 2 - K3s and Ingress

### Objective
Configure a Traefik Ingress Controller to route traffic to different applications.

### Deployed Applications
- **App1** (httpd): Accessible via `app1.com`
- **App2** (nginx): Accessible via `app2.com` - 3 replicas
- **App3** (hello-kubernetes): Accessible via `app3.com` + default route

### Deployment

```bash
cd p2
make all          # Create VM and deploy apps
```

### Testing Applications

```bash
# Test each application
make app1         # curl -H "Host:app1.com" 192.168.56.110
make app2         # curl -H "Host:app2.com" 192.168.56.110  
make app3         # curl -H "Host:app3.com" 192.168.56.110
make default      # curl 192.168.56.110 (default route)
```

### Network Configuration

Applications are also accessible via:
- http://localhost:8080 (forwarded port)
- http://localhost:8443 (HTTPS forwarded port)

## ⚙️ Part 3 - K3d and ArgoCD

### Objective
Deploy ArgoCD in a K3d cluster and configure automatic application deployment.

### Architecture
- **K3d Cluster**: 1 server + 2 agents
- **ArgoCD**: Continuous deployment web interface
- **Application**: Auto-deployed from GitHub repository

### Deployment

```bash
cd p3
make all          # Create cluster and deploy ArgoCD
make clean        # Delete cluster
```

### Service Access

- **ArgoCD UI**: http://argocd.awesome.local
  - Username: `admin`
  - Password: Displayed in script logs
  
- **Application**: http://playground.local

### Features
- ✅ Automatic synchronization from GitHub
- ✅ Accessible ArgoCD web interface
- ✅ Deployment to `dev` namespace
- ✅ Ingress configuration with Traefik

## 🎯 Bonus Part - GitLab CI/CD

### Objective
Complete CI/CD pipeline with GitLab, ArgoCD and K3d for advanced GitOps workflow.

### Complete Architecture
```
┌─────────────┐      ┌─────────────┐    ┌─────────────┐     ┌─────────────┐
│   GitLab    │────▶│     K3d     │───▶│   ArgoCD    │───▶│ Application │
│   (SCM)     │      │ (Runtime)   │    │  (GitOps)   │     │   (App)     │
└─────────────┘      └─────────────┘    └─────────────┘     └─────────────┘
```

### Deployed Services
- **GitLab**: http://gitlab.concombre.toboggan
- **ArgoCD**: http://argocd.awesome.local  
- **Application**: http://playground.local

### Deployment

```bash
cd bonus
make all          # Complete deployment (~15-20 minutes)
make clean        # Cleanup
```

### GitOps Workflow

1. **Code Push** → GitLab detects changes
2. **GitLab** → Provides source repository
3. **ArgoCD** → Automatically syncs manifests
4. **K3d Cluster** → Deploys updated application

### Advanced Features

- ✅ **Integrated GitLab** with automatic authentication
- ✅ **Automatic token generation**
- ✅ **Bidirectional GitOps synchronization**
- ✅ **Multi-service Ingress** with Traefik
- ✅ **Visual monitoring** via ArgoCD UI
- ✅ **Zero-downtime deployment**

### Access Credentials

Credentials are displayed at the end of deployment:

```bash
# GitLab
Username: root
Password: <automatically generated>

# ArgoCD  
Username: admin
Password: <automatically generated>
```

## 📚 Useful Resources

### Official Documentation
- [K3s Documentation](https://docs.k3s.io/)
- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [GitLab Documentation](https://docs.gitlab.com/)

### Key Concepts
- **GitOps**: Deployment practice using Git as source of truth
- **Ingress Controller**: HTTP/HTTPS ingress traffic management
- **Service Mesh**: Secure inter-service communication
- **CI/CD Pipeline**: Continuous integration and deployment

## 🤝 Contributing

1. Fork the project
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is developed for educational purposes. See `LICENSE` for more details.

---
