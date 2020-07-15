DOCKER_CONTEXT:=.
DOCKER_NETWORK:=bridge # host / none / container / your-network
# Docker subnet prefix
DSP:=172.19.0
DOCKER_SUBNET:=$(DSP).0/16
# ==============
# Build and run container
#
# Usage : $(call docker_run)
# eval following env vars => $(eval KEY=VALUE)
# IMAGE_TAG = bar/foo
# PORTS = -p 22222:22
# DOCKERFILE bar/foo.Dockerfile
# ==============
define docker_run
	docker network create $(DOCKER_NETWORK) --subnet=$(DOCKER_SUBNET) || true; \
	ID=$$( \
		docker -l debug build \
 		--build-arg PUB \
 		-t $(IMAGE_TAG):latest \
		-f $(DOCKERFILE) \
		$(DOCKER_CONTEXT) \
	) && docker run $(PORTS)\
		--rm \
		--cap-add IPC_LOCK \
		-it \
		--privileged \
		--network=$(DOCKER_NETWORK) \
		--name $(subst /,-,$(IMAGE_TAG))\
		-d $(IMAGE_TAG) \
		&& echo "$${ID}"
endef
