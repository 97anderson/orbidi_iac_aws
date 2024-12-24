# Load Balancer
resource "aws_lb" "app" {
  name               = "${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.alb_subnets
  enable_deletion_protection = false
  tags = {
    Environment = var.environment
    Name        = "${var.environment}-alb"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

# Listener para HTTP
#resource "aws_lb_listener" "http" {
#  load_balancer_arn = aws_lb.app.arn
#  port              = 80
#  protocol          = "HTTP"
#
#  default_action {
#    type = "redirect"
#
#    redirect {
#      protocol = "HTTPS"
#      port     = "443"
#      status_code = "HTTP_301"
#    }
#  }
#}

# Listener para HTTPS
#resource "aws_lb_listener" "https" {
#  load_balancer_arn = aws_lb.app.arn
#  port              = 443
#  protocol          = "HTTPS"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"
#  certificate_arn   = var.ssl_certificate_arn
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.app.arn
#  }
#}

# Target Group
resource "aws_lb_target_group" "app" {
  name        = "${var.environment}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = {
    Environment = var.environment
    Name        = "${var.environment}-tg"
  }
}

# Security Group para ALB
resource "aws_security_group" "alb" {
  vpc_id = var.vpc_id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group para ECS
resource "aws_security_group" "ecs" {
  vpc_id = var.vpc_id
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Key Pair
resource "aws_key_pair" "custom_key" {
  key_name   = "ecs-key-local"
  public_key = file(var.ssh_key_path)
}

# ECS Cluster
resource "aws_ecs_cluster" "app" {
  name = "${var.environment}-ecs-cluster"
  tags = {
    Environment = var.environment
    Name        = "${var.environment}-ecs-cluster"
  }
}

# Task Definition
resource "aws_ecs_task_definition" "app" {
  family                = "${var.environment}-ecs-service"
  container_definitions = jsonencode([
    {
      name      = "${var.environment}-ecs-service"
      image     = var.ecr_image_url
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
  network_mode          = "bridge"
  execution_role_arn    = aws_iam_role.ecs_task_execution.arn
  tags = {
    Environment = var.environment
    Name        = "${var.environment}-ecs-service"
  }
}

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.environment}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_trust.json
}

data "aws_iam_policy_document" "ecs_task_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_service" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_logs_attach" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# ECS Capacity Provider
resource "aws_ecs_capacity_provider" "ec2" {
  name = "${var.environment}-ec2-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 75
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 10
    }
  }

  tags = {
    Environment = var.environment
  }
}

# ECS Cluster Capacity Providers
resource "aws_ecs_cluster_capacity_providers" "app" {
  cluster_name = aws_ecs_cluster.app.name

  capacity_providers = [aws_ecs_capacity_provider.ec2.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ec2.name
    weight            = 1
    base              = 1
  }
}

resource "aws_iam_role" "ecs_service_role" {
  name               = "ecs-service-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_service_trust.json
}

data "aws_iam_policy_document" "ecs_service_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_service_fullaccess" {
  role       = aws_iam_role.ecs_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs_ec2_fullaccess" {
  role       = aws_iam_role.ecs_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

# ECS Service
resource "aws_ecs_service" "app" {
  name            = "${var.environment}-ecs-service"
  cluster         = aws_ecs_cluster.app.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "EC2"
  desired_count   = 0
  iam_role        = aws_iam_role.ecs_service_role.arn

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app.arn
    container_name   = "${var.environment}-ecs-service"
    container_port   = 80
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_launch_template" "ecs" {
  name          = "${var.environment}-ecs-lt"
  instance_type = var.instance_type
  key_name      = aws_key_pair.custom_key.key_name  
  image_id      = var.image_id

  network_interfaces {
    security_groups            = [aws_security_group.ecs.id]
    associate_public_ip_address = false
  }

  tags = {
    Environment = var.environment
    Name        = "${var.environment}-ecs-lt"
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "ecs" {
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  vpc_zone_identifier  = var.private_subnets
  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }
  target_group_arns = [aws_lb_target_group.app.arn]
  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }
}
