variable "REGION" {
  type    = string
  default = "us-east-1"
}

variable "ZONE1" {
  default = "us-east-1a"
}

variable "ZONE2" {
  default = "us-east-1b"
}

variable "ZONE3" {
  default = "us-east-1c"
}

variable "PUB_KEY" {
  default = "/home/codespace/.ssh/web02_key.pub"
}

variable "PRIV_KEY" {
  default = "/home/codespace/.ssh/web02_key"
}

variable "VPC_NAME" {
  default = "teachua-vpc"
}

variable "VPC_CIDR" {
  default = "10.0.0.0/16"
}

variable "PUB_SUB1_CIDR" {
  default = "10.0.1.0/24"
}

variable "PUB_SUB2_CIDR" {
  default = "10.0.2.0/24"
}

variable "PUB_SUB3_CIDR" {
  default = "10.0.3.0/24"
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile name"
  default     = "teachua-instance-profile"
}

variable "datasource_url" {
  description = "URL for connecting to the database"
  type        = string
}

variable "datasource_user" {
  description = "Database user"
  type        = string
}

variable "datasource_password" {
  description = "Database password"
  type        = string
}

variable "jdbc_driver" {
  description = "JDBC Driver"
  type        = string
}
