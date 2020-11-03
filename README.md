# auto201
To find the aws image filter, use the aws cli:

aws ec2 describe-images --region eu-west-2 --filters "Name=name,Values=*BIGIP-15.1.1*PAYG-Best*25Mbps*" | grep '\"Name\"\|\"ImageId\"'


Terraform uses credentials in ~/aws/credentials

tfswitch -- Switch into a particular version of terraform.
terraform init  -- initialise terraform
terraform plan  -- plan changes
terraform apply -- apply changes
terraform fmt   -- formats the tf files

AZ:

eu-west-2a

Subnets:

mgmt: 10.0.1.0/24
public: 10.0.2.0/24
private: 10.0.3.0/24

Password:

id in terraform.tfstate file

Debug:

Turn on:  export TF_LOG=DEBUG
Turn off: export TF_LOG=""