#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# Remove the default welcome config
rm -f /etc/httpd/conf.d/welcome.conf

MY_HOSTNAME=$(hostname)

# Generate JSON metadata
echo "{\"status\": \"success\", \"backend\": \"$MY_HOSTNAME\", \"timestamp\": \"$(date)\"}" > /var/www/html/index.html

# Restart to apply changes
systemctl restart httpd