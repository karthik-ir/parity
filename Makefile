.Phony: idocker

PARITY_BRANCH_NAME=master
define install-docker
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
	add-apt-repository "deb https://download.docker.com/linux/ubuntu $$(lsb_release -cs) stable"
	apt-get update
	apt-cache policy docker-ce
	dpkg -s docker-ce || apt-get install -y docker-ce
endef

deploy-docker: 
	which docker || $(call install-docker) 
	git clone -b $(PARITY_BRANCH_NAME) --single-branch https://github.com/paritytech/parity
	docker build --build-arg rust_version=stable -t parity_compile .
	docker run parity_compile

idocker: deploy-docker

# apt-get install git
#systemctl status docker || echo "ERROR: Docker not started"
