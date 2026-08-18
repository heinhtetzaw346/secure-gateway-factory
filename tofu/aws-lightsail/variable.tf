variable "instance_type" {
  default     = "nano_3_0"
  type        = string
  description = "AWS Lightsail bundle_id"
}

variable "region" {
  default     = "ap-southeast-1"
  type        = string
  description = "AWS region"
}

variable "gl_user" {
  type        = string
  description = "gitlab user for backend"
}

variable "gl_pat" {
  type        = string
  description = "gitlab pat for backend"
}

variable "access_key" {
  type        = string
  description = "aws access key"
}

variable "secret_key" {
  type        = string
  description = "aws secret key"
}
