Various steps to initialize the Test Framework here:
----------------------------------------------------
Initialize with go mod init <<repositorypath>>/<ORG_NAME>/<PROJECT_NAME> e.g. go mod init github.com/Koshban/IaC_TF
go get github.com/gruntwork-io/terratest/modules/terraform
go get github.com/gruntwork-io/terratest/modules/http-helper

# Go TestRun cmds:
go mod tidy
go test -v -timeout 30m  # default is 10 mins
go test -v -timeout 30m -run TestHelloWorldAppExample # run just this test (otherwise, Go’s default behavior is to run all tests in the current folder
