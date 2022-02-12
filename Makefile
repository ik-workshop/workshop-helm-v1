.EXPORT_ALL_VARIABLES:

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

setup: ## Setup dependencies
	@brew bundle

hooks: ## install pre commit.
	@pre-commit install
	@pre-commit gc
	@pre-commit autoupdate

validate: ## Validate files with pre-commit hooks
	@pre-commit run --all-files

check-cmd:
ifndef name
		$(error The name variable is not set)
endif
ifneq ($(findstring ex,$(name)),ex)
		$(error The name variable does not contain 'ex')
endif

hcreate: ## Create new helm chart name=test
hcreate: check-cmd
	@helm create playground/$(name)

create: ## Create new helm chart from template name=exN. Should fail if exercise exists.
create: check-cmd
	@mkdir playground/$(name)
	@cp -r playground/template/ playground/$(name)/
	@tree playground/$(name)
