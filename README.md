# 🚀 1-Click Joomla Pro Stack

Deploy a highly optimized, production-ready Joomla environment in seconds. This stack bypasses the friction of traditional shared hosting, providing a modern containerized architecture built on official images.

## ✨ What's Included

* **Joomla (Apache):** Custom-configured to automatically bypass the remote database ownership lock, ensuring a smooth web installation. Crash-proofed against ungraceful restarts.
* **MySQL Database:** A dedicated, persistent database service.
* **phpMyAdmin:** Integrated database management interface, giving you full visual control over your tables and SQL queries out of the box.
* **Persistent Storage:** Pre-configured volume mounts ensure your media, themes, and database survive all deployments and updates safely.

## ⚙️ Pre-Deployment Options

When you click deploy, you can customize your environment:
* **`JOOMLA_VERSION`**: Choose your release (e.g., `5`, `5.1`, `4.4`).
* **`PHP_VERSION`**: Choose your PHP runtime (e.g., `8.2`, `8.3`).

## 🛠️ Post-Deployment Setup (Read Carefully)

Once Railway finishes building the services, you need to connect them via the Joomla Web Installer.

### 1. Run the Joomla Web Installer
1. Go to your **Joomla** service on Railway and click the generated public domain.
2. Follow the setup screens until you reach the **Database Configuration**.
3. Select **MySQLi** as the database type.
4. Open your Railway dashboard, click the **MySQL** service, and navigate to the **Variables** tab.
5. Copy and paste the `MYSQLHOST`, `MYSQLUSER`, `MYSQLPASSWORD`, and `MYSQLDATABASE` values into the Joomla installer.
6. Complete the installation and create your Admin account!

### 2. Accessing phpMyAdmin
To manage your database visually:
1. Go to your **phpMyAdmin** service on the Railway canvas.
2. Go to the **Settings** tab and click **Generate Domain**.
3. Visit that URL and log in using the username `root` and the password from your `MYSQLPASSWORD` variable.

## 🆘 Support
If you run into any issues during deployment, drop a question in the Railway Central Station template queue. I actively monitor this template and will help you get your site live!
