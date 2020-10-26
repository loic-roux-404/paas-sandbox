include .manala/ansible.mk
include .manala/docker.mk

help_more:
	@echo "[===== nginx reverse proxy help =====]"

IMAGE_TAG:=nginx-proxy-sqlite
VOLUMES:= \
	    -v $(PWD)/files/config.json:/app/config/production.json \
        -v $(PWD)/files/data/:/data \
        -v $(PWD)/files/letsencrypt/:/etc/letsencrypt
PORTS:= \
		-p '80:80' \
        -p '443:443' \
        -p '81:81'
DOCKERFILE:=$(PWD)/files/Dockerfile

start:
	@$(call docker_run)

stop:
	docker stop $(IMAGE_TAG)
