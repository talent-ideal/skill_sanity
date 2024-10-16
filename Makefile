SHELL = /bin/bash

include .env

PHX_HOST = localhost

# WARNING: USED BY CI WORKFLOWS, DO NOT REMOVE
LATEST_VERSION := $(shell git describe --abbrev=0 --tags --match "v*")
LATEST_REF := $(shell git rev-parse --short HEAD)
APP_REVISION := $(LATEST_VERSION)+$(LATEST_REF)

###########
# GENERAL #
###########

# WARNING: USED BY CI WORKFLOWS, DO NOT REMOVE
.PHONY: get-revision
get-revision:
	@echo $(APP_REVISION)

.PHONY: start
start: start-db
	@POSTGRES_HOST=${POSTGRES_HOST} \
	POSTGRES_USER=${POSTGRES_USER} \
	POSTGRES_DB=${POSTGRES_DB} \
	POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
	POSTGRES_PORT=${POSTGRES_PORT} \
	PHX_HOST=$(PHX_HOST) \
	APPSIGNAL_PUSH_KEY=${APPSIGNAL_PUSH_KEY} \
	APP_REVISION=$(APP_REVISION) \
	AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
	AWS_ENDPOINT_URL_S3=${AWS_ENDPOINT_URL_S3} \
	AWS_REGION=${AWS_REGION} \
	AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
	BUCKET_NAME=${BUCKET_NAME} \
	mix phx.server

.PHONY: stop
stop:
	@docker compose down

.PHONY: iex
iex: start-db
	@PHX_HOST=$(PHX_HOST) \
	APP_REVISION=$(APP_REVISION) \
	AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
	AWS_ENDPOINT_URL_S3=${AWS_ENDPOINT_URL_S3} \
	AWS_REGION=${AWS_REGION} \
	AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
	BUCKET_NAME=${BUCKET_NAME} \
	iex -S mix

.PHONY: translations
translations:
	@mix gettext.extract
	@mix gettext.merge priv/gettext

###########
#  TESTS  #
###########

.PHONY: test
test: start-db-test
	@MIX_ENV=test mix test

.PHONY: test-watch
test-watch: start-db-test
	@MIX_ENV=test mix test.watch

.PHONY: coverage
coverage: start-db-test
	@MIX_ENV=test mix test --cover

.PHONY: start-db-test
start-db-test:
	@docker compose --env-file .env.test up -d db --wait

.PHONY: migrate-db-test
migrate-db-test: start-db-test
	@MIX_ENV=test mix ash.migrate

# seed-db-test: start-db-test migrate-db-test
# 	@MIX_ENV=test mix run priv/repo/seeds.exs

.PHONY: reset-db-test
reset-db-test:
	@docker compose --env-file .env.test down db --volumes
	@make migrate-db-test

.PHONY: psql-test
psql-test: start-db-test
	@source .env.test && docker compose --env-file .env.test exec db psql --username=${POSTGRES_USER} $${POSTGRES_DB}

############
# DATABASE #
############

.PHONY: start-db
start-db:
	@docker compose up -d db --wait

.PHONY: stop-db
stop-db:
	@docker compose down db

.PHONY: migrate-db
migrate-db: start-db
	@POSTGRES_HOST=${POSTGRES_HOST} \
	POSTGRES_USER=${POSTGRES_USER} \
	POSTGRES_DB=${POSTGRES_DB} \
	POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
	POSTGRES_PORT=${POSTGRES_PORT} \
	APPSIGNAL_PUSH_KEY=${APPSIGNAL_PUSH_KEY} \
	mix ash.migrate

.PHONY: seed-db
seed-db: start-db migrate-db
	@POSTGRES_HOST=${POSTGRES_HOST} \
	POSTGRES_USER=${POSTGRES_USER} \
	POSTGRES_DB=${POSTGRES_DB} \
	POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
	POSTGRES_PORT=${POSTGRES_PORT} \
	APPSIGNAL_PUSH_KEY=${APPSIGNAL_PUSH_KEY} \
	mix run priv/repo/seeds.exs

.PHONY: reset-db
reset-db:
	@echo -n "Do you want to continue? All data will be lost. (y/N) " && read ans && [ $${ans:-N} = y ]
	@docker compose down db --volumes
	@make seed-db

.PHONY: backup-db
backup-db: start-db
	@docker compose exec db pg_dump --username=${POSTGRES_USER} ${POSTGRES_DB} | gzip -9 > ${POSTGRES_DB}_$$(date '+%Y-%m-%d_%H.%M.%S').sql.gz

.PHONY: psql
psql: start-db
	@docker compose exec db psql --username=${POSTGRES_USER} ${POSTGRES_DB}

###########
# FLY.IO  #
###########

.PHONY: fly-console-staging
fly-console-staging:
	@fly ssh console --pty --config fly.staging.toml

.PHONY: fly-console-prod
fly-console-prod:
	@fly ssh console --pty --config fly.prod.toml

.PHONY: fly-iex-staging
fly-iex-staging:
	@fly ssh console --pty --command "/app/bin/skill_sanity remote" --config fly.staging.toml

.PHONY: fly-iex-prod
fly-iex-prod:
	@fly ssh console --pty --command "/app/bin/skill_sanity remote" --config fly.prod.toml

.PHONY: fly-psql-staging
fly-psql-staging:
	@fly postgres connect -a skill-sanity-db-staging

.PHONY: fly-psql-prod
fly-psql-prod:
	@fly postgres connect -a skill-sanity-db-prod

.PHONY: fly-status-staging
fly-status-staging:
	@fly status --config fly.staging.toml

.PHONY: fly-status-prod
fly-status-prod:
	@fly status --config fly.prod.toml

.PHONY: fly-deploy-staging
fly-deploy-staging:
	@fly deploy --config fly.staging.toml -e APP_REVISION=$(APP_REVISION)

.PHONY: fly-deploy-prod
fly-deploy-prod:
	@fly deploy --config fly.prod.toml -e APP_REVISION=$(APP_REVISION)

.PHONY: fly-logs-staging
fly-logs-staging:
	@fly logs --config fly.staging.toml | sed -e '/GET \/api\/health_check/,+1d'

.PHONY: fly-logs-prod
fly-logs-prod:
	@fly logs --config fly.prod.toml | sed -e '/GET \/api\/health_check/,+1d'
