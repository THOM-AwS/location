
plan: 
	terraform init
	terraform plan

apply: 
	terraform init
	terraform destroy -auto-approve
