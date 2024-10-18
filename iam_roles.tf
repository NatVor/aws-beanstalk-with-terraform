# Роль для EC2
resource "aws_iam_role" "ec2_role" {
  name = "ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

# Політика для EC2
resource "aws_iam_policy" "ec2_policy" {
  name        = "ec2-deployment-policy"
  description = "Policy for EC2 instance to deploy applications"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::teachua-bucket-new",
          "arn:aws:s3:::teachua-bucket-new/*"
        ]
      },
      {
        Action = [
          "elasticbeanstalk:DescribeEnvironments",
          "elasticbeanstalk:CreateEnvironment",
          "elasticbeanstalk:UpdateEnvironment",
          "elasticbeanstalk:TerminateEnvironment"
        ]
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = "elasticbeanstalk:*"
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = "logs:*"
        Effect = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:GetLogEvents",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = "rds-db:connect",
        Effect = "Allow",
        Resource = "arn:aws:rds-db:*:*:dbuser/*/*"
      }
    ]
  })
}

# Приєднання політики до ролі EC2
resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

# Профіль інстансу для EC2
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "teachua-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# Роль для RDS
resource "aws_iam_role" "rds_custom_role" {
  name = "CustomRDSRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "rds.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
}

# Політики для доступу до RDS
resource "aws_iam_role_policy_attachment" "rds_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

# Приєднання політики адміністратора до ролі EC2
resource "aws_iam_role_policy_attachment" "admin_access" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Роль для Beanstalk
resource "aws_iam_role" "beanstalk_role" {
  name = "beanstalk-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "elasticbeanstalk.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

# Приєднання політики адміністратора до ролі Beanstalk
resource "aws_iam_role_policy_attachment" "beanstalk_admin_access" {
  role       = aws_iam_role.beanstalk_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Профіль для Beanstalk
resource "aws_iam_instance_profile" "beanstalk_instance_profile" {
  name = "beanstalk-instance-profile"
  role = aws_iam_role.beanstalk_role.name
}