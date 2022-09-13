resource "aws_security_group" "apache" {
  name        = "allow_apache"
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
    from_port   = 80
    to_port     = 80
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
    Name = "stage-apache"
  }
}




resource "aws_instance" "apache" {
  ami                    = "ami-0b89f7b3f054b957e"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-08f2d1caebc4f406c"
  vpc_security_group_ids = [aws_security_group.apache.id]
  key_name               = aws_key_pair.testing-damu.id
  user_data              = <<-EOF
              #!/bin/bash
              yum update -y
              yum install httpd -y
              systemctl start httpd
              systemctl enable httpd
              EOF
  tags = {
    Name      = "stage-apache",
    terraform = "true"
  }
}








