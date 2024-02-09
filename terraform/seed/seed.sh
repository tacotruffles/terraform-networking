#!/bin/bash

# Load Terraform configuration
source ../tf.cfg

# Override Terraform variables
export TF_VAR_stages=$STAGES
export TF_VAR_prefix=$PREFIX
export TF_VAR_aws_region=$AWS_REGION
export TF_VAR_aws_profile=$AWS_PROFILE

# Initialize Terraform
terraform init

# Create Terraform Backend Storage
terraform apply --auto-approve

echo "Please note 'bucket_names' above"