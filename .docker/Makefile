#!/usr/bin/make

docker_bin := $(shell command -v docker 2> /dev/null)
image_name := dummy
local_android_root := $(word 2, $(MAKECMDGOALS))

# Please run the following command prior to using this makefile
# sudo apt install docker.io
# sudo usermod -aG docker $USER
# reboot
ifeq ($(docker_bin),)
$(error please install docker)
endif

.PHONY : build clean help run stop shell
.DEFAULT_GOAL := help

help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Build Docker image Usage: $ make build
	$(docker_bin) build -t local/build-env -f ./Dockerfile .;

run: ## Start container. In other case you need to run command manually! Usage: $ make run "local_android_root"
	$(docker_bin) run -itd --name $(image_name) --network="host" -v $(local_android_root):/home/user/aosp local/build-env

stop: ## Stop and remove container. Usage: $ make stop
	$(docker_bin) ps -a | awk -F "\t" '{ print $$1,$$7 }' | grep "$(image_name)" | awk '{print $$1 }' | xargs -I {} $(docker_bin) stop {}

shell: ## Start shell into dummy container. Usage: $ make shell
	$(docker_bin) exec -it $(image_name) bash

clean: ## Remove images from local registry. Usage: $ make clean
	$(docker_bin) ps -a | awk -F "\t" '{ print $$1,$$7 }' | grep "$(image_name)" | awk '{print $$1 }' | xargs -I {} $(docker_bin) rm -f {} ; \

build_all: ## Build all targets within a container (for CI purposes)
	make clean
	make build
	make run `cd ../../.. && pwd`
	$(docker_bin) exec -it $(image_name) bash -c "cd .repo/manifests/.ci && make build_all"
