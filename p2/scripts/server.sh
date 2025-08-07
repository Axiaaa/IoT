#Install curl 
set -e
apt-get update && apt-get install curl -y

# K3s Configuration
export INSTALL_K3S_VERSION="v1.28.7+k3s1"
export K3S_KUBECONFIG_MODE="644"
export INSTALL_K3S_EXEC="--flannel-iface=eth1"

#Install K3s server
curl -sfL https://get.k3s.io | sh -

# wait for node to be ready
until kubectl get nodes | grep -q " Ready"; do
    echo "Waiting for node to be ready..."
    sleep 2
done

kubectl apply -f /vagrant/confs/nginx.yaml
kubectl apply -f /vagrant/confs/httpd.yaml
kubectl apply -f /vagrant/confs/helloworld.yaml
kubectl apply -f /vagrant/confs/ingress.yaml

echo "Waiting for the app to be available"
until curl -s 192.168.56.110 >/dev/null 2>&1;
do 
    sleep 2
done

echo "The app is ready! Use makefile (make app1, app2, app3 and default) outstide of the Vagrant VM to test it!"