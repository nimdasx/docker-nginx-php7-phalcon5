# docker nginx php74
isinya nginx php7.4 driver sqlsrv microsoft sql server
## catatan pribadi... abaikan ya
````
docker build --tag nimdasx/sf-nginx-php74 .   
docker push nimdasx/sf-nginx-php74  
````
## kalau mau make ini
````
docker run -d -p 80:80 -v /Users/sofyan/Dev/php:/app --name sf-nginx-php74 nimdasx/sf-nginx-php74  
````
## kalau mau matiin
````
docker rm -f sf-nginx-php74  
````
## build dan push ke github :
````
docker build --tag ghcr.io/nimdasx/docker-nginx-php7-phalcon5 .
docker push ghcr.io/nimdasx/docker-nginx-php7-phalcon5
````