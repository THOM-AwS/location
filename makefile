
plan: 
	terraform init
	terraform plan

apply: 
	terraform init
	terraform apply -auto-approve
