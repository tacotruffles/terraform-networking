# Seed Terraform Backend and Stand Up AWS VPC/Networking

## Pattern

A single VPC for staging and production AWS assets:

* An EC2 jump host with an Elastic IP for document db remote access
* NAT Gateway that is assigned an Elastic IP so that lambdas can either communicate with DocumentDB and/or be whitelisted on external resources (i.e. mongodb.com)
* 4 Subnets for availability zone redundancy

## Summary

This repo must be stood up first in order to set up the necessary S3 buckets for the Terraform state files, which will be used in other repos that comprise a full stack platform: API, WWW, and with Lambdas that process video uploads. There is a single "global" state file bucket for VPC/Networking assets, and a jumphost for documentdb remote access for accessing both staging and production environments.

There is a one-time "seeding" process that creates 3 state file buckets. The `global` bucket is used to store all AWS Networking/VPC/jumphost configurations. The other two S3 buckets are used to store all staging and production state files across the application stack and the corresponding repos. 

Once the seeding process is completed, creating the `stage` and `prod` branches on the repo are all it takes to deploy the AWS VPC/Networking configuration for each environment.

After the VPC/Networking infrastructure is successfully deployed. The order to deploy the other parts of the applicaction will be stand up the following repos:

`Lambda -> API -> WWW`

How to configure and stand up each part of the platform will be contained in each README.md file in the corresponding repo.

For this repo. The stand up process also incorporates a one-time `seeding` process:

You'll need the following prequisites:

* **Project Name (Prefix/AWS Profile):** 3 to 6 letter acronym for your project and `AWS Profile` name.
* **AWS Region/Project Location:** Determine the AWS region closest to your physical location.
* **AWS Credentials** AWS Secret/Key pair for the AWS CLI tool.
* **AWS Access key ID	and AWS Secret access key**

## Step 1: Configure Repo Secrets

Add the `AWS Access key ID`	and `AWS Secret access` keys to the `terraform-network` repo as the following action secrets: `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`

## Step 2: Configure Automated Deployment

In the [`terraform/tf.cfg`](terraform/tf.cfg) file, substitute the prequisite values:

```
# AWS CLI Config
AWS_PROFILE='<profile>'
AWS_REGION='<aws-region>'

# Helps Terraform name things and make AWS assets human-readable
DOMAIN='<example.com>'
PREFIX='<prefix>'
```

**Note: Leave all other lines unchanged.**

[View tf.cfg](terraform/tf.cfg)

Using our examples from above the resulting `tf.cfg` is:
```
**AWS CLI Config**
AWS_PROFILE='tacotruffles'
AWS_REGION='us-east-1'

**Helps Terraform avoid naming collisions and AWS assets human-readable**
DOMAINDOMAIN='<example.com>'
PREFIX='TMRS'
```

## Step 3: Seed Project State

Note: This procedure will only need to be peformed once. If you've completed this step or you have infrastructure already deployed, skip to the next section.

This will configure shared storage locations for Terraform state files so that any changes made to cloud infrastructure can be tracked along with code changes.

1. Create `seed` branch and push up to repo and GitHub Actions will install Terraform and create the 3 S3 state file storage buckets
2. Confirm the project is seeded successfully in the GitHub Actions log.

If you are not familiar with the above steps, follow the step-by-step document below:

[Seed Procedure](docs/seed.md)

## Step 4: Stand Up Infrastucture for STAGE Pipeline

[Stand Up AWS Networing](docs/standup.md)

This will be the test environment

1. Create `stage` branch and push up to repo and GitHub Actions will intall Terraform and the necessary software to build assets and deploy the to the corresponding AWS infrastructure.
2. Confirm the network deployment completes successfully in the GitHub Action logs.
3. Other repos will ingest the needed security groups, VPC, etc. by loading the global networking Terraform state file

## Step 5: Stand Up Infrastucture for PROD Pipeline

This will be the live environment

1. Create `prod` branch and push up to repo
2. Confirm GitHub action completes successfully
3. Other repos will ingest the needed security groups, VPC, etc. by loading the global networking Terraform state file

## Teardown Process

Before tearding down networking both the staging and production environments in higher levels of the stack must be torn down first.

1. Run the `terraform/tf.sh destroy` command to tear down all Networking Assets
