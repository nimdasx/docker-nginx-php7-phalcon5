# docker nginx php74
isinya nginx php7.4 driver sqlsrv microsoft sql server
webdevops/php-nginx gak ono versi arm
## catatan pribadi... abaikan ya
````
docker run -d -p 80:80 -v /Users/sofyan/Dev/php:/app --name nginx-php7-phalcon5qwe nimdasx/nginx-php7-phalcon5
````
## build dan push ke github :
````
docker build --tag ghcr.io/nimdasx/nginx-php7-phalcon5 .
docker push ghcr.io/nimdasx/nginx-php7-phalcon5
````
## build dan push ke docker hub :
````
docker build --tag nimdasx/nginx-php7-phalcon5 .
docker push nimdasx/nginx-php7-phalcon5
````