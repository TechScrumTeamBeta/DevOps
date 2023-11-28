provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

resource "aws_instance" "jenkins_master" {
  ami           = var.jenkins_master_ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id[0]
  key_name      = "keypaircicd"  

 lifecycle {
    ignore_changes = [public_ip]
  }
}


resource "aws_instance" "jenkins_slave" {
  ami           = var.jenkins_slave_ami
  instance_type = var.instance_type
  subnet_id     = var.subnet_id[1]
  key_name      = "cicdkeypair"  

 lifecycle {
    ignore_changes = [public_ip]
  }
  
}

resource "aws_s3_bucket" "jenkins_bucket" {
  bucket = var.jenkins_bucket_name
}


resource "aws_s3_bucket_versioning" "jenkins_bucket_versioning" {
  bucket = aws_s3_bucket.jenkins_bucket.id

  versioning_configuration {
    status = var.jenkins_bucket_versioning_enabled ? "Enabled" : "Suspended"
}
}

resource "aws_security_group_rule" "jenkins_tcp_8080" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_default_security_group.default.id
}


resource "aws_security_group_rule" "jenkins_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_default_security_group.default.id
}



resource "aws_default_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_vpc" "default" {
  default = true
}
