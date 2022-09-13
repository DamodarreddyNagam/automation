resource "aws_security_group" "cicd" {
  name        = "allow_cicd"
  description = "Allow apache inbound traffic"
  vpc_id      = "vpc-0c8e683e7e965516e"

  ingress {
    description = "ssh from admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "for alb end"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]


  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "stage-cicd"
  }
}




resource "aws_instance" "cicd" {
  ami                    = "ami-0b89f7b3f054b957e"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-08f2d1caebc4f406c"
  vpc_security_group_ids = [aws_security_group.cicd.id]
  key_name               = aws_key_pair.testing-damu.id
  user_data              = <<-EOF
               #!/bin/bash
               yum update -y
               sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
 sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
 yum install epel-release # repository that provides 'daemonize'
 amazon-linux-extras install epel
 amazon-linux-extras install java-openjdk11 -y
#  yum install java-11-openjdk-devel
 yum install jenkins -y
 systemctl start jenkins
 systemctl enable jenkins
  EOF

  tags = {
    Name      = "stage-cicd",
    terraform = "true"
  }
}