provider "aws" {
	region = "ap-south-1"
	access_key = "AKIAU"
	secret_key = "HAZutSKD2CHS"
	}

	variable "ami_id" {
	  default = "ami-021a584b54gfvgr8"
	}

	variable "instance_type" {
	  default = "t2.medium"
	}

	variable "subnet_id" {
	  default = "subnet-0979a0202b3bf4f"
	}

	variable "vpc_id" {
	  default = "vpc-03a4103e71ac6bf4"
	}

	variable "key_name" {
	  default = "Banking-KeyPair"
	}

	variable "instance_names" {
	  default = [
		"jenkins-Ansible-master",
		"jenkins-slave",
		"k8s-master",
		"k8s-worker-1",
		"k8s-worker-2",
		"monitoring-node"
	  ]
	}

	resource "aws_security_group" "allow_all" {
	  name        = "Banking-Finance"
	  description = "Allow all inbound and outbound traffic"
	  vpc_id      = var.vpc_id

	  ingress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	  }

	  egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	  }
	}

	resource "aws_instance" "vm" {
	  count         = length(var.instance_names)
	  ami           = var.ami_id
	  instance_type = var.instance_type
	  subnet_id     = var.subnet_id
	  key_name      = var.key_name

	  vpc_security_group_ids = [aws_security_group.allow_all.id]

	  tags = {
		Name = var.instance_names[count.index]
	  }
	}
