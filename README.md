# docker-dolibarr-dev 🚀

A **Docker setup dedicated to development and maintenance of Dolibarr core and modules**, optimized for **Apple Silicon (M1/M2)**, using **Nginx + PHP-FPM + MariaDB + Traefik**. Lightweight, performant, and ready for module/core development.

> ⚠️ **IMAP is disabled by default** to prevent crashes in Dolibarr.

---

## Why this stack? 💡

### 1️⃣ Why not phpMyAdmin?
We decided **not to include phpMyAdmin** to keep the stack lightweight and focused on development.  
- Connect directly to the database using any MySQL client.  
- For macOS (Apple Silicon), we recommend **[Sequel Ace](https://apps.apple.com/fr/app/sequel-ace/id1518036000?mt=12)** – a free, lightweight, and high-performance database management app.  
- Reduces unnecessary exposure of database management interfaces.

### 2️⃣ Why Nginx instead of Apache?
Nginx is chosen over Apache for several reasons:  
- **Performance & memory efficiency:**  
  - Apache creates a process/thread per connection → higher RAM usage under load.  
  - Nginx uses an asynchronous, event-driven model → handles many connections efficiently.  
- **Docker-friendly:** Lightweight containers for development.  
- **Compatibility:** Works seamlessly with PHP-FPM.  
- **Simplicity:** Easier configuration for reverse proxy and SSL with Traefik.

### 3️⃣ Why Traefik?
- Automatic SSL via Let's Encrypt.  
- Dynamic routing to containers without manual Nginx configuration.  
- Dashboard to monitor and manage exposed services.

### 4️⃣ Apple Silicon Compatibility
- Fully optimized for **ARM64 architecture**, making it compatible with M1/M2 Macs.  
- Images and builds tested to run smoothly on Apple Silicon.

### 5️⃣ IMAP Warning
- **IMAP is not installed by default** in this Dolibarr setup.  
- Enabling IMAP may cause **crashes or instability**.  
- Avoid activating IMAP until proper support is added.

---

## PHP-FPM – Engine Highlights ⚡

- **Base image:** `php:8.4-fpm`  
- **Installed extensions:** `mysqli`, `pdo_mysql`, `zip`, `intl`, `calendar`, `gd`, `opcache`  
- **OPcache configured:**  
  - Memory: 128 MB  
  - Max accelerated files: 4000  
  - Revalidate frequency: 2 sec  
  - CLI enabled  
- **Volumes:**  
  - Dolibarr core (read/write)  
  - Custom plugins  
  - Configuration files  
- **Role:** Executes Dolibarr PHP code for Nginx  

---

## Synthèse du Dockerfile 🐳

- **Base image:** `php:8.4-fpm`  
- **Extensions PHP installées:**  
  - `mysqli`, `pdo`, `pdo_mysql` → accès à MySQL/MariaDB  
  - `zip`, `intl`, `calendar`, `gd` → support pour Dolibarr core et modules  
  - `opcache` activé pour améliorer les performances PHP  
- **Librairies système installées:** `zip`, `unzip`, `curl`, `bash`, `libzip-dev`, `libonig-dev`, `libicu-dev`, `libpng-dev`, `libjpeg-dev`, `libfreetype6-dev`  
- **GD configuré** avec JPEG et FreeType pour le traitement d’images  
- **OPcache configuré:**  
  - 128 MB de mémoire  
  - 4000 fichiers accélérés  
  - Revalidation toutes les 2 secondes  
  - Activation CLI  
- **Répertoire de travail:** `/var/www/html`  
- **Port exposé:** `9000` (PHP-FPM)  

---

## Nginx – Web Server

- **Image:** `nginx:stable`  
- **Serves Dolibarr at root (`/`)**  
- **Static files caching:** 30 days  
- **Security:** blocks `.ht*` files  
- **PHP-FPM connection:** `fastcgi_pass php-fpm:9000`  
- **Traefik labels:** exposes Dolibarr via HTTPS

---

## Traefik – Reverse Proxy

- **Image:** `traefik:latest`  
- **Ports:** `443` → HTTPS, `8080` → Dashboard  
- **Features:**  
  - Automatic SSL via Let's Encrypt (`myresolver`)  
  - Dynamic routing to containers  
  - Dashboard at [http://localhost:8080](http://localhost:8080)

---

## MariaDB – Database

- **Image:** `mariadb:latest`  
- **Port:** 3306  
- **Environment:**  
  - Root: `rootPASS`  
  - DB: `dolibarr`  
  - User: `dbuser`  
  - Password: `dbpass`  
- **Persistent storage:** `./dbdata`  
- **Role:** Stores Dolibarr data  

---

## Docker Network 🌐

All services share `traefikNetwork`, allowing:

- Nginx ↔ PHP-FPM communication  
- PHP-FPM ↔ MariaDB communication  
- Traefik routing HTTPS traffic to Nginx

---

## Accessing Services 🔑

| Service        | URL / Port                  | Notes |
|----------------|----------------------------|-------|
| Dolibarr       | `https://localhost/`        | Via Traefik, HTTPS |
| Traefik dash   | `http://localhost:8080`     | Dashboard |
| MariaDB        | `localhost:3306`            | Use Sequel Ace / MySQL client |
| PHP-FPM        | internal                   | Not directly accessible |

---

## Quick Start ⚡

1. Launch the stack:

```bash
docker-compose up
