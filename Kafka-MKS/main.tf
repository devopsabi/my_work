resource "aws_instance" "kafka-producer" {
  count = 1
  ami   = "ami-03f9680ef0c07a3d1"
  instance_type = "t2.micro"
  key_name = "ec2-user"
  associate_public_ip_address = true
  # vpc_security_group_ids = ["sg-0025136b96875ee79"]
  # security_groups = ["${aws_security_group.allow_ssh.id}"]
  security_groups = ["${aws_security_group.allow_ssh.id}","${aws_security_group.allow_443.id}"]
  # subnet_id     = module.vpc.public_subnets[0]
  subnet_id     = module.vpc.public_subnets[0]
  tags = {
    Name = "Abhishek Alevoor"
    team = "dev"
  }
}


/* resource "aws_iam_instance_profile" "artifact_access_profile" {
  name = "allow-to-access-artifact"
  role = "arn:aws:iam::xxxxxxxxxxx:instance-profile/aa-EC2AccessToCodeAritifactory"
}
*/


resource "aws_security_group" "allow_ssh" {
name = "allow-all-sg"
vpc_id = module.vpc.vpc_id
ingress {
    cidr_blocks = [
      "x.x.x.x/32"
    ]
from_port = 22
    to_port = 22
    protocol = "tcp"
  }
// Terraform removes the default rule
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

// SSM needs 443 to if I use private subnet
resource "aws_security_group" "allow_443" {
name = "allow-all-443-sg"
vpc_id = module.vpc.vpc_id
ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
from_port = 443
    to_port = 443
    protocol = "tcp"
  }

  ingress {
      cidr_blocks = [
        "0.0.0.0/0"
      ]
  from_port = 80
      to_port = 80
      protocol = "tcp"
  }

// Terraform removes the default rule
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}
