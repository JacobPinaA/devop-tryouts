# Recurso para la instancia EC2
resource "aws_instance" "microEc2" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  key_name      = "llave-ssh" # Cambiar esto a tu clave SSH
  subnet_id     =  var.subnet_id

  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 30
  }

  tags = {
    Name = "micro-ec2"
  }
}

# Recurso para la IP elástica
resource "aws_eip" "eip" {
  instance = aws_instance.microEc2.id
}

# Recurso para el Application Load Balancer (ALB)
resource "aws_lb" "alb" {
  name               = "app-alb"
  internal           = false 
  load_balancer_type = "application"
  enable_deletion_protection = false

  enable_http2 = true

  subnets = [var.subnet_id]

  tags = {
    Name = "app-alb"
  }
}

# Listener HTTP
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type    = "text/plain"
      status_code     = "200"
      content         = "OK"
    }
  }
}

# Listener HTTPS
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  certificate_arn   = var.cert_arn

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type    = "text/plain"
      status_code     = "200"
      content         = "OK"
    }
  }
}

resource "aws_security_group" "sgalb" {
  name_prefix = "sg-alb"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

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
}


# Recurso para limitar por método POST en el ALB
resource "aws_lb_listener_rule" "rule" {
  listener_arn = aws_lb.alb.arn
  action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "OK"
    }
  }
  condition {
    host_header {
      values = ["*"]
    }
    http_request_method {
      values = ["POST"]
    }
  }
}

# Asociar el grupo de seguridad a la instancia EC2
resource "aws_network_interface_sg_attachment" "attach" {
  security_group_id    = aws_security_group.sgalb.id
  network_interface_id = aws_instance.microEc2.network_interface_ids[0]
}
