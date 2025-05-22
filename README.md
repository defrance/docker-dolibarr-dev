# docker-dolibarr-dev
A docker setting dedicated to developpement and maintain dolibarr core and module

## princip
* Load the dolibarr core version you need on dolibarr-core
* copy/paste the dolibarr-dev folders and define the specific setting
  * php version
  * dolibarr version
  * mysql version (you can change here your login password and database name)
  * NEW : You can use postgres with specific settings

Launch the docker-compose up, and connect on http://localhost/dolibarr/htdocs to launch the install

If you want to change the php version or mysql kernel, launch docker-compose up -d --build

une vidéo youtube présentant l'outil est disponible ici : https://www.youtube.com/watch?v=7FosoJzANSo

## install setting
On the database setting
* use mysql on database server
* tcheck "create database"
* enter user "root" and root login password 2 times
## Other Tools access  
### phpmyAdmin
phpmyadmin page are accessible on http://pma.localhost
### Traefik
Traefik page are accessible on http://localhost:8080
### pgadmin (if postgres version)
pgadmin page are accessible on http://pgadmin.localhost

