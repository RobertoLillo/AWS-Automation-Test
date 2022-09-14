# AWS-Automation-Test

Just a test repository used to learn how Terraform sets up EC2 instances on AWS.

## Good practices 

- Add IAM user credentials into the AWS CLI instead of variables in the vars.tf file

- **Basic files**: vars.tf - providers.tf - instances.tf

- **Execution**: init -> validate -> fmt -> plan -> apply -> destroy (if needed)