#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

rm -f /etc/httpd/conf.d/welcome.conf

MY_HOSTNAME=$(hostname)

BACKEND_DATA=$(curl -s http://${nlb_address})

echo "<h1>Frontend Server: $MY_HOSTNAME</h1>" > /var/www/html/index.html
echo "<h3>Backend Response:</h3>" >> /var/www/html/index.html
echo "<pre>$BACKEND_DATA</pre>" >> /var/www/html/index.html

systemctl restart httpd