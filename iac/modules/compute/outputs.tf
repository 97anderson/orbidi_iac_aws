# ECS infrastructure creation output and load balancing

output "alb_dns_name" {
  value = aws_lb.app.dns_name
}

output "asg_name" {
  value = aws_autoscaling_group.ecs.name
}


