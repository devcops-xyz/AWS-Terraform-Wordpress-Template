resource "aws_lb" "elb" {
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elbsecuritygroup.id]
  subnets            = [data.aws_cloudformation_export.PublicSubnetA.value,
                        data.aws_cloudformation_export.PublicSubnetB.value,
                        data.aws_cloudformation_export.PublicSubnetC.value]

}
resource "aws_alb_listener" "alb_listener" {  
  load_balancer_arn = aws_lb.elb.arn 
  port              = 80
  protocol          = "HTTP"
  
  default_action {    
    target_group_arn = aws_alb_target_group.tg.arn
    type             = "forward"  
  }
}
resource "aws_alb_target_group" "tg" {
  name     = "targetgroup"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.aws_cloudformation_export.vpc_id.value
  health_check {
      healthy_threshold   = 10
      unhealthy_threshold = 2
      interval            = 10
      timeout             = 3
  }
}