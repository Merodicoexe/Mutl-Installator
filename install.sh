#!/bin/bash
clear
echo -e "\033[1;32m
███╗   ███╗██╗   ██╗██╗  ████████╗██╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗ 
████╗ ████║██║   ██║██║  ╚══██╔══╝██║    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗
██╔████╔██║██║   ██║██║     ██║   ██║    ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝
██║╚██╔╝██║██║   ██║██║     ██║   ██║    ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗
██║ ╚═╝ ██║╚██████╔╝███████╗██║   ██║    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║
╚═╝     ╚═╝ ╚═════╝ ╚══════╝╚═╝   ╚═╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝
\033[0m"

echo "1. Install phpMyAdmin + MariaDB"
echo "2. Pterodactyl (Supported)"
echo "3. Install Web (Nginx or Apache2)"
echo "4. Install PHP"
echo "5. Install Node.js"
echo "6. Exit"

read -p "Select an option [1-6]: " option

case $option in
1)
    echo "Installing phpMyAdmin and MariaDB..."
    bash <(curl -s https://raw.githubusercontent.com/JulianGransee/PHPMyAdminInstaller/main/install.sh)
    echo "phpMyAdmin and MariaDB installation complete!"
    ;;
2)
    clear
    echo "Installing Pterodactyl..."
    apt -y install software-properties-common curl apt-transport-https ca-certificates gnupg
    LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
    apt update
    apt -y install php8.3 php8.3-{common,cli,gd,mysql,mbstring,bcmath,xml,fpm,curl,zip} mariadb-server tar unzip git
    curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
    mkdir -p /var/www/pterodactyl
    cd /var/www/pterodactyl
    curl -Lo panel.tar.gz https://github.com/pterodactyl/panel/releases/latest/download/panel.tar.gz
    tar -xzvf panel.tar.gz
    chmod -R 755 storage/* bootstrap/cache/

    echo "Creating Pterodactyl Database..."
    mysql -e "CREATE USER 'pterodactyl'@'127.0.0.1' IDENTIFIED BY '<password>';"
    mysql -e "CREATE DATABASE panel;"
    mysql -e "GRANT ALL PRIVILEGES ON panel.* TO 'pterodactyl'@'127.0.0.1' WITH GRANT OPTION;"

    cp .env.example .env
    COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --optimize-autoloader
    php artisan key:generate --force
    php artisan p:environment:setup
    php artisan p:environment:database
    php artisan migrate --seed --force
    php artisan p:user:make
    chown -R www-data:www-data /var/www/pterodactyl/*

    echo "Configuring Pterodactyl Queue Worker..."
    echo "* * * * * php /var/www/pterodactyl/artisan schedule:run >> /dev/null 2>&1" | sudo crontab -e

    echo "Creating Pterodactyl Queue Worker Service..."
    sudo bash -c 'cat <<EOF > /etc/systemd/system/pteroq.service
# Pterodactyl Queue Worker File
# ----------------------------------

[Unit]
Description=Pterodactyl Queue Worker
After=redis-server.service

[Service]
User=www-data
Group=www-data
Restart=always
ExecStart=/usr/bin/php /var/www/pterodactyl/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3
StartLimitInterval=180
StartLimitBurst=30
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF'

    sudo systemctl enable --now pteroq.service

    echo "Configure Web Server for Pterodactyl:"
    echo "1. Nginx With SSL"
    echo "2. Nginx Without SSL"
    echo "3. Apache With SSL"
    echo "4. Apache Without SSL"
    read -p "Select an option [1-4]: " web_config_option
    case $web_config_option in
    1)
        echo "Configure Nginx With SSL..."
        ;;
    2)
        echo "Configure Nginx Without SSL..."
        ;;
    3)
        echo "Configure Apache With SSL..."
        ;;
    4)
        echo "Configure Apache Without SSL..."
        ;;
    *)
        echo "Invalid option for Web Server configuration."
        ;;
    esac

    echo "Installing Docker..."
    curl -sSL https://get.docker.com/ | CHANNEL=stable bash
    sudo systemctl enable --now docker

    sudo mkdir -p /etc/pterodactyl
    curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_$([[ "$(uname -m)" == "x86_64" ]] && echo "amd64" || echo "arm64")"
    sudo chmod u+x /usr/local/bin/wings

    echo "Configure Pterodactyl Node in /etc/pterodactyl/config.yml..."
    echo "Finnish: Add to /etc/pterodactyl/config.yml under 'configuration' in 'node' section."

    echo "Pterodactyl installation complete!"
    ;;
3)
    clear
    echo "Install Web Server:"
    echo "1. Nginx"
    echo "2. Apache2"
    read -p "Select an option [1-2]: " web_option
    case $web_option in
    1)
        echo "Installing Nginx..."
        sudo apt update
        sudo apt install -y nginx
        echo "Nginx installation complete!"
        ;;
    2)
        echo "Installing Apache2..."
        sudo apt update
        sudo apt install -y apache2
        echo "Apache2 installation complete!"
        ;;
    *)
        echo "Invalid option for Web Server. Returning to main menu."
        ;;
    esac
    ;;
4)
    clear
    echo "Install PHP:"
    echo "1. PHP 8.4"
    echo "2. PHP 8.3"
    echo "3. PHP 8.2"
    echo "4. PHP 8.1"
    read -p "Select an option [1-4]: " php_option
    case $php_option in
    1)
        echo "Installing PHP 8.4..."
        sudo apt update
        sudo apt install -y php8.4
        echo "PHP 8.4 installation complete!"
        ;;
    2)
        echo "Installing PHP 8.3..."
        sudo apt update
        sudo apt install -y php8.3
        echo "PHP 8.3 installation complete!"
        ;;
    3)
        echo "Installing PHP 8.2..."
        sudo apt update
        sudo apt install -y php8.2
        echo "PHP 8.2 installation complete!"
        ;;
    4)
        echo "Installing PHP 8.1..."
        sudo apt update
        sudo apt install -y php8.1
        echo "PHP 8.1 installation complete!"
        ;;
    *)
        echo "Invalid option for PHP version. Returning to main menu."
        ;;
    esac
    ;;
5)
    clear
    echo "Install Node.js:"
    echo "1. Install Node.js (Latest)"
    echo "2. Install Node.js 18.x"
    echo "3. Install Node.js 16.x"
    echo "4. Install Node.js 14.x"
    read -p "Select an option [1-4]: " node_option
    case $node_option in
    1)
        echo "Installing the latest version of Node.js..."
        curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
        sudo apt install -y nodejs
        echo "Node.js (latest version) installation complete!"
        ;;
    2)
        echo "Installing Node.js 18.x..."
        curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
        sudo apt install -y nodejs
        echo "Node.js 18.x installation complete!"
        ;;
    3)
        echo "Installing Node.js 16.x..."
        curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
        sudo apt install -y nodejs
        echo "Node.js 16.x installation complete!"
        ;;
    4)
        echo "Installing Node.js 14.x..."
        curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
        sudo apt install -y nodejs
        echo "Node.js 14.x installation complete!"
        ;;
    *)
        echo "Invalid option for Node.js version. Returning to main menu."
        ;;
    esac
    ;;
6)
    clear
    echo "Exiting..."
    exit 0
    ;;
*)
    echo "Invalid option. Exiting..."
    exit 1
    ;;
esac
