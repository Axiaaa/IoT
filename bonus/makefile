all : setup 

setup : 
	./scripts/setup.sh

clean : 
	k3d cluster delete --all
	docker system prune -f --volumes
	rm -rf .git token IoT-p3-lcamerly deployement.yaml service.yaml ingress.yaml

re : clean all
