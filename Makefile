PROJECT := times-takuya-valheim
GCLOUD := gcloud --project=$(PROJECT)

.PHONY: terraform-init
terraform-init: terraform-backend-bucket terraform-service-account terraform/keys/terraform.json
	 cd terraform && terraform init

.PHONY: terraform-service-account
terraform-service-account:
	# ignore error if exists
	-$(GCLOUD) iam service-accounts create terraform
	-$(GCLOUD) projects add-iam-policy-binding $(PROJECT) \
		--member serviceAccount:terraform@$(PROJECT).iam.gserviceaccount.com \
		--role roles/editor

.PHONY: terraform-backend-bucket
terraform-backend-bucket:
	# ignore error if exists
	-gsutil mb -p $(PROJECT) -l asia-northeast1 gs://$(PROJECT)-terraform

terraform/keys/terraform.json:
	$(GCLOUD) iam service-accounts keys create ./terraform/keys/terraform.json \
		--iam-account terraform@$(PROJECT).iam.gserviceaccount.com
