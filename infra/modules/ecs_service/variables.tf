variable "task_family" {}
variable "execution_role_arn" {}
variable "task_role_arn" {}
variable "image_url" {}
variable "cluster_id" {}
variable "service_name" {}
variable "subnets" {
  type = list(string)
}
variable "security_group_id" {}
