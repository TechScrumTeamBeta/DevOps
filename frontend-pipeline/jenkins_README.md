# Jenkins Pipeline: TechScrum Frontend Deployment

This Jenkins pipeline automates the deployment process of the TechScrum frontend to an AWS S3 bucket.

## Prerequisites

Before running this pipeline, ensure the following prerequisites are met:
- Jenkins is set up with necessary plugins for AWS and Node.js.
- AWS credentials with appropriate permissions are configured.
- An S3 bucket is created and properly configured to host the frontend files.

## Pipeline Overview

This Jenkins pipeline performs the following steps:

1. **Checkout**: Clones the specified branch from the TechScrum frontend repository on GitHub.
2. **Build**: Installs dependencies and builds the frontend project.
3. **Deploy**: Syncs the built artifacts to the specified S3 bucket.
4. **Send Notification**: Sends a notification to an SNS topic in case of failure.

## Pipeline Parameters###please modify your own entities

The pipeline takes the following parameters:

- **AWS_CREDENTIAL_ID**: ID of the AWS credentials to use.
- **S3_BUCKET**: Name of the S3 bucket to deploy the frontend to.
- **GIT_BRANCH**: Git branch to build and deploy.

## How to Run

1. Open Jenkins and create a new pipeline project.
2. Copy the provided Jenkinsfile contents into the pipeline script.
3. Configure the necessary parameters as described above.
4. Run the pipeline manually or trigger it through a webhook or schedule.

## Notes

- Ensure the AWS credentials have the necessary permissions to access the S3 bucket.
- Adjust the SNS topic ARN and message content in the 'Send Notification' stage as needed.
- Modify the 'Build' stage commands if additional build steps are required for the frontend.

Feel free to modify the pipeline as needed to suit your specific deployment requirements.

For any issues or questions, please contact the TechScrum DevOps team.
