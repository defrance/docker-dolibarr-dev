# docker-dolibarr-dev

A Docker setup dedicated to **development and maintenance of Dolibarr core and modules**.

This stack includes:

- Traefik as HTTPS reverse proxy
- Nginx as web server
- PHP-FPM to run Dolibarr
- MariaDB as database
- Shared Docker network: `traefikNetwork`

---

## Why this stack?

### 1️⃣ Why not phpMyAdmin?
We decided **not to include phpMyAdmin** to keep the stack lightweight and focused on development.  
- Developers can connect directly to the database using any MySQL client (e.g., DBeaver, TablePlus, CLI).  
- Reduces unnecessary exposure of database management interfaces.  

### 2️⃣ Why Nginx instead of Apache?
Nginx is chosen over Apache for several reasons:  

- **Performance and memory efficiency:**  
  - **Apache** uses a process/thread model where each connection may consume a separate process, which can quickly use a lot of RAM under high load.  
  - **Nginx** uses an asynchronous, event-driven model, allowing a single process to handle many connections efficiently, making it much lighter in terms of memory.  
- **Docker-friendly:** Lightweight containers are preferred for development and testing.  
- **Compatibility:** Works seamlessly with PHP-FPM in a containerized setup.  
- **Simplicity:** Easier configuration for reverse proxy and SSL with Traefik.  

### 3️⃣ Why Traefik?
Traefik is used as a reverse proxy to simplify HTTPS and routing:  
- Automatic SSL via Let's Encrypt.  
- Dynamic routing to containers without manual Nginx configuration.  
- Easy dashboard to monitor and manage exposed services.  

---

## Services Overview

### Traefik – Reverse Proxy

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

### PHP-FPM – PHP Engine

- **Built from:** `../php-dockerfile/php-8.4.Dockerfile`
- **Depends on:** MariaDB (`mysql`)
- **Volumes:**
  - Dolibarr core (read/write): `../dolibarr-core/dolibarr-22.0.1:/var/www/html/dolibarr:rw`
  - Custom plugins: `../custom:/var/www/html/dolibarr/htdocs/custom:rw`
  - Configuration files: `../conf:/var/www/html/dolibarr/htdocs/conf:rw`
- **Traefik label:** `traefik.enable=false` → not directly exposed
- **Role:** Executes Dolibarr PHP code for Nginx

### Nginx – Web Server

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

### MariaDB – Database

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

## Docker Network

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

```bash
docker-compose up
