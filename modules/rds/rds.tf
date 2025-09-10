resource "aws_db_subnet_group" "db" {
  name        = "db-subnet-group"
  subnet_ids  = var.subnets
  description = "Subnet group for Postgres RDS instance"
  tags = {
    Environment = "lesson-7"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  vpc_id      = var.vpc_id
  description = "Postgres access"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.allowed_cidr_block]
    description = "EKS nodes to RDS"
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Environment = "lesson-7"
  }
}

resource "aws_db_instance" "postgres" {
  identifier             = "postgres"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "16.9"
  instance_class         = "db.t3.micro"
  username               = var.postgres_username
  password               = var.postgres_password
  db_name                = var.postgres_db_name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.db.name
  availability_zone      = var.availability_zone
  multi_az               = false
  publicly_accessible    = false
  skip_final_snapshot    = true
  tags = {
    Environment = "lesson-7"
  }
}
