resource "aws_instance" "web" {
  ami           = "ami-02541b8af977f6cdd"
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}