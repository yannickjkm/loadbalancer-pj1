

// call the local variables from the shared_vars module
module "shared_vars" {
    source = "../shared_vars"
}

// Adding variable for Private SG
variable "private_sg_id" {}

// Adding variable for target group 
variable "target_group" {}

locals {
    env = terraform.workspace

    # amiid

    amiid_env = {
        default    = "ami-0ffea00000f287d30"
        staging    = "ami-0ffea00000f287d30"
        production = "ami-0ffea00000f287d30"
    }
    amiid = lookup(local.amiid_env, local.env)

    
    # instancetype

    instancetype_env = {
        default    = "t2.micro"
        staging    = "t2.micro"
        production = "t2.micro"
    }
    instancetype = lookup(local.instancetype_env, local.env)


    # keypair

    keypair_env = {
        default    = "sawa1ec2"
        staging    = "sawa1ec2"
        production = "sawa2ec2"
    }
    keypair = lookup(local.keypair_env, local.env)


    # AutoScaling Group Desired size (environment)

    asgdesired_env = {
        default    = "1"
        staging    = "1"
        production = "2"
    }
    asgdesired = lookup(local.asgdesired_env, local.env)    

    # AutoScaling Group minimum size (environment)

    asgmin_env = {
        default    = "1"
        staging    = "1"
        production = "2"
    }
    asgmin = lookup(local.asgmin_env, local.env) 


    # AutoScaling Group maximum size (environment)

    asgmax_env = {
        default    = "2"
        staging    = "2"
        production = "4"
    }
    asgmax = lookup(local.asgmax_env, local.env) 

}


// Launch Configuration

resource "aws_launch_configuration" "sampleapp-lc" {
  name            = "sampleapp-lc-${module.shared_vars.env_suffix}"
  image_id        = local.amiid
  instance_type   = local.instancetype
  key_name        = local.keypair
  user_data       = file("../assets/userdata.txt")
  security_groups = [ var.private_sg_id ]
}



// Adding AutoScaling resource

resource "aws_autoscaling_group" "sampleapp-asg" {
  name                 = "sampleapp-asg-${module.shared_vars.env_suffix}"
  max_size             = local.asgmax
  min_size             = local.asgmin
  desired_capacity     = local.asgdesired
  launch_configuration = aws_launch_configuration.sampleapp-lc.name
  vpc_zone_identifier  = [module.shared_vars.public_sub_id1]
  target_group_arns    = [var.target_group ]

  tags = [
      {
        "key"                 = "Name"
        "value"               = "SampleApp-${module.shared_vars.env_suffix}"
        "propagate_at_launch" = true
      },
      {
        "key"                 = "Environment"
        "value"               = module.shared_vars.env_suffix
        "propagate_at_launch" = true
      }
    ]
    
}
