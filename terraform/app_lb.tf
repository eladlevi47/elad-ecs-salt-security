###################################
#### Application LoadBalancer  ####
###################################

resource "aws_lb" "app_lb" {
  name               = "app-lb-terraform"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_lb_sg.id]
  subnets            = [aws_subnet.main_subnet1.id, aws_subnet.main_subnet2.id, aws_subnet.main_subnet3.id]

  enable_deletion_protection = false
}

###################################
#### LoadBalancer TargetGroup  ####
###################################

resource "aws_lb_target_group" "app_lb_target_group" {
  name        = "app-lb-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main_vpc.id
  health_check {
    protocol = "HTTP"
    path     = "/v1/health"
    interval = 30
  }
}

##########################
#### aws_lb_listener  ####
##########################

resource "aws_lb_listener" "lb_listener_http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_lb_target_group.app_lb_target_group.id
    type             = "forward"
  }
}
