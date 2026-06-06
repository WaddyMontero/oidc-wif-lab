PYTHON ?= python3
APP_DIR := app
INFRA_DIR := infra

.PHONY: test docker-build terraform-fmt terraform-validate guardrails plan apply outputs destroy

test:
	cd $(APP_DIR) && PYTHONPATH=. $(PYTHON) -m pytest -q

docker-build:
	docker build -t oidc-wif-lab:local $(APP_DIR)

terraform-fmt:
	cd $(INFRA_DIR) && terraform fmt -recursive

terraform-validate:
	cd $(INFRA_DIR) && terraform init -backend=false && terraform validate

guardrails:
	./scripts/check-guardrails.sh

plan:
	cd $(INFRA_DIR) && terraform plan

apply:
	@echo "This lab intentionally makes apply an explicit action."
	cd $(INFRA_DIR) && terraform apply

outputs:
	./scripts/print-terraform-outputs.sh

destroy:
	./scripts/destroy-lab.sh
