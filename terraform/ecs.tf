#####################
#### ECS cluster ####
#####################

resource "aws_ecs_cluster" "ecs_cluster_01" {
  name = "ecs-cluster-01"
}

##############################
#### ECS Task  Definition ####
##############################
resource "aws_ecs_task_definition" "task_definition_02" {
  family             = "flaskapp-01"
  execution_role_arn = aws_iam_role.iam_role_ecs_task_execution.arn
  container_definitions = jsonencode([
    {
      name      = "flaskapp"
      image     = "${data.aws_ecr_repository.flaskapp.repository_url}:latest"
      essential = true
    },
    {
      name      = "nginx"
      image     = "${data.aws_ecr_repository.nginx.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 80
        }
      ]
    }
  ])

  requires_compatibilities = [
    "FARGATE"
  ]

  network_mode = "awsvpc"
  cpu          = "256"
  memory       = "512"
}

#############################
#### ECS cluster service ####
#############################

resource "aws_ecs_service" "flaskapp_service" {
  name            = "service-flaskapp"
  cluster         = aws_ecs_cluster.ecs_cluster_01.arn
  task_definition = aws_ecs_task_definition.task_definition_02.arn
  desired_count   = 3
  launch_type     = "FARGATE"
  scheduling_strategy                = "REPLICA"
  enable_ecs_managed_tags            = false
  enable_execute_command             = false
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 100
  network_configuration {
    subnets          = [aws_subnet.main_subnet1.id, aws_subnet.main_subnet2.id, aws_subnet.main_subnet3.id]
    security_groups  = [aws_security_group.app_lb_sg.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.app_lb_target_group.arn
    container_name   = "nginx"
    container_port   = 80
  }
  depends_on = [
    aws_ecs_task_definition.task_definition_02
  ]
}
