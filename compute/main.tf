# --- compute/main.tf ---

# To grap the most recent windows server 
data "aws_ami" "windows" {
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["801119661308"]
}
/*
resource "random_id" "ad_node_id" {
  byte_length = 2
  count       = var.instance_count
}*/


resource "aws_instance" "ad_node" {
  count         = var.instance_count
  instance_type = var.instance_type
  ami           = data.aws_ami.windows.id

  tags = var.tags

  key_name               = var.key_name
  vpc_security_group_ids = [var.public_sg]
  subnet_id              = var.public_subnets[count.index]

  root_block_device {
    volume_size = var.vol_size
  }


  user_data = var.user_data

# This sleep/pause is necessary for all commands in user_data to be implemented
  provisioner "local-exec" {
    command = "sleep 420"
  }


  provisioner "local-exec" {
    command = "ansible-playbook  -i ${aws_instance.ad_node[0].public_ip},  dc.yml -vvv"

  }
}

