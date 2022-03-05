SHELL = bash

VARIANT := userdebug

TARGETS :=     \
    pinephone  \
    pinetab    \
    opi3       \
    opi4       \
    rpi4       \
    opi_win    \
    opi_pc2    \
    opi_prime  \
    opi_pc     \

TARGETS +=     \
    opi_plus2  \
    opi_plus2e \

VER := $(shell git describe --tags)

AOSP_PATH := $(abspath $(dir $(MAKEFILE_LIST))/../../..)

.NOTPARALLEL:
.PHONY = help build_all
.DEFAULT_GOAL = help
.ONESHELL:

help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

$(warning $(AOSP_PATH))

define process-target

$(AOSP_PATH)/out_images/gd-$$(VER)-$1-$2.tar.gz.source:
	set -e
	cd $$(AOSP_PATH)
	mkdir -p out_images
	bash -c "[[ -f $FILE ]] || touch $$@"

$(AOSP_PATH)/out_images/gd-$$(VER)-$1-$2.tar.gz: $(AOSP_PATH)/out_images/gd-$$(VER)-$1-$2.tar.gz.source
	set -e
	cd $$(AOSP_PATH)
	. build/envsetup.sh
	echo $1-$2
	lunch $1-$2
	m images -k || m images -j1
	mv out/target/product/$1/images.tar.gz $$@
	rm -rf out/target/product/$1/*

endef

$(foreach target,$(TARGETS),$(eval $(call process-target,$(target),$(VARIANT))))

build_all: $(foreach target,$(TARGETS),$(AOSP_PATH)/out_images/gd-$(VER)-$(target)-$(VARIANT).tar.gz ) ## Build all GloDroid targets, put images into <AOSP tree>/out_images/...
