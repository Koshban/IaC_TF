ALB example
--------------=
This folder contains a Terraform configuration that shows an example of how to use the alb module to deploy a load balancer (using ELB) in an Amazon Web Services (AWS) account.

Pre-requisites
---------------
You must have Terraform installed on your computer.
You must have an Amazon Web Services (AWS) account.
Please note that this code was written for Terraform 1.3.6

Quick start
Please note that this example will deploy real resources into your AWS account. We have made every effort to ensure all the resources qualify for the AWS Free Tier, but we are not responsible for any charges you may incur.

Configure your AWS access keys as environment variables ( or add them to your $HOME/.aws/credrntials file ):

export ( or set in Windows )  AWS_ACCESS_KEY_ID=(your access key id)
export ( or set in Windows )  AWS_SECRET_ACCESS_KEY=(your secret access key)
Deploy the code:
--------------------
terraform init
terraform apply

Clean up when you're done:
-------------------------

terraform destroy