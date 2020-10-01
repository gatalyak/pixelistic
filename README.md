# Pixelistic application
## This is for educational purpose only to show CI/CD pipeline using Azure, AWS and GCP cloud providers
Please set your environments from env.example to build and run applications. The pipelines are:
1. azure-pipelines.yml - pipepine for Azure DevOps.
2. Jenkinsfile - pipeline for local deploy.
3. Jenkinsfile_docker - pipeline for docker-compose deploy.

For jenkins pipelines please setup the hosts where the application will be deployed in file deployment/dev-servers as:
[pixelistic]  - for local deployment

[docker] - for docker-compose deployment
### To create environment to deploy the infrastructure with terrafrom and build CI/CD with AWS:
### Install Terraform

Install terraform using the this link [https://learn.hashicorp.com/terraform/getting-started/install.html](https://learn.hashicorp.com/terraform/getting-started/install.html)

### Configure credentials to access to AWS
```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```
### Apply terraform infrastructure to create AWS backend

Please go to the terraform_init and run terraform apply

### Create CodePipeline on AWS
On AWS create CodePipeline of AWS with ability to build docker images. Make sure you have set up policy for your CodePipeline to have access to the AWS ECR.
Point to the buildspec.yml from as the code for the CodePipeline.

### Setup environment variables
```
AWS_ACCESS_KEY_ID              - AWS access key for teraform deploy
AWS_SECRET_ACCESS_KEY          - AWS secret access key for terraform deploy
TF_VAR_AWS_ACCESS_KEY_ID       - AWS access key for S3 bucket access
TF_VAR_AWS_SECRET_ACCESS_KEY   - AWS secret access key for S3 bucket access
TF_VAR_EMAIL_PASS              - E-mail password
TF_VAR_EMAIL_USER              - E-mail account
TF_VAR_database_username       - Database user name 
TF_VAR_database_password       - Database password
```

### Switch environment to deploy to aws

In application root folder there are  `.tfvars` file for staging, production, development environment. 

You can use different environments to deploy infrastructure with terraform:

terraform apply --var-file=stage.tfvars 

### Folder structure for CI/CD pipelines
```
tf-k8s-aws - pipeline for AWS cloud provider
tf-k8s-gcp - pipeline for GCP cloud provider

```


