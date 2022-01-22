provider "aws" {
  version    = "~> 2.7"
  access_key = var.access_key # from variables.tf
  secret_key = var.secret_key # from variables.tf
  region     = var.region     # from variables.tf
}

resource "aws_security_group" "ec2_minecraft" {
  name        = "ec2_minecraft"
  description = "allow users to connect to Minecraft server"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.user_ip_address}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "ec2_minecraft_server" {
  ami                    = "ami-05cafdf7c9f772ad2"
  instance_type          = "t2.medium"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_minecraft.id]
  tags = {
    Name = "ec2_minecraft_server"
  }

  # run script on machine
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = aws_instance.ec2_minecraft_server.public_ip
      agent       = false
      private_key = file("${var.pem_file_location}")
    }
    inline = [
        "sudo rpm --import https://yum.corretto.aws/corretto.key",
        "sudo curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo",
        "sudo yum install -y java-17-amazon-corretto-devel.x86_64",
        "sudo wget -O /home/ec2-user/server.jar https://launcher.mojang.com/v1/objects/125e5adf40c659fd3bce3e66e67a16bb49ecc1b9/server.jar",
        "sudo /usr/bin/java -Xmx1024M -Xms1024M -jar /home/ec2-user/server.jar nogui",
        # above version will crash because the eula.txt file is not there
        "sudo sed -i 's/false/true/g' /home/ec2-user/eula.txt",
        "sudo echo 'cat /home/ec2-user/eula.txt'",
        "sudo cat /home/ec2-user/eula.txt",
        #"sudo sh /home/ec2-user/start_server.sh",
        "nohup sudo /usr/bin/java -Xmx2048M -Xms2048M -jar /home/ec2-user/server.jar nogui &",
        "sudo sleep 1"
    ]
  }
}


# these have to be included in output"
output "aws_instance_ec2_minecraft_server_public_ip" {
  value = aws_instance.ec2_minecraft_server.public_ip
}
