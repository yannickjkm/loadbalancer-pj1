

// call the local variables from the shared_vars module
module "shared_vars" {
    source = "../shared_vars"
}

// Adding variable for Private SG
variable "private_sg_id" {}


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

}


// Launch Configuration

resource "aws_launch_configuration" "sampleapp-lc" {
  name          = "sampleapp-lc-${module.shared_vars.env_suffix}"
  image_id      = local.amiid
  instance_type = local.instancetype
  key_name      = local.keypair
  user_data     = file("../assets/userdata.txt")
  security_groups = [ var.private_sg_id ]
}




