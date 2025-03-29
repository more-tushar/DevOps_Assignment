provider "aws" {
  region = "region"  
}

resource "aws_instance" "lamp_server" {
  ami           = "ami-  
  instance_type = "t2.micro"
  key_name      = "your-name"  

  security_groups = []

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install apache2 -y
    sudo systemctl start apache2
    sudo systemctl enable apache2

    sudo apt install mysql-server -y
    sudo systemctl start mysql
    sudo systemctl enable mysql

    sudo apt install php libapache2-mod-php php-mysql -y
    sudo systemctl restart apache2
  EOF

  tags = {
    Name = "LAMP-Server"
  }
}

resource "aws_security_group" "lamp_sg" {
  name        = "lamp_sg"
  description = "Allow HTTP, HTTPS, and SSH access"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

