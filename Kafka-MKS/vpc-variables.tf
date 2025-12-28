#	generic variables defined

#	AWS Region

variable "region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = ""
}

#	Enviornment Variable

variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = ""
}

# Buisness Division

variable "owners" {
  description = "Organization this Infrastructure belongs"
  type        = string
  default     = ""
}

# 	VPC variable defined

variable "name" {
  description = "VPC Name"
  type        = string
  default     = "vpc"
}

#	VPC CIDR Block

variable "cidr" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.0.0.0/16"
}

# 	VPC AZS

variable "azs" {
  description = "A list of Availability zones in the region"
  type        = list(string)
  # default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  default     = ["us-east-1a"]
}

#	VPC Private Subnets

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  # default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  default     = ["10.0.1.0/24"]
}


#	VPC Public Subnets

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  # default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  default     = ["10.0.101.0/24"]
}

# VPC Enable NAT Gateway (True or False)

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = true
}

# VPC Single NAT Gateway (True or False)

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = true
}
