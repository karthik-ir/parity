.Phony: idocker

PARITY_BRANCH_NAME=master
RUST_VERSION=stable
define install-docker
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
	add-apt-repository "deb https://download.docker.com/linux/ubuntu $$(lsb_release -cs) stable"
	apt-get update
	apt-cache policy docker-ce
	dpkg -s docker-ce || apt-get install -y docker-ce
endef

deploy-docker: 
	which docker || $(call install-docker) 
	rm -rf ./parity 
	git clone -b $(PARITY_BRANCH_NAME) --single-branch https://github.com/paritytech/parity
	docker build --build-arg rust_version=$(RUST_VERSION) -t parity_compile .
	docker run -d -v $$(pwd)parity:/root/parity parity_compile
idocker: deploy-docker
