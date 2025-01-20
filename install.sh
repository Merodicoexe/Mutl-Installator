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
echo "2. Pterodactyl (not supported)"
echo "3. Install Web (Nginx or Apache2)"
echo "4. Install PHP"
echo "5. Install Node.js"
echo "6. Exit"

read -p "Select an option [1-6]: " option

case $option in
1)
    echo "Installing phpMyAdmin and MariaDB..."
    sudo apt update
    sudo apt install -y mariadb-server phpmyadmin
    echo "phpMyAdmin and MariaDB installation complete!"
    ;;
2)
    clear
    echo "Pterodactyl installation is not supported at the moment."
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
