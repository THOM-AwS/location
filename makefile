
plan: 
	terraform init
	terraform untaint aws_ses_domain_identity.apse2_domain
	terraform plan

apply: 
	terraform init
	terraform apply -auto-approve
