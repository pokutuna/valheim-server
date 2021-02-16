PROJECT := fluid-unfolding-304704
GCLOUD := gcloud --project=$(PROJECT)

TF_BACKEND_BUCKET := $(PROJECT)-tfstate

.PHONY: init
init: terraform-backend-bucket terraform-service-account terraform/keys/$(PROJECT).json terraform-init

.PHONY: terraform-init
terraform-init:
	cd terraform && \
		terraform init \
			-backend-config="bucket=$(TF_BACKEND_BUCKET)" \
			-backend-config="credentials=keys/$(PROJECT).json"

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

terraform/keys/$(PROJECT).json:
	$(GCLOUD) iam service-accounts keys create ./terraform/keys/$(PROJECT).json \
		--iam-account terraform@$(PROJECT).iam.gserviceaccount.com
