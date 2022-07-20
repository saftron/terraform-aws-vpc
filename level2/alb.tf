resource "aws_lb" "jag-test-lb" {
  name               = "my-test-lb"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  subnets            = ["data.terraform_remote_state.level1.outputs.public_subnet_id[0]", "data.terraform_remote_state.level1.outputs.public_subnet_id[1]"]

  enable_deletion_protection = true

  tags = {
    Name = "my-test-alb"
  }
}

resource "aws_lb_target_group" "jag-alb-tg" {
  name        = "jag-alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id
  target_type = "instance"
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.jag-alb-tg.arn
  target_id        = aws_instance.web.id
  port             = 80
}
