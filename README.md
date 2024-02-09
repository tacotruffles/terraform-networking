# Seed Terraform Backend and Stand Up AWS VPC/Networking for Multiple Environments

## Summary

This repo must be stood up first in order to set up the necessary back end tracking across all the cloud infrastructure deployed via Terraform and Ansible, which will be used in the other repos that comprise a full stack platform: API, WWW, with Lambdas that process uploads.

There is a one-time "seeding" process. Once, completed, creating the `stage` and `prod` branches on the repo are all it takes to deploy the AWS VPC/Networking configuration for each environment.

After the VPC/Networking infrastructure is successfully deployed. The order to deploy the other parts of the iSAT Recording platform will be:

`Lambda -> API -> WWW`

How to configure and stand up each part of the platform will be contained in each README.md file in the corresponding repo.

For this repo. The stand up process also incorporates a one-time `seeding` process:

`configure` -> `seed` -> `stand up`

You'll need the following prequisites:

* **Project Name (Prefix/AWS Profile):** 3 to 6 letter acronym for your project and `AWS Profile` name.
* **AWS Region/Project Location:** Determine the AWS region closest to your physical location.
* **AWS Credentials** AWS Secret/Key pair for the AWS CLI tool.

## Step 1: Configure Automated Deployment

In the [`terraform/tf.cfg`](terraform/tf.cfg) file, substitute the prequisite values:

```
# AWS CLI Config
AWS_PROFILE='<profile>'
AWS_REGION='<aws-region>'

# Helps Terraform name things and make AWS assets human-readable
PREFIX='<prefix>'
```

**Note: Leave all other lines unchanged.**

[View tf.cfg](terraform/tf.cfg)

Using our examples from above the resulting `tf.cfg` is:
```
**AWS CLI Config**
AWS_PROFILE='tacotruffles'
AWS_REGION='us-east-1'

**Helps Terraform name things and make AWS assets human-readable**
PREFIX='TMRS'
```

## Step 3: Seed Project State

Note: This procedure will only need to be peformed once. If you've completed this step or you have infrastructure already deployed, skip to the next section.

This will configure shared storage locations for Terraform state files so that any changes made to cloud infrastructure can be tracked along with code changes.

1. Create `seed` branch and push up to repo
2. Confirm the project is seeded successfully in the GitHub Actions log.

If you are not familiar with the above steps, follow the step-by-step document below:

[Seed Procedure](docs/seed.md)

## Step 4: Stand Up Infrastucture for STAGE Pipeline

[Stand Up AWS Networing](docs/standup.md)

This will be the test environment

1. Create `stage` branch and push up to repo
2. Confirm the network deployment completes successfully in the GitHub Action logs.
3. Save `whitelist_ip` value in a safe location outside this repo. This value can be found in the `Terraform Apply` step of the GitHub Actions log.

## Step 5: Stand Up Infrastucture for PROD Pipeline

This will be the live environment

1. Create `stage` branch and push up to repo
2. Confirm GitHub action completes successfully
3. Save `whitelist_ip` value in a safe location outside this repo. This value can be found in the `Terraform Apply` step of the GitHub Actions log.
