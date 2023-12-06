# Jenkins Pipeline: IAC Management

This Jenkins pipeline automates Infrastructure as Code (IAC) management using Terraform for the specified Git branch.

## Prerequisites

1. Jenkins environment set up and running.
2. AWS credentials available and configured in Jenkins.
3. Git repository with the specified branch (`your-branch`) for IAC.

## Pipeline Overview

This pipeline is designed to:

1. Clone the specified Git repository.
2. Initialize Terraform and perform a plan.
3. Apply changes to the infrastructure defined in the repository.

## Pipeline Configuration

### Parameters

- **AWS_CREDENTIAL_ID**: The ID of the AWS credentials to use. Default value is set to `'your credential ID'`.
- **GIT_BRANCH**: The Git branch to build and deploy. Default value is set to `'your branch'`.

### Steps

1. **IAC_management**:
    - Clone the repository from the provided URL.
    - Checkout the specified Git branch.
    - Change to the correct directory (`IAC_pipeline_test`).
    - Run Terraform commands: `init`, `plan`, and `apply --auto-approve`.

## How to Use

1. Open Jenkins and create a new Pipeline project.
2. Copy and paste the provided pipeline script into the pipeline configuration.
3. Set up the parameters as per your environment and requirements.
4. Save and run the pipeline.

**Note**: Ensure that Jenkins has necessary permissions to access the Git repository and AWS services using the provided credentials.

For further assistance or inquiries, please refer to the Jenkins documentation or contact the DevOps team.
