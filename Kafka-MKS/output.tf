# 	Outputs

#	VPC ID

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

#	VPC CIDR blocks

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

# VPC Private Subnets

output "private_subnets" {
  description = "A list of private_subnets inside the VPC"
  value       = module.vpc.private_subnets
}

# VPC AZS

output "azs" {
  description = "A list of Availability zones specified as argument to this module"
  value       = module.vpc.azs
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "aws_instance_public_ip" {
  description = "aws_instance_public_ip"
  # value       = ["${aws_instance.kafka-producer.*.public_ip}"]
  value = [for instance in aws_instance.kafka-producer : instance.public_ip]
}
