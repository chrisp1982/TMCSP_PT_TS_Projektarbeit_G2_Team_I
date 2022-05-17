#!/bin/bash
#######################PreWork
sudo yum update -y
sudo yum install git -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user

############################# Install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.28.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
####################################### PullRepoGit & Install
cd ~
sudo git clone -b main https://github.com/SigNoz/signoz.git
cd signoz/deploy/
sudo git pull
sudo ./install.sh
