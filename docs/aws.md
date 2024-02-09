# AWS CLI Credentials

[Prereqs](../README.md)

## Best Security Practices

Never store any files or pieces of information that contain credentials or keys! You'll expose your data and infrastructure to nefarious actors, and could lead to unwanted AWS fees.

## Create AWS CLI Credentials

If your organization doesn't have an AWS account coordinator/administrator that can provide CLI credentials, use the following steps to generate a dedicated user for deploying cloud infrastructure using a `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`

1. Search for `IAM` and click `Users` when it appears after hovering over the search result. <br /> 
![Step 1: Search for IAM](assets/aws/aws-iam-user01.png)<br />

2. Click `Create User`<br />
![Step 2: Create User](assets/aws/aws-iam-user02.png)<br />

3. Use naming convention `<PROJECT PREFIX>-deploy` to create your `IAM` user and click `Next`<br />
![Step 4: Enter IAM User Name](assets/aws/aws-iam-user03.png)<br />

4. Select `Attach polices directly` and search `AdministratorAccess`. Check the box next to this policy and click `Next` to apply administrative access to the deployment user. <br />
![Step 4: Set IAM User Permissions](assets/aws/aws-iam-user04.png) <br />

5. Click `Create User` <br />
![Step 5: Create Deployment User](assets/aws/aws-iam-user05.png)<br />

6. Upon success click `View User` to begin generating the deployment users' AWS access key.<br />
![Step 6: View the new user](assets/aws/aws-iam-user06.png)<br />

7. Click `Create access key`<br/> 
![Step 7: Create access key](assets/aws/aws-iam-user07.png)<br />

8. Select `Command Line Interface (CLI)` and check the `I understand....` box. Click `Next` to proceed.<br/>![](assets/aws/aws-iam-user08.png)<br />

9. Add a description like: `<PROJECT PREFIX> Iac Deployment Key` so that the deployment users' purpose is clear.<br/>
![](assets/aws/aws-iam-user09.png)<br />

10. Copy and paste the `Access key` and `Secret access key` values in a safe location outside of the repo.

11. Click `Download .csv file` and save the resulting `.csv` file as a back up in a safe location.<br />
![Steps 10-11: Copy AWS Acces Keys and Download .CSV backup file](assets/aws/aws-iam-user10.png)<br />

