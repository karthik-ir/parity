.Phony: idocker

PARITY_BRANCH_NAME=master
RUST_VERSION=stable
RESULT_FILE_PATH=/var/lib/docker/volumes/parity/_data/file
FILE_TIMESTAMP=$(shell date +"%s")
DROPBOX_KEY=NOTOKEN
define install-docker
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
	add-apt-repository "deb https://download.docker.com/linux/ubuntu $$(lsb_release -cs) stable"
	apt-get update
	apt-cache policy docker-ce
	dpkg -s docker-ce || apt-get install -y docker-ce
endef

define upload-file
	test ! -f $(RESULE_FILE_PATH) || curl -X POST https://content.dropboxapi.com/2/files/upload \
    --header "Authorization: Bearer $(DROPBOX_KEY)" \
    --header "Dropbox-API-Arg: {\"path\": \"$(RESULT_FILE_PATH)_$(FILE_TIMESTAMP)\"}" \
    --header "Content-Type: application/octet-stream" \
    --data-binary @$(RESULT_FILE_PATH)
endef

deploy-docker: 
	which docker || $(call install-docker) 
	rm -rf ./parity 
	git clone -b $(PARITY_BRANCH_NAME) --single-branch https://github.com/paritytech/parity
	docker build --build-arg rust_version=$(RUST_VERSION) -t parity_compile .
	docker run -v $$(pwd)/parity:/root/parity parity_compile
	echo "NEW CONTENTS" > $(RESULT_FILE_PATH)
	$(call upload-file)
	echo "File uploaded in Dropbox in path "$(RESULT_FILE_PATH)_$(FILE_TIMESTAMP)
idocker: deploy-docker
