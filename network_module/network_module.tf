

// Calling the shared_vars module

module "shared_vars" {
    source = "../shared_vars"
}

# ======================
# Public Security Group 
# ======================

resource "aws_security_group" "public_sg" {
  name        = "public_sg_${module.shared_vars.env_suffix}"
  description = "Public Security Group for ELB in ${module.shared_vars.env_suffix}" 
  vpc_id      = module.shared_vars.vpcid

  ingress {
    description = "Public Security Group"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public SG"
  }

}


// output the public security group details

output "public_sg_id" {
  value = aws_security_group.public_sg.id
}


# =======================
# Private Security Group
# =======================

resource "aws_security_group" "private_sg" {
  name        = "private_sg_${module.shared_vars.env_suffix}"
  description = "Private Security Group for ELB in ${module.shared_vars.env_suffix}"
  vpc_id      = module.shared_vars.vpcid

  ingress {
    description     = "Ingress ports for VPC1"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Private SG"
  }

}


// output the public security group details

output "private_sg_id" {
  value = aws_security_group.private_sg.id
}