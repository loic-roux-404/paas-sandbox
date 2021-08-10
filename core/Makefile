vault:
	docker run -ti --rm vault:1.8.1

ansibleworker:
	docker build ansible/Dockerfile -t ansibleworker:1.0 -t ansibleworker:latest
	docker run -ti --rm -v $(pwd)/ansible:/etc/ansible ansibleworker:1.0

full: vault ansibleworker
