# AWS WITH (Elastic Beanstalk) TERRAFORM

## Using Terraform to create a fully functional VPC, RDS and Elastic Beanstalk to deploy a JAVA SPRING BOOT application.

## Steps

Make the script executable: chmod +x install_tools.sh

Run the script to install the tools: ./install_tools.sh

Verify the installation by checking the versions of the installed tools: aws --version; terraform -v

Connect to AWS: aws configure

Creation new app version:
aws elasticbeanstalk create-application-version --application-name teachua-app --version-label v1.0 --source-bundle S3Bucket=teachua-bucket-new,S3Key=dev.war

Usefull commands: 
aws elasticbeanstalk update-environment --environment-name teachua-env --version-label v1.0

aws elasticbeanstalk describe-environments --environment-names teachua-env (Must be "Ready".)

aws elasticbeanstalk request-environment-info --environment-name teachua-env --info-type tail 
aws elasticbeanstalk retrieve-environment-info --environment-name teachua-env --info-type tail 

aws elasticbeanstalk create-application-version \
  --application-name teachua-app \
  --version-label v2.1 \
  --source-bundle S3Bucket="teachua-bucket-new",S3Key="dev3.war"

aws elasticbeanstalk list-available-solution-stacks

ssh -i "/home/codespace/.ssh/web02_key" ec2-user@ec2-3-239-226-34.compute-1.amazonaws.com

mysql -h teachua-db.ctegro5wnfvo.us-east-1.rds.amazonaws.com -u user -p

EB install;
sudo apt update
sudo apt install python3-pip
pip3 install awsebcli --upgrade --user
pip3 --version
eb --version

aws elasticbeanstalk update-environment \
  --environment-name teachua-env \
  --version-label v2.1

sudo yum update -y
sudo yum install https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
sudo yum install mysql-community-client --nogpgcheck -y

cd /var/app/current

cd /var/log/nginx/ - logs

cat /etc/nginx/nginx.conf - config-file

mysql -u user -p -h teachua-db.cte.....us-east-1.rds.amazonaws.com teachua < import.sql
