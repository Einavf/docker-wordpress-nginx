# docker-wordpress-nginx
docker repo containing dockerfile with centos7 OS nginx as web server 
php7 installed 
wordpress 4.7.5 installed

instruction:
Build the image by running docker builf -t wordpress .

run the container by running:
docker run -d -p 80:80 --name wordpress wordpress
