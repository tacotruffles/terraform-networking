### 1. Set up unique prefix string
resource "random_pet" "name" {
  prefix = "${var.prefix}-${var.stage}"
  length = 2
}

### 2. Set up Lambda access via IAM - To be Deprecated
# Define a policy to allow executing lambdas
resource "aws_iam_role" "api_lambda_exec" {
  name = "${random_pet.name.id}-api-lambda-exec"

  assume_role_policy = templatefile("${path.module}/policies/lambda-execution-policy.json", {})
}

# Attach this policy to a basic lambda execution role for API GATEWAY
resource "aws_iam_role_policy_attachment" "api_lambda_policy_api_gw" {
  role       = aws_iam_role.api_lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Attach VPC policy to same exectution role for Lambdas internet access inside VPC/NAT Gateway
resource "aws_iam_role_policy_attachment" "api_lambda_policy_vpc" {
  role       = aws_iam_role.api_lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}