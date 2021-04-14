


# Input the public security group from the network module
variable public_sg_id {} 


# call the local variables from the shared_vars module
module "shared_vars" {
    source = "../shared_vars"
}

# Application loadbalancer resource

resource "aws_lb" "sampleapp-alb" {
  name               = "sampleapp-alb-${module.shared_vars.env_suffix}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_sg_id]
  subnets            = [module.shared_vars.public_sub_id1,module.shared_vars.public_sub_id2]

  enable_deletion_protection = true


  tags = {
    Environment = module.shared_vars.env_suffix
  }
}