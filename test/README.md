Automated testing examples
This folder contains examples of how to write automated tests for infrastructure code using Go and Terratest.

Pre-requisites
You must have Go installed on your computer (minimum version 1.13).
You must have Terraform installed on your computer.
You must have OPA installed on your computer.
You must have an Amazon Web Services (AWS) account.

Various steps to initialize the Test Framework here:
----------------------------------------------------
Initialize with go mod init <<repositorypath>>/<ORG_NAME>/<PROJECT_NAME> e.g. go mod init github.com/Koshban/IaC_TF
go get github.com/gruntwork-io/terratest/modules/terraform
go get github.com/gruntwork-io/terratest/modules/http-helper
go get github.com/gruntwork-io/terratest/modules/aws@v0.41.9
go get github.com/gruntwork-io/terratest/modules/k8s@v0.41.9

# Go TestRun cmds:
go mod tidy
go test -v -timeout 30m  # Runs all Tests , default timeout is 10 mins
go test -v -timeout 30m -run TestHelloWorldAppExample # run one test (otherwise, Go’s default behavior is to run all tests in the current folder
