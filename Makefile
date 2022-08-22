DOCKER_ENV_FILE := FALSE
DOCKER_COMMAND := docker compose run web 
SHELL := /bin/bash
include .env

.PHONY: help
help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.env: ## Setup basic .env file
	echo "Copying default.env to .env"
	cp default.env .env
	
.PHONY: setup
setup: migration createsuperuser ## Make docker container, migrate db, and setup super user

.PHONY: migration
migration: ## run Django migrations
	docker compose run web python manage.py migrate

.PHONY: createsuperuser 
createsuperuser: ## Create a Django admin super user
	docker compose run web python manage.py createsuperuser

