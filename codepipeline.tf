provider "aws" {
  region = "us-east-1"  # regiao
}

# Criando role do IAM para o CodePipeline
resource "aws_iam_role" "codepipeline_role" {
  name = "codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codepipeline.amazonaws.com"
        }
      }
    ]
  })
}

# Anexando política do IAM a role do CodePipeline
resource "aws_iam_role_policy_attachment" "codepipeline_policy_attachment" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipeline_FullAccess"
}

# Criando cluster do ECS
resource "aws_ecs_cluster" "cluster" {
  name = "meu-cluster-ecs"
}

# Criando definição da tarefa do ECS
resource "aws_ecs_task_definition" "task_definition" {
  family                = "minha-task-definition"
  network_mode          = "awsvpc"
  container_definitions = jsonencode([
    {
      name      = "meu-container"
      image     = "minha-imagem"  # Substitua pela URL correta da imagem
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
}

# Criando target group do load balancer
resource "aws_lb_target_group" "target_group" {
  name        = "meu-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "vpc-093b125eb5f5fa24b"  # ID da VPC 

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold  = 2
    unhealthy_threshold = 2
    protocol           = "HTTP"
  }
}

# Criando load balancer
resource "aws_lb" "load_balancer" {
  name               = "meu-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_security_group.id]
  
  subnets            = [
    "subnet-00d9bd50e8e3673d8",
    "subnet-0f7307281e55df317"
  ]  # IDs das subnets
}

# Criando listener do load balancer
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

# Criando serviço do ECS
resource "aws_ecs_service" "service" {
  name            = "meu-servico-ecs"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1

  # Configurando load balancer
  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "meu-container"
    container_port   = 80
  }

  # Configurando rede
  network_configuration {
    subnets          = [
      "subnet-00d9bd50e8e3673d8",
      "subnet-0f7307281e55df317"
    ]  # IDs das subnets
    security_groups  = [aws_security_group.lb_security_group.id]
    assign_public_ip = false  # "ENABLED" para habilitar IPs públicos
  }

  # Outras configurações do serviço do ECS...
}

# Criando grupo de segurança para o load balancer
resource "aws_security_group" "lb_security_group" {
  name_prefix   = "lb-sg"
  vpc_id        = "vpc-093b125eb5f5fa24b"  # id da vpc

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permitindo acessos públicos na porta 80
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Permitir todo o tráfego de saída
    cidr_blocks = ["0.0.0.0/0"]  # Permitir a saída para qualquer IP
  }
}
