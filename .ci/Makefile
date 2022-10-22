SHELL = bash

VARIANT := userdebug

TARGETS_STANDARD += \
    pinephonepro    \
    opi4            \
    rpi4            \
    opi3            \

TARGETS_SLOWGPU :=  \
    pinephone  \
    pinetab    \
    opi_win    \
    opi_pc2    \
    opi_prime  \
    opi_pc     \
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

TARGETS := $(TARGETS_STANDARD) $(TARGETS_SLOWGPU)
$(foreach target,$(TARGETS),$(eval $(call process-target,$(target),$(VARIANT))))

build_standard: $(foreach target,$(TARGETS_STANDARD),$(AOSP_PATH)/out_images/gd-$(VER)-$(target)-$(VARIANT).tar.gz ) ## Build all standard GloDroid targets, put images into <AOSP tree>/out_images/...

build_slowgpu: $(foreach target,$(TARGETS_SLOWGPU),$(AOSP_PATH)/out_images/gd-$(VER)-$(target)-$(VARIANT).tar.gz ) ## Build all slow-gpu GloDroid targets, put images into <AOSP tree>/out_images/...

patch_slowgpu: ## Patch the framework to reduce load on slow GPU
	cd $(AOSP_PATH)/frameworks/base
	git fetch https://android.googlesource.com/platform/frameworks/base refs/changes/33/2121633/1 && git cherry-pick FETCH_HEAD --allow-empty --keep-redundant-commits
	git fetch https://android.googlesource.com/platform/frameworks/base refs/changes/52/2123752/1 && git cherry-pick FETCH_HEAD --allow-empty --keep-redundant-commits
	cd $(AOSP_PATH)/frameworks/native
	git fetch https://android.googlesource.com/platform/frameworks/native refs/changes/73/2123073/1 && git cherry-pick FETCH_HEAD --allow-empty --keep-redundant-commits

unpatch_slowgpu: ## Restore the framework code after the patching
	cd $(AOSP_PATH)
	repo sync -l frameworks/base
	repo sync -l frameworks/native
