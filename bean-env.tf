resource "aws_elastic_beanstalk_environment" "teachua-beanstalk-env" {
  name                = "teachua-env"
  application         = data.aws_elastic_beanstalk_application.existing_teachua_app.name
  # application         = aws_elastic_beanstalk_application.teachua-app.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.3.2 running Corretto 17"
  tier                = "WebServer"
  # version_label       = aws_elastic_beanstalk_application_version.tf-eb-app-version.id
  cname_prefix        = "teachua-app"

  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = module.vpc.vpc_id
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = "true"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", [module.vpc.public_subnets[0], module.vpc.public_subnets[1], module.vpc.public_subnets[2]])
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", [module.vpc.public_subnets[0], module.vpc.public_subnets[1], module.vpc.public_subnets[2]])
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.ec2_instance_profile.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.medium"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "RootVolumeType"
    value     = "gp2"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "RootVolumeSize"
    value     = "10"
  }

  #setting {
  #  namespace = "aws:autoscaling:launchconfiguration"
  #  name      = "EC2KeyName"
  #  value     = aws_key_pair.teachua_app_key.key_name
  #}

  # value     = aws_key_pair.teachua_app_key.key_name

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = aws_security_group.teachua-beanstalk-Instance.id
  }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "SecurityGroups"
    value     = aws_security_group.teachua-beanstalk-app-elb-sg.id
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Availability Zones"
    value     = "Any 3"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "2"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckPath"
    value     = "/"
  }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "enhanced"
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = "AllAtOnce"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "MatcherHTTPCode"
    value     = "200"
  }

    setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "SERVER_PORT"
    value     = "5000"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DATASOURCE_URL"
    value     = var.datasource_url
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DATASOURCE_USER"
    value     = var.datasource_user
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DATASOURCE_PASSWORD"
    value     = var.datasource_password
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "JDBC_DRIVER"
    value     = var.jdbc_driver
  }
  
  depends_on = [
    aws_security_group.teachua-beanstalk-app-elb-sg, 
    aws_security_group.teachua-beanstalk-Instance, 
    aws_security_group.teachua_app_rds_sg
  ]
}

terraform {
  backend "s3" {
    bucket = "teachua-bucket-new"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

