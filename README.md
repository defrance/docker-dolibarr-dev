# docker-dolibarr-dev 🚀

A **Docker setup dedicated to development and maintenance of Dolibarr core and modules**, optimized for **Apple Silicon**, using **Nginx + PHP-FPM + MariaDB + Traefik**.  
Lightweight, performant, and ready for core and module development.

> ⚠️ **IMAP is disabled by default** to prevent crashes in Dolibarr.

---

## Why this stack? 💡

### 1️⃣ No phpMyAdmin
We decided **not to include phpMyAdmin** to keep the stack lightweight and development-focused.  
- Connect directly to the database using any MySQL client.  
- For macOS (Apple Silicon), we recommend **[Sequel Ace](https://apps.apple.com/fr/app/sequel-ace/id1518036000?mt=12)** – free, lightweight, and high-performance.  
- Reduces unnecessary exposure of database management interfaces.

### 2️⃣ Nginx vs Apache
Nginx is chosen over Apache for several reasons:  
- **Performance & memory efficiency:**  
  - Apache uses one process/thread per connection → high RAM usage.  
  - Nginx uses an asynchronous, event-driven model → handles many connections efficiently.  
- **Docker-friendly:** Lightweight containers ideal for development.  
- **Compatibility:** Works seamlessly with PHP-FPM.  
- **Simplicity:** Easier SSL & reverse proxy configuration with Traefik.

### 3️⃣ Why Traefik
- Automatic SSL via Let’s Encrypt.  
- Dynamic routing to containers without manual Nginx configuration.  
- Dashboard to monitor and manage exposed services.

### 4️⃣ Apple Silicon Compatibility
- Fully optimized for **ARM64 architecture** (M1/M2 Macs).  
- All images and builds tested on Apple Silicon.

### 5️⃣ IMAP Warning
- **IMAP is not installed by default**.  
- Enabling IMAP may cause **crashes or instability**.  
- Avoid activating IMAP until proper support is added.

---

## PHP-FPM – Engine Highlights ⚡

- **Base image:** `php:8.4-fpm`  
- **Installed extensions:** `mysqli`, `pdo_mysql`, `zip`, `intl`, `calendar`, `gd`, `opcache`  
- **OPcache configured:**  
  - Memory: 128 MB  
  - Max accelerated files: 4000  
  - Revalidate every 2 seconds  
  - CLI enabled  
- **Volumes:**  
  - Dolibarr core (read/write)  
  - Custom plugins  
  - Configuration files  
- **Role:** Executes Dolibarr PHP code for Nginx  

---

## Dockerfile Summary 🐳

- **Base image:** `php:8.4-fpm`  
- **PHP extensions:**  
  - `mysqli`, `pdo`, `pdo_mysql` → MySQL/MariaDB access  
  - `zip`, `intl`, `calendar`, `gd` → Dolibarr core & modules  
  - `opcache` → improved PHP performance  
- **System libraries installed:** `zip`, `unzip`, `curl`, `bash`, `libzip-dev`, `libonig-dev`, `libicu-dev`, `libpng-dev`, `libjpeg-dev`, `libfreetype6-dev`  
- **GD configured:** JPEG & FreeType for image processing  
- **OPcache settings:** 128 MB memory, 4000 files, 2s revalidate, CLI enabled  
- **Working directory:** `/var/www/html`  
- **Exposed port:** `9000` (PHP-FPM)

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
- **Ports:**  
  - `443` → HTTPS  
  - `8080` → Dashboard  
- **Features:**  
  - Automatic SSL via Let’s Encrypt (`myresolver`)  
  - Dynamic routing to containers  
  - Dashboard: [http://localhost:8080](http://localhost:8080)

---

## MariaDB – Database

- **Image:** `mariadb:latest`  
- **Port:** 3306  
- **Environment:**  
  - Root: `rootPASS`  
  - Database: `dolibarr`  
  - User: `dbuser`  
  - Password: `dbpass`  
- **Persistent storage:** `./dbdata`  
- **Role:** Stores Dolibarr data  

---

## Docker Network 🌐

All services share `traefikNetwork`, enabling:  
- Nginx ↔ PHP-FPM communication  
- PHP-FPM ↔ MariaDB communication  
- Traefik routing HTTPS traffic to Nginx

---

## Accessing Services 🔑

| Service        | URL / Port                  | Notes |
|----------------|----------------------------|-------|
| Dolibarr       | `https://localhost/`        | Via Traefik, HTTPS |
| Traefik dash   | `http://localhost:8080`     | Dashboard |
| MariaDB        | `localhost:3306`            | Sequel Ace recommended |
| PHP-FPM        | internal                   | Not directly accessible |

---

## Quick Start ⚡

1. Launch the stack:

```bash
docker-compose up
