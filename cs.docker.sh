#!/bin/bash
docker kill $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)
/etc/init.d/docker restart
curl -X GET http://121.127.13.82:5000/v1/search 
docker pull 121.127.13.82:5000/nginx-porxy-supervisor:v2.0
/etc/init.d/docker restart
docker run -d -i -t -p 80:80  -v /home/conf.d:/etc/nginx/conf.d 5016f888c650 /etc/init.d/supervisord start && /etc/init.d/sshd restart &&  /bin/bash
