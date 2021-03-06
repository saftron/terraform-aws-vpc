data "aws_ami" "amazonlinux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["137112412989"]
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazonlinux.id
  instance_type = "t2.micro"
  subnet_id     = data.terraform_remote_state.level1.outputs.public_subnet_id[0]

  vpc_security_group_ids = [
    aws_security_group.tf_sg.id
  ]

  user_data = file("script.sh")

  tags = {
    Name = "${var.env_code}-web"
  }
}

resource "aws_key_pair" "ubuntu_key" {
  key_name   = "ec2-key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ec2-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "ec2-key"
}

resource "aws_security_group" "tf_sg" {
  name        = "${var.env_code}-default"
  description = "The ID of the VPC that the instance security group belongs to."
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_public_ip]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf_sg\n\n"
  }
}
