# Codefin test targets.
#
# Include from the repository Makefile, or paste the block in. Replace the command inside each
# target with what this project actually uses (references/stacks.md); keep the target names,
# because they are the contract every Codefin repository honours.
#
#   include makefile-test.mk
#
# ENV selects the environment for the layers that need real things running.

ENV ?= local

.PHONY: test test-integration test-e2e test-all

test: ## Unit tests. Fast, offline, no real dependencies.
	go test -race -coverprofile=coverage.txt -covermode=atomic ./...

test-integration: ## Integration tests against real dependencies. Usage: make test-integration ENV=sit
	@echo "integration against $(ENV)"
	go test -race -tags=integration ./test/integration/...

test-e2e: ## End-to-end through the real interface. Usage: make test-e2e ENV=sit
	@echo "e2e against $(ENV)"
	npx playwright test

test-all: ## All three layers in order, stopping at the first failure.
	$(MAKE) test
	$(MAKE) test-integration ENV=$(ENV)
	$(MAKE) test-e2e ENV=$(ENV)
