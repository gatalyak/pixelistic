# pixelistic
# This is for educational purpose only to show how the application was dockerized and deployed to the azure cloud.
Please set your environments from env.example to build and run applications. The pipelines are:
1. azure-pipelines.yml - pipepine for Azure DevOps.
2. Jenkinsfile - pipeline for local deploy.
3. Jenkinsfile_docker - pipeline for docker-compose deploy.

For jenkins pipelines please setup the hosts where the application will be deployed in file deployment/dev-servers as:
[pixelistic]  - for local deployment

[docker] - for docker-compose deployment

