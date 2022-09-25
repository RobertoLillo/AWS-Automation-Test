# AWS-Automation-Test

Just a test repository used to learn how Terraform sets up EC2 instances on AWS.

## Installation

1. [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
2. [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

## Documentation

1. [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

## Good practices 

- Add IAM user credentials into the AWS CLI with `aws configure`

- **Basic files**: vars.tf - providers.tf - instances.tf

- **Execution**: init -> validate -> fmt -> plan -> apply -> destroy (if needed)
