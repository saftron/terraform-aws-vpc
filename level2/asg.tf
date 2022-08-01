resource "aws_launch_configuration" "web" {
  name_prefix                 = "web-"
  image_id                    = data.aws_ami.amazonlinux.id
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.tf_sg.id]
  associate_public_ip_address = true
  user_data                   = file("script.sh")
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  name             = "${aws_launch_configuration.web.name}-asg"
  min_size         = 1
  desired_capacity = 2
  max_size         = 3

  health_check_type    = "ELB"
  load_balancers       = [aws_lb.jag-test-lb.name]
  launch_configuration = aws_launch_configuration.web.name
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"
  vpc_zone_identifier = [data.terraform_remote_state.level1.outputs.public_subnet_id[0], data.terraform_remote_state.level1.outputs.public_subnet_id[1]]
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "web"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "web_policy_up" {
  name                   = "web_policy_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web.name
}

resource "aws_autoscaling_policy" "web_policy_down" {
  name                   = "web_policy_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.web.name
}
