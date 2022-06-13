# ---root/locals.tf --- 

#locals {
#  vpc_cidr = "30.0.0.0/16"
#}

locals {
  vpc_cidr = "30.0.0.0/16"
  security_groups = {
    public = {
      name        = "public_sg"
      description = "public access"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
        rdp = {
          from        = 3389
          to          = 3389
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
        winrm = {
          from        = 5985
          to          = 5985
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
        http = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
  }
  tags ={
    Name = "addc"
  } 

  private_key_path = "~/.ssh/lab.pem" # to be changed
}

#locals {
#  tags ={
#    Name = "addc"
#  } 
#}