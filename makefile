
plan: 
	sudo apt install  software-properties-common gnupg2 curl
	curl https://apt.releases.hashicorp.com/gpg | gpg --dearmor > hashicorp.gpg
	sudo install -o root -g root -m 644 hashicorp.gpg /etc/apt/trusted.gpg.d/
	sudo apt-add-repository "deb https://apt.releases.hashicorp.com $(lsb_release -cs) main"
	sudo apt install terraform
	terraform plan

apply: 
	terraform apply -auto-approve
