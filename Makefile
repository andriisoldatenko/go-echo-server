IMAGE     ?= asoldatenko/echo-server
TAG       ?= 0.0.5
FULL_IMG   = $(IMAGE):$(TAG)
PORT      ?= 8080
PLATFORM ?= linux/amd64

.PHONY: build build-multiarch run push push-multiarch login clean

build:
	podman build --platform=$(PLATFORM) -t $(FULL_IMG) .

run:
	podman run --rm -p $(PORT):8080 -e PORT=8080 $(FULL_IMG)

push:
	podman push $(FULL_IMG) docker://docker.io/$(FULL_IMG)

login:
	podman login docker.io

clean:
	podman rmi $(FULL_IMG) || true

deploy:
	kubectl delete -f pod.yaml || true
	@echo "Deploying image $(FULL_IMG) to Kubernetes"
	kubectl apply -f pod.yaml