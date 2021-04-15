


// Input the public security group from the network module
variable public_sg_id {} 


// call the local variables from the shared_vars module
module "shared_vars" {
    source = "../shared_vars"
}

// Application loadbalancer resource

resource "aws_lb" "sampleapp-alb" {
  name               = "sampleapp-alb-${module.shared_vars.env_suffix}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_sg_id]
  subnets            = [module.shared_vars.public_sub_id1,module.shared_vars.public_sub_id2]

  enable_deletion_protection = false


  tags = {
    Environment = module.shared_vars.env_suffix
  }
}



// Adding Target groups

resource "aws_lb_target_group" "sampleapp-http-tg" {
  name     = "sampleapp-http-tg-${module.shared_vars.env_suffix}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.shared_vars.vpcid
}



// Adding Listener

resource "aws_lb_listener" "http-listener-80" {
  load_balancer_arn = aws_lb.sampleapp-alb.arn
  port              = "80"
  protocol          = "HTTP"
  

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sampleapp-http-tg.arn
  }
}