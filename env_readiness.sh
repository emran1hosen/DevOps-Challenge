#!/bin/bash
sudo apt-get update
sudo apt-get install git -y
cd /home/ubuntu
sudo git clone https://github.com/emran1hosen/DevOps-Challenge.git
sudo chown -R ubuntu:ubuntu DevOps-Challenge
sudo apt-get update
sudo apt install curl -y
sudo apt-get install php -y
sudo apt-get install php7.4
sudo apt-get install php7.4-mbstring php7.4-mysql php7.4-xml php7.4-curl php7.4-json php7.4-zip -y
cd /home/ubuntu
export COMPOSER_HOME="$HOME/.config/composer"
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer
cd /home/ubuntu/DevOps-Challenge/app/
composer install
composer update
php artisan key:generate
cd /home/ubuntu
sudo apt-get update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo apt-cache madison docker-ce
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo docker-compose --version
sudo docker run hello-world 
sudo usermod -aG docker ubuntu 
sudo service apache2 stop -y
cd /home/ubuntu/DevOps-Challenge/
sudo docker-compose up -d --build
