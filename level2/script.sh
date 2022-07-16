#! /bin/bash
yum update -y
yum install -y httpd
systemctl start httpd && systemctl enable httpd
echo >> “Hello mydevopsmentor from $(hostname -f). Created from Terraform” >> /var/www/html/index.html 