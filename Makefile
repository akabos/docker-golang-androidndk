.SUFFIXES:
.PHONY: all
all: build push

REPO ?= akabos/gomobile
GO_VERSION ?= 1.9.2
NDK_VERSION ?= r16b
NDK_CHECKSUM ?= 42aa43aae89a50d1c66c3f9fdecd676936da6128
NDK_FILENAME ?= android-ndk-$(NDK_VERSION)-linux-x86_64.zip

TAG ?= $(GO_VERSION)-$(NDK_VERSION)
DOCKERFILE = Dockerfile.$(TAG)

.PHONY: build
build: Dockerfile
	docker build --tag $(REPO):$(TAG) .

.PHONY: push
push:
	docker push $(REPO):$(TAG)

.PHONY: clean
clean:
	rm -f Dockerfile $(DOCKERFILE)

Dockerfile: $(DOCKERFILE)
	@rm -f Dockerfile
	ln -s $(DOCKERFILE) $(@) 

$(DOCKERFILE): Dockerfile.in 
	m4 \
		-DGO_VERSION=$(GO_VERSION) \
		-DNDK_VERSION=$(NDK_VERSION) \
		-DNDK_CHECKSUM=$(NDK_CHECKSUM) \
		-DNDK_FILENAME=$(NDK_FILENAME) \
		-DNDK_DIRNAME=android-ndk-$(NDK_VERSION) \
		Dockerfile.in > $(@)
