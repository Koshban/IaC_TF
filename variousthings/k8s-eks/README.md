
Kubernetes example

--------------------
This folder contains an example Terraform configuration that deploys a Kubernetes cluster using EKS into an Amazon Web Services (AWS) account, deploys a simple webapp into that Kubernetes cluster using a Kubernetes Deployment, and configures a load balancer for the app using a Kubernetes Service.

Pre-requisites
You must have Terraform installed on your computer.
You must have an Amazon Web Services (AWS) account.

Quick start
Please note that this example will deploy real resources into your AWS account. 

Configure your AWS access keys as environment variables ( or add them to your $HOME/.aws/credrntials file )

export AWS_ACCESS_KEY_ID=(your access key id)
export AWS_SECRET_ACCESS_KEY=(your secret access key)
Deploy the code:
------------------

terraform init
terraform apply

Clean up when you're done
---------------------------

terraform destroy
