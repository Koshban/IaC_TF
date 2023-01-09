Multi AWS account module
This folder contains an example Terraform configuration that shows how to have a reusable Terraform module work with multiple providers, which gives it the ability to work with multiple Amazon Web Services (AWS) accounts. This module defines configuration_aliases, so users of the module can pass in providers that have authenticated to different AWS accounts (e.g., via IAM roles).