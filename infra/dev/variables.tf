variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  default = "aws-devops-pipeline"
}

variable "environment" {
  default = "dev"
}
