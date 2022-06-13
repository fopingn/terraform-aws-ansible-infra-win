# --- compute/main.tf ---

data "aws_ami" "windows" {
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
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

  connection {
    host     = self.public_ip
    type        = "ssh"
    user        = local.ssh_user
    private_key = file(local.private_key_path)
    #type     = "winrm"
    #user     = var.windows_user
    #password = var.windows_password
    #timeout  = "5m"
  }

  provisioner "local-exec" {
    command = "sleep 180"
  }


  /*provisioner "remote-exec" {
    inline = [
      "netsh interface ip set dns name=\"Ethernet\" static 172.31.24.1"
    ]
  }*/

  provisioner "remote-exec" {
    inline = [
      "powershell.exe -Command \"Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False\""
    ]
  }

#  provisioner "file" {
#    source      = "files/ConfigureRemotingForAnsible.ps1"
#    destination = "C:/Windows/Temp/ConfigureRemotingForAnsible.ps1"
#  }
#
#  provisioner "remote-exec" {
#    inline = [
#      "powershell.exe  C:\\Windows\\Temp\\ConfigureRemotingForAnsible.ps1"
#    ]
#  }
  # local execution of the ansible playbook to configure the domain controller 
  provisioner "local-exec" {
    command = "ansible-playbook dc.yml -e \"variable_host=${aws_instance.ad_node[0].public_ip}\"  -vvv"
    #command = "ansible-playbook  dc.yml -vvv"

  }
}

