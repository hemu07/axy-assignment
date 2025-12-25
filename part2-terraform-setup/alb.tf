resource "aws_lb" "alb" {
    name = "${var.app_name}-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.ALBSG.id]
    subnets = [aws_subnet.publicSubnetA.id, aws_subnet.publicSubnetB.id]
}

resource "aws_lb_listener" "albListener" {
    load_balancer_arn = aws_lb.alb.arn
    port = 80
    protocol = "HTTP"

    default_action {
        type = "forward"
       target_group_arn = aws_lb_target_group.albTargetGroup.arn
    }
}
resource "aws_lb_target_group" "albTargetGroup" {
    port = var.container_port
    protocol = "HTTP"
        vpc_id = aws_vpc.axy-project.id
        target_type = "ip"
        health_check {
    enabled             = true
    path                = "/healthcheck"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}
