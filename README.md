# docker-dolibarr-dev

A Docker setup dedicated to **development and maintenance of Dolibarr core and modules**.

This stack includes:

- Traefik as HTTPS reverse proxy
- Nginx as web server
- PHP-FPM to run Dolibarr
- MariaDB as database
- Shared Docker network: `traefikNetwork`

---

## Services Overview

### 1️⃣ Traefik – Reverse Proxy

- **Image:** `traefik:latest`
- **Ports exposed:**
  - `443` → HTTPS for Dolibarr
  - `8080` → Traefik dashboard
- **Features:**
  - Automatic SSL certificates via Let's Encrypt (`myresolver`)
  - Dashboard accessible at [http://localhost:8080](http://localhost:8080)
  - Only Nginx is exposed via Traefik (`traefik.enable=true`)
- **Volumes:**
  - `/var/run/docker.sock` → Docker integration
  - `../letsencrypt` → SSL certificate storage

---

### 2️⃣ PHP-FPM – PHP Engine

- **Built from:** `../php-dockerfile/php-8.4.Dockerfile`
- **Depends on:** MariaDB (`mysql`)
- **Volumes:**
  - Dolibarr core (read/write): `../dolibarr-core/dolibarr-22.0.1:/var/www/html/dolibarr:rw`
  - Custom plugins: `../custom:/var/www/html/dolibarr/htdocs/custom:rw`
  - Configuration files: `../conf:/var/www/html/dolibarr/htdocs/conf:rw`
- **Traefik label:** `traefik.enable=false` → not directly exposed
- **Role:** Executes Dolibarr PHP code for Nginx

---

### 3️⃣ Nginx – Web Server

- **Image:** `nginx:stable`
- **Depends on:** PHP-FPM (`php-fpm`)
- **Volumes:**
  - Dolibarr core (read-only)
  - Plugins (accessible)
  - Nginx configuration: `../nginx/default.conf`
- **Traefik labels:**
  - Exposed via HTTPS: `https://localhost/`
  - EntryPoint: `websecure`
  - SSL via `myresolver`
- **Role:** Serves Dolibarr web interface

---

### 4️⃣ MariaDB – Database

- **Image:** `mariadb:latest`
- **Volumes:** `./dbdata:/var/lib/mysql` (persistent data)
- **Port exposed:** `3306`
- **Environment:**
  - Root password: `rootPASS`
  - Database: `dolibarr`
  - User: `dbuser`
  - Password: `dbpass`
- **Traefik label:** `traefik.enable=false`
- **Role:** Stores Dolibarr data

---

## 5️⃣ Docker Network

All services share `traefikNetwork`, allowing:

- Nginx ↔ PHP-FPM communication
- PHP-FPM ↔ MariaDB communication
- Traefik routing HTTPS traffic to Nginx

---

## Accessing Services

| Service        | URL / Port                  | Notes                               |
|----------------|----------------------------|------------------------------------|
| Dolibarr       | `https://localhost/`        | Via Traefik, HTTPS                  |
| Traefik dash   | `http://localhost:8080`     | Traefik dashboard                   |
| MariaDB        | `localhost:3306`            | MySQL client access                 |
| PHP-FPM        | internal                   | Not directly accessible             |

---

## Quick Start

1. Launch the stack:

docker-compose up -d
