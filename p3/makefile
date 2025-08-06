ARGO_HOST = argocd.awesome.local
APP_HOST = playground.local
TEMPLATE_DIR = template
OUTPUT_DIR = conf

all :
	./script/script.sh

clean : 
	k3d cluster delete argocluster

re : clean all

clone : 
	git clone	https://github.com/Axiaaa/IoT-p3-lcamerly
