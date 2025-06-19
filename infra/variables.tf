variable "aws_region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "Name of the EC2 Key Pair"
}

variable "security_group_id" {
  description = "Pre-created security group ID"
}

variable "iam_instance_profile" {
  description = "Name of IAM instance profile to attach"
}
