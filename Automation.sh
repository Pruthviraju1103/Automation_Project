#package update

sudo apt-get update

# apache checking
install= dpkg --get-selections apache2 | awk '{print $2}'


if [ install == $install ];
then
        echo "package is installed"
else
        sudo apt install apache2 -y 
fi
#i need to check the status

checking= sudo systemctl status apache2 | grep -o running


if [[ checking == $running ]];
then
        echo "service is running"
else
        sudo /etc/init.d/apache2 start
fi
cd /var/log/apache2/

name="pruthvi"

timestamp=$(date '+%d%m%Y-%H%M%S')
tar -cf /tmp/${name}-httpd-logs-${timestamp}.tar *.log
s3_bucket="upgrad-pruthvi"
aws s3 \
        cp /tmp/${name}-httpd-logs-${timestamp}.tar \
        s3://${s3_bucket}/${name}-httpd-logs-${timestamp}.tar

cd /var/www/html/
path="/var/www/html"

if [[ ! -f ${path}/inventory.html ]]; then echo -e 'Log Type\tTime Created\tType\tSize' | sudo tee $path/inventory.html > /dev/null fi

if [[ ! -f ${path}/inventory.html ]]; then size=$(du -h /tmp/${name}-httpd-logs-${timestamp}.tar | awk '{print $1}') echo -e "httpd-logs\t${timestamp}\ttar\t${size}" | sudo tee -a $path/inventory.html > /dev/null
fi

