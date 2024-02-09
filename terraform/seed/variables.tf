variable "stages" {
  description = "List of stage names to create: dev, stage, prod"
  type = list(string)
}

variable "prefix" {
  description = "Acronym for your project"
  type = string
}
variable "aws_region" {
  description = "AWS region for deployment"
  type = string
}

variable "aws_profile" {
  description = "AWS CLI Profile name"
  type = string
}