# resource "aws_security_group" "web_sg" {
#   name        = "${var.environment}-web-sg"
#   description = "Allow HTTP and SSH inbound traffic"
#   vpc_id      = var.vpc_id

#   ingress {
#     description      = "HTTP"
#     from_port        = 80
#     to_port          = 80
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   ingress {
#     description      = "SSH"
#     from_port        = 22
#     to_port          = 22
#     protocol         = "tcp"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name        = "${var.environment}-web-sg"
#     Environment = var.environment
#   }
# }

# resource "aws_instance" "web" {
#   ami                    = var.ami_id
#   instance_type          = var.instance_type
#   subnet_id              = element(var.subnet_ids, 0)
#   vpc_security_group_ids = [aws_security_group.web_sg.id]
#   associate_public_ip_address = true

#   tags = {
#     Name        = "${var.environment}-web-instance"
#     Environment = var.environment
#   }
# }


# resource "aws_instance" "web" {
#   key_name = aws_key_pair.generated_key.key_name
# }




resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = aws_key_pair.generated_key.key_name

  # user_data = var.user_data_file != null ? file(var.user_data_file) : null


  tags = {
    Name        = "${var.environment}-web-server"
    Environment = var.environment
  }
}

resource "aws_security_group" "web_sg" {
  name        = "${var.environment}-web-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
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
