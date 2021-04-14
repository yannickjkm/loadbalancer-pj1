
output "vpcid" {
    value = local.vpcid
}

output "public_sub_id1" {
    value = local.public_subnet_id1
}

output "public_sub_id2" {
    value = local.public_subnet_id2
}

output "private_sub_id" {
    value = local.private_subnet_id
}


output "env_suffix" {
    value = local.env
}


# Local Variables -

locals {
    env = terraform.workspace

    
    # VPC local variable

    vpcid_env = {
        default    = "vpc-d96ab2a0"
        staging    = "vpc-d96ab2a0"
        production = "vpc-d96ab2a0"
    }
    vpcid = lookup(local.vpcid_env, local.env)

    
    # public subnet local variable

    public_subnet_id1_env = {
        default    = "subnet-f9d8cd9f"
        staging    = "subnet-f9d8cd9f"
        production = "subnet-f9d8cd9f"
    }
    public_subnet_id1 = lookup(local.public_subnet_id1_env, local.env)

    # public subnet local variable

    public_subnet_id2_env = {
        default    = "subnet-e22771b8"
        staging    = "subnet-e22771b8"
        production = "subnet-e22771b8"
    }
    public_subnet_id2 = lookup(local.public_subnet_id2_env, local.env)    

    # private subnet local variable

    private_subnet_id_env = {
        default    = "subnet-43e90d08"
        staging    = "subnet-43e90d08"
        production = "subnet-43e90d08"
    }
    private_subnet_id = lookup(local.private_subnet_id_env, local.env)


    

}


