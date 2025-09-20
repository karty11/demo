variable "region" { 
  type = string
  default = "us-west-2" 
}
variable "environment" {
  description = "Deployment environment (dev, qa, prod)"
  type        = string
  default     = "dev"
}
variable "bucket_name" { 
  type = string
  default = ""
}
variable "glue_db" {
  type    = string
  default = ""
}
variable "allow_glue" {
  type    = bool
  default = true
  description = "Set to true to create AWS Glue catalog database, false to skip."
}
variable "kms_key_arn" {
  description = "KMS Key ARN for S3 encryption"
  type        = string
  default     = ""
}

variable "datalake_bucket" {
  description = "Name of the S3 bucket to store Glue scripts, tmp data, and outputs"
  type        = string
}

variable "vpc_id" {
  description = ""
  type        = string
}

variable "mysql_host" {
  description = "MySQL host or service endpoint"
  type        = string
}

variable "mysql_port" {
  description = "MySQL port number"
  type        = number
  default     = 3306
}

variable "mysql_db" {
  description = "MySQL database name"
  type        = string
}

variable "mysql_username" {
  description = "MySQL username"
  type        = string
}

variable "mysql_password" {
  description = "MySQL password"
  type        = string
  sensitive   = true
}


