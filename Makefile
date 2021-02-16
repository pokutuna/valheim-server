PROJECT := times-takuya-valheim
GCLOUD := gcloud --project=$(PROJECT)

TF_BACKEND_BUCKET := $(PROJECT)-terraform

.PHONY: terraform-init
terraform-init: terraform-backend-bucket terraform-service-account terraform/keys/terraform.json
	 cd terraform && terraform init -backend-config="bucket=$(TF_BACKEND_BUCKET)"

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
	-gsutil mb -p $(PROJECT) -l asia-northeast1 gs://$(TF_BACKEND_BUCKET)

terraform/keys/terraform.json:
	$(GCLOUD) iam service-accounts keys create ./terraform/keys/terraform.json \
		--iam-account terraform@$(PROJECT).iam.gserviceaccount.com
