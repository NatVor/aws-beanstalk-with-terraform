# Security Group for Beanstalk Load Balancer
resource "aws_security_group" "teachua-beanstalk-app-elb-sg" {
  name        = "teachua-beanstalk-elb-sg"
  description = "Security group for beanstalk load balancer"
  vpc_id      = module.vpc.vpc_id

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Allow HTTP (port 80) from any IP (public access to the load balancer)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Beanstalk_ELB_SG"
  }
}

# Security Group for Beanstalk EC2 Instances
resource "aws_security_group" "teachua-beanstalk-instance-sg" {
  name        = "teachua-beanstalk-instance-sg"
  description = "Security group for beanstalk EC2 instance"
  vpc_id      = module.vpc.vpc_id

  # Allow all outbound traffic (adjust based on your needs)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # Allow SSH access (port 22) only from specific trusted IPs
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress: Allow HTTP (port 80) access but restrict it to the Load Balancer's Security Group
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.teachua-beanstalk-app-elb-sg.id]  # Allow only from the ELB SG
  }

  tags = {
    Name = "Beanstalk_instance_SG"
  }
}

# Security Group for RDS (Database) Instance
resource "aws_security_group" "teachua-app-rds-sg" {
  name        = "teachua-application-database-sg"
  description = "Security group for database connection"
  vpc_id      = module.vpc.vpc_id

  # Egress: Allow all outbound traffic (required for RDS in most cases, can be restricted based on needs)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Ingress: Allow MySQL access (port 3306) only from Beanstalk EC2 Instances (Security Group)
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.teachua-beanstalk-instance-sg.id]  # Allow only from the EC2 instances SG
  }

  tags = {
    Name = "RDS_instance_SG"
  }
}
