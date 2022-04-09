resource "aws_lb" "wordpress-alb" {
  name               = "wordpress-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.tcw_sg.id]
  subnets            = data.aws_subnet_ids.available_app_subnet.ids

  enable_deletion_protection = true

  tags = {
    Environment = "DEV"
  }
}