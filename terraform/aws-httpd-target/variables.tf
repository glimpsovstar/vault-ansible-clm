variable "aws_region" {
  description = "AWS region for the EC2 + Route53 record."
  type        = string
  default     = "ap-southeast-2"
}

variable "instance_type" {
  description = "EC2 instance type. t3.small (2 GiB) is the minimum for SOE because EDR + system daemons exhaust t3.micro."
  type        = string
  default     = "t3.small"
}

variable "key_pair_name" {
  description = "Existing AWS keypair for SSH access (name in EC2, not file path)."
  type        = string
  default     = "hashicorp-djoo-demo"
}

variable "name_prefix" {
  description = "Hostname prefix; combined with host_index to form the final hostname (e.g. clm-httpd-01)."
  type        = string
  default     = "clm-httpd"
}

variable "host_index" {
  description = "Numeric suffix for the hostname (e.g., 01 → clm-httpd-01)."
  type        = number
  default     = 1
}

variable "route53_zone_name" {
  description = "Route53 public zone name to register the A record under."
  type        = string
  default     = "david-joo.sbx.hashidemos.io"
}

variable "iam_instance_profile" {
  description = "Pre-existing IAM instance profile (managed outside this module)."
  type        = string
  default     = "tfstacks-profile"
}

variable "tags" {
  description = "Extra tags merged into the EC2 + record tag set."
  type        = map(string)
  default     = {}
}
