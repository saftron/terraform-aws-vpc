resource "aws_instance" "web" {
  ami             = "ami-0022f774911c1d690"
  instance_type   = "t2.micro"
  #security_groups = ["aws_security_group.tf_sg.id"]
  key_name        = "training"
  tags = {
    Name = "HelloWorld"
  }
  /*user_data = <<EOF
#! /bin/bash
yum update -y
yum install -y httpd
systemctl start httpd && systemctl enable httpd
echo “Hello World from $(hostname -f)” > /var/www/html/index.html
EOF*/

  user_data = file("script.sh")

}

resource "aws_security_group" "tf_sg" {
  name        = "Security group using terraform"
  description = "Security group using terraform"
  vpc_id      = "vpc-0b98a050f32fec47f"

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "tf_sg"
  }
}
