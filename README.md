Prerequisite
  1	Aws access_key_id and secret access_key_id configured in github secrets.
  2	One s3 bucket already created to use it to store terraform.tfstate file.

Project Overview
  This project demonstrates the deployment of an application to an AWS EC2 instance using Terraform and GitHub Actions.

Directory Structure
  1	terraform/: Contains Terraform configuration files for deploying to EC2
  2	.github/workflows/: Contains GitHub Actions workflow files for automating deployment

How to Use
 1.	Any commit on terraform file will trigger the workflow to create infrastructure on terraform workflow:
  o	creates infrastructure:- ec2,s3, security group, iam instance profile,iam role,iam policy.
  o	the terraform state file will be located at the s3 bucket we already created, you have to mention it on backend.tf
  o	the script will deploy the application on ec2, application will be accesssible via port 80.
  o	before testing the application we will wait for 2 mins because our application needs time to execute and run.
  o	now application is running you can see it's public_ip in output and access the application.
  o	to save cost the ec2 instance will be stopped after 10 mins as we specify in terraform.tfvars

 2.	Destroy the infrastructure
  o	to destroy the infrastructure we have to commit on "github/workflows/destroy.yml" file.
  o	it will trigger the workflow to destroy the infrastructure.

Workflow Details
 The GitHub Actions workflow is defined in .github/workflows/deploy.yml. It performs the following steps:
  1.	Checkout code: Checks out the code in the repository.
  2.	Configure AWS credentials: Configures AWS credentials using secrets stored in the repository.
  3.	Initialize Terraform: Initializes Terraform in the terraform/ directory.
  4.	Apply Terraform configuration: Applies the Terraform configuration to deploy to EC2.
  5.	Validate app health: Validates the health of the application by sending a request to the EC2 instance.
  6.	Destroy Infrastructure Destroys the infrastrucure.

Future/incomplete work
  •	Passing stage parameter via Github input
