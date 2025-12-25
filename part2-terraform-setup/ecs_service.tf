resource "aws_ecs_service" "this" { 
    name = var.app_name
    cluster = aws_ecs_cluster.this.id
    task_definition = aws_ecs_task_definition.this.arn
    desired_count = 1
    launch_type = "FARGATE"
    enable_execute_command = true
    network_configuration {
        subnets = [aws_subnet.privateSubnetA.id, aws_subnet.privateSubnetB.id]
        security_groups = [aws_security_group.ECSSG.id]
        assign_public_ip = false
      }
    load_balancer {
        target_group_arn = aws_lb_target_group.albTargetGroup.arn
        container_name = var.app_name
        container_port = var.container_port
    }
}
