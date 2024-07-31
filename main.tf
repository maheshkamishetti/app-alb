resource "aws_lb" "app_alb" {
  name               = "${local.name}-${var.tags.Component}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_ssm_parameter.app_alb_sg_id.value]
  subnets            = split(",", data.aws_ssm_parameter.public_subnet_ids.value)

  #enable_deletion_protection = true

  tags = merge(
    var.common_tags,
    var.tags
  )
}

resource "aws_lb_target_group" "app-tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_ssm_parameter.vpc_id.value
  target_type = "instance"
  deregistration_delay = 60

  health_check {
      healthy_threshold   = 2
      interval            = 10
      unhealthy_threshold = 3
      timeout             = 5
      path                = "/app-tg"
      port                = 80
      matcher = "200-299"
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"
  

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn
  }
}

resource "aws_lb_target_group_attachment" "app_instance" {
  target_group_arn = aws_lb_target_group.app-tg.arn
  target_id        = data.aws_ssm_parameter.instance_id.value
  port             = 80
}

