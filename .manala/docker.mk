DOCKER_CONTEXT:=.
DOCKER_NETWORK:=bridge # host / none / container / your-network
# Docker subnet prefix
DSP:=172.18.0
DOCKER_SUBNET:=$(DSP).0/16
QUIET:=2>/dev/null || true
# ==============
# Build and run container
#
# Usage : $(call docker_run)
# eval following env vars => $(eval KEY=VALUE)
# IMAGE_TAG = bar/foo
# === Optional ===
# PORTS = -p 22222:22
# DOCKERFILE bar/foo.Dockerfile
# DOCKER_ENVS = -e KEY
# VOLUMES = -v $(pwd)/:/var/www
# ==============
define docker_run
	$(eval NAME:=$(subst /,-,$(IMAGE_TAG)))
	@docker network create $(DOCKER_NETWORK) --subnet=$(DOCKER_SUBNET) $(QUIET)
	@docker stop $(NAME) $(QUIET)
	ID=$$( \
		docker -l debug build \
		$(if $(DOCKER_ARGS) --build-arg $(DOCKER_ARGS),) \
 		-t $(IMAGE_TAG):latest \
		-f $(DOCKERFILE) \
		$(DOCKER_CONTEXT) \
	) && docker run $(PORTS) \
		--rm \
		--cap-add IPC_LOCK \
		-it \
		--privileged \
		$(DOCKER_ENVS) \
		$(VOLUMES) \
		$(if $(NET),--ip=$(DSP).$(NET) ,) \
		--network=$(DOCKER_NETWORK) \
		--name $(NAME) \
		-d $(IMAGE_TAG) \
		&& echo "$${ID}"
endef
