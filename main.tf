provider "aws" {
    region  = "eu-west-1"
    profile = "sawa"
}

// Calling the network module

module "network_module" {
    source = "./network_module"
}


// calling the loadbalancer module

module "loadbalancer_module" {
    source       = "./loadbalancer_module"
    public_sg_id = module.network_module.public_sg_id
}


// Calling the autoscaling group module

module "autoscaling_module" {
    source        = "./autoscaling_module"
    private_sg_id = module.network_module.private_sg_id
    target_group  = module.loadbalancer_module.target_group
}