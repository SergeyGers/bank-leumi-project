provider "aws" {
  region = "us-east-1"
}

# Create a Network Load Balancer (NLB)
resource "aws_lb" "nlb" {
  name               = "my-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["subnet-0fdd0dd87a683963c", "subnet-074d384774bfc4b40"]  # Only use the subnet IDs
}

# Create a target group for the NLB
resource "aws_lb_target_group" "tg" {
  name        = "my-target-group"
  port        = 80
  protocol    = "TCP"
  vpc_id      = "vpc-0158e9502a72fe166"
  target_type = "instance"
}

# Attach the two EC2 instances to the target group
resource "aws_lb_target_group_attachment" "tg_attachment_1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = "i-0f5566fb146579346"  # Direct instance ID
  port             = 80  # Application's port
}

resource "aws_lb_target_group_attachment" "tg_attachment_2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = "i-0c10b10d32a315c59"  # Direct instance ID
  port             = 80  # Application's port
}

# Create a listener for the NLB on port 80
resource "aws_lb_listener" "nlb_listener" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80  # Expose app on port 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

# Create a security group rule to allow traffic from the NLB to the instances on port 80
resource "aws_security_group_rule" "allow_nlb_traffic" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = "sg-02a18275ff7e54631"  # Existing security group for instances

  cidr_blocks = ["192.168.0.0/16"]  
}

