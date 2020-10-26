# nginx-infra

Docker temp infrastructure based on nginx reverse proxy / GUI and SSL (letsencrypt)

# Requirements
- docker
- ansible

# Testing

launch `make start` and access UI to localhost:81
stop with `make stop`

# Deploy

`make site`
