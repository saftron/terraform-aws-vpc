resource "aws_lb" "jag-test-lb" {
  name               = "my-test-lb"
  internal           = false
  load_balancer_type = "application"
  ip_address_type    = "ipv4"
  security_groups    = [aws_security_group.tf_sg.id]
  subnets            = [data.terraform_remote_state.level1.outputs.public_subnet_id[0], data.terraform_remote_state.level1.outputs.public_subnet_id[1]]

  enable_deletion_protection = false

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

  health_check {
    healthy_threshold   = "3"
    interval            = "20"
    unhealthy_threshold = "2"
    timeout             = "10"
    path                = "/"
    port                = "80"
    protocol            = "HTTP"
  }
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.jag-alb-tg.arn
  target_id        = aws_instance.web.id
  port             = 80
}

resource "aws_lb_listener" "lb_listener_http" {
  load_balancer_arn = aws_lb.jag-test-lb.id
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.jag-alb-tg.id
    type             = "forward"
  }
}
