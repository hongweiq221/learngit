#!/bin/bash
/etc/init.d/iptables stop   

sed -i '7s/^.*$/SELINUX=disabled/' /etc/sysconfig/selinux 
cat << EOF > /etc/resolv.conf
nameserver 8.8.8.8
EOF

yum install wget  -y
yum install autoconf automake jemalloc-devel libedit-devel libtool ncurses-devel pcre-devel pkgconfig python-docutils python-sphinx -y

wget https://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm 
rpm -ivh epel-release-6-8.noarch.rpm
yum install docker-io -y
service docker start 
sed  -i "7s/^.*$/other_args='--insecure-registry 121.127.13.82:5000'/" /etc/sysconfig/docker

docker kill $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)
/etc/init.d/docker restart
curl -X GET http://121.127.13.82:5000/v1/search 
docker pull 121.127.13.82:5000/nginx-porxy-supervisor:v2.0 

cd /home/ 

mkdir conf.d 

cd conf.d/


if [  -f "ip.conf" ]
then
rm -r ip.conf
fi

if [  -f "web.conf" ]
then
rm -r web.conf
fi

touch {ip.conf,web.conf}


cat > web.conf <<MAYDAY
server {
  server_name game.opcai.com;
  listen 80;
  index index.php index.html in.do;
  location / {
        access_log  off;
        error_log off;
        proxy_connect_timeout 600s;  
        proxy_read_timeout 600s;
        proxy_pass http://opcai_web/;
        proxy_redirect             off;
        proxy_set_header           Host $host;
        proxy_set_header           X-Real-IP $remote_addr;
        proxy_set_header           X-Forwarded-For $proxy_add_x_forwarded_for;
        client_max_body_size       10m;
        client_body_buffer_size    128k;
        proxy_send_timeout         600s;
        proxy_buffer_size          4k;
        proxy_buffers              4 32k;
        proxy_busy_buffers_size    64k;
        proxy_temp_file_write_size 64k;
 }
}

MAYDAY


cat > ip.conf <<MAYDAY
upstream opcai_web {
  server 150.242.211.2:1080 max_fails=1 fail_timeout=600s weight=6;
  server 150.242.211.2:2080 max_fails=1 fail_timeout=600s weight=6;
  server 150.242.211.3:1080 max_fails=1 fail_timeout=600s weight=6;
  server 150.242.211.3:2080 max_fails=1 fail_timeout=600s weight=6;
  server 150.242.211.4:1080 max_fails=1 fail_timeout=600s weight=6;
  server 150.242.211.4:2080 max_fails=1 fail_timeout=600s weight=6;
}

upstream images_opcai {
   server 150.242.211.8:8098 max_fails=1 fail_timeout=600s weight=6;
   #server 150.242.221.7:8098 max_fails=1 fail_timeout=600s weight=6;
}

MAYDAY

docker run -d -i -t -p 80:80  -v /home/conf.d:/etc/nginx/conf.d 5016f888c650 /etc/init.d/supervisord start && /etc/init.d/sshd restart &&  /bin/bash

