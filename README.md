# Macrolife

## Artifacts
* A git repo to hold macrolife infra terraform config/template.
* Individual git repo's to hold terraform module code.

## Tools
* IDE like vscode or anyother suitable.

## Process
* Develop terraform module code and tag them with version in their individual repo's
* Develop terrafrom template/config for macrolife project and save it to repo
* Create azure pipeline to do the following tasks
    1. Checkout terraform template repo
    2. Install terraform to make sure intended version is being used
    3. Terraform init
    4. Terraform plan and output the plan to a file
    5. Terraform apply using the previous task plan output file. Control this task with a boolean variable


## Password/Secrets usage with KV
* There are different ways to use this
    1. create a variable group in Azure devops by integrating with KV and use it in pipeline.
    2. use data blocks in terraform config to read the secret on the fly. We are Using this method in the current sample template.