DOCKER_CONTEXT:=.
DOCKER_NETWORK:=bridge # host / none / container / your-network
# All required variable
IMAGE_TAG:=hello-world
IMAGE_VERSION:=latest
PORTS:=
# Optional
DOCKER_ENVS:=
VOLUMES:=-v
# Docker subnet prefix
DSP:=172.18.0
DOCKER_SUBNET:=$(DSP).0/16
QUIET:=2>/dev/null || true
# ==============
# Build and run container
#
# Usage : 
# - simple run $(call docker_run) 
# - build and run $(call docker_full)
# eval following env vars => $(eval KEY=VALUE)
# IMAGE_TAG = bar/foo
# === Optional ===
# PORTS = -p 22222:22
# DOCKERFILE bar/foo.Dockerfile
# DOCKER_ENVS = -e KEY
# VOLUMES = -v $(pwd)/:/var/www
# ==============

define docker_full
	ID=$$($(call docker_build)) && $(call docker_run)
endef

define docker_run
	$(eval NAME:=$(subst /,_,$(IMAGE_TAG)))
	@docker network create $(DOCKER_NETWORK) --subnet=$(DOCKER_SUBNET) $(QUIET)
	@docker stop $(NAME) $(QUIET)
	docker run $(PORTS) \
		--rm \
		-d \
		--cap-add IPC_LOCK \
		-it \
		--privileged \
		$(DOCKER_ENVS) \
		$(VOLUMES) \
		$(if $(NET),--ip=$(DSP).$(NET) ,) \
		--network=$(DOCKER_NETWORK) \
		--name $(NAME) \
		$(IMAGE_TAG):$(IMAGE_VERSION) \
	&& echo "$${ID}"
endef

define docker_build
	docker -l debug build \
	$(if $(DOCKER_ARGS) --build-arg $(DOCKER_ARGS),) \
	-t $(IMAGE_TAG):$(IMAGE_VERSION) \
	$(if $(DOCKERFILE) -f $(DOCKERFILE),) \
	$(DOCKER_CONTEXT)
endef
