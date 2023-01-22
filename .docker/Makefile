#!/usr/bin/make

DOCKERFILE := Dockerfile
DOCKER_BIN := $(shell command -v docker 2> /dev/null)
IMAGE_NAME := glodroid_ci
LOCAL_AOSP_ROOT := $(word 2, $(MAKECMDGOALS))
LOCAL_AOSP_ROOT := $(if $(LOCAL_AOSP_ROOT) $(LOCAL_AOSP_ROOT),$(shell cd ../../.. && pwd))

$(warning $(LOCAL_AOSP_ROOT))

ifeq ($(DOCKER_BIN),)
$(warning Please install docker, e.g. for Ubuntu:)
$(warning $$ sudo apt install docker.io)
$(warning $$ sudo usermod -aG docker $$USER)
$(warning and reboot your PC)
$(error Aborting...)
endif

.PHONY : build clean help run stop shell
.DEFAULT_GOAL := help

help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

PREPARE:= /tmp/$(USER)/prepare_docker_$(IMAGE_NAME).timestamp
$(PREPARE): $(DOCKERFILE)
	mkdir -p $(dir $@)
	$(DOCKER_BIN) build -t local/build-env --build-arg MOUNT_DIR=$(LOCAL_AOSP_ROOT) -f $(DOCKERFILE) .;
	$(DOCKER_BIN) stop $(IMAGE_NAME) || true
	$(DOCKER_BIN) rm $(IMAGE_NAME) || true
	$(DOCKER_BIN) run -itd --name $(IMAGE_NAME) --network="host" -v $(LOCAL_AOSP_ROOT):$(LOCAL_AOSP_ROOT) -u $$(id -u):$$(id -g) local/build-env
	@touch $@

prepare: $(PREPARE)
prepare: ## Build and run Docker image

shell: $(PREPARE)
shell: ## Start shell inside the container
	$(DOCKER_BIN) exec -it $(IMAGE_NAME) bash

build_all: $(PREPARE)
build_all: ## Build all targets within a container (for CI purposes)
	$(DOCKER_BIN) exec -it $(IMAGE_NAME) bash -c "cd .repo/manifests/.ci && make unpatch_slowgpu"
	$(DOCKER_BIN) exec -it $(IMAGE_NAME) bash -c "cd .repo/manifests/.ci && make build_standard"
	$(DOCKER_BIN) exec -it $(IMAGE_NAME) bash -c "cd .repo/manifests/.ci && make patch_slowgpu"
	$(DOCKER_BIN) exec -it $(IMAGE_NAME) bash -c "cd .repo/manifests/.ci && make build_slowgpu"
