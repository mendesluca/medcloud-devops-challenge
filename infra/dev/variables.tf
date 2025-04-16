variable "aws_region" {
  description = "Região AWS onde os recursos serão provisionados"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Nome do projeto, utilizado para tagueamento"
  type        = string
  default     = "aws-devops-pipeline"
}

variable "environment" {
  description = "Ambiente de execução (ex: dev, prod)"
  type        = string
  default     = "dev"
}
