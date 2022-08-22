DOCKER_ENV_FILE := FALSE
DOCKER_WEB_RUN_COMMAND := docker compose run web
DOCKER_UP_DB_COMMAND := docker compose up db --wait
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

.PHONY: run
run: ## run the OverEngineeredIt site
	docker compose up web

.PHONY: migration
migration: ## run Django migrations
	$(DOCKER_WEB_RUN_COMMAND) python manage.py migrate

.PHONY: createsuperuser 
createsuperuser: ## Create a Django admin super user
	$(DOCKER_WEB_RUN_COMMAND) python manage.py createsuperuser

.PHONY: reset
reset: ## reset local environment (including the db & docker)
	docker compose down --timeout 60
	docker container prune --force
	docker image rm overengineeredsite_web --force
	rm -rf .env data