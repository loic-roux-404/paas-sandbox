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
	ID=$$( \
		docker -l debug build \
 		--build-arg PUB \
 		-t=$(IMAGE_TAG):latest \
		$(DOCKERFILE) \
	) && docker run $(PORTS)\
		--rm \
		--cap-add IPC_LOCK \
		-it \
		-d $(IMAGE_TAG) \
		&& echo "$${ID}"
endef
