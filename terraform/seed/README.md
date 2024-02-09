# Prerequisites
This is a bootstrap process and MUST only be run the first time this code is deployed
Run this layer of IaC to set up the back end and generate the needed security files/credentials for this project

```
terraform init
-backend-config="access_key=${{ secrets.AWS_ACCESS_KEY }}" \
-backend-config="secret_key=${{ secrets.AWS_SECRET_ACCESS_KEY}}" \
-backend-config="region=us-west-1"
 
 --- OR ????? TODO ---
set envs AWS_ACCESS_KEY, AWS_SECRET_ACCESS_KEY, and AWS_PROFILE 
before `terraform init`

terraform plan
terraform apply --auto-approve
```

# S3 Bucket for Split States
Can't be destroyed until state file are removed.

```
aws sts get-caller-identity --profile curve10
```