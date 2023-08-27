#!bin/bash

# Variables
green=$(tput setaf 2)
VERSION_PHP=8.1

setup_ubuntu() {
  echo "Task: Update ubuntu"
  echo "Updating..."
  sudo apt update
  echo "${green}Task: Update ubuntu - Done"
  echo "Task: Upgrade ubuntu"
  echo "Updating..."
  sudo apt upgrade
  echo "${green}Task: Upgrade ubuntu - Done"
}

setup_php() {
  VERSION_PHP=8.1
  echo "Task: Install PHP"
  echo "Installing..."
  echo "Choose version PHP(Default: 8.1): "
  read VERSION_PHP
  sudo apt install --no-install-recommends php$VERSION_PHP -y
  echo "${green}Task: Install PHP - Done"
  php -v
  echo "Task: Install Packages PHP"
  echo "Installing..."
  sudo apt-get install -y php$VERSION_PHP-cli php$VERSION_PHP-common php$VERSION_PHP-mysql php$VERSION_PHP-zip php$VERSION_PHP-gd php$VERSION_PHP-mbstring php$VERSION_PHP-curl php$VERSION_PHP-xml php$VERSION_PHP-bcmath
  echo "${green}Task: Install Packages PHP - Done"
}

setup_composer() {
  echo "Task: Install Composer"
  echo "Installing..."
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
  php composer-setup.php
  php -r "unlink('composer-setup.php');"
  sudo mv composer.phar /usr/local/bin/composer
  echo "${green}Task: Install Composer - Done"
}

setup_composer_packages() {
  echo "Task: Install PHPCS"
  echo "Task: Install..."
  composer global require "squizlabs/php_codesniffer=*" -y
  echo "${green}Task: Install PHPCS - Done"
  echo "Task: Install Drupal Standards"
  composer global require drupal/coder -y
  php /home/$USER/.config/composer/vendor/bin/phpcs --standard=Drupal
  php /home/$USER/.config/composer/vendor/bin/phpcf --standard=Drupal
  echo "${green}Task: Drupal Standards - Done"
  echo "Task: Install Drupal Check"
  echo "Task: Install..."
  composer global require mglaman/drupal-check -y
  echo "${green}Task: Drupal Check - Done"
}

setup_lando() {
  echo "Task: Install Lando"
  echo "Task: Install..."
  wget https://files.lando.dev/installer/lando-x64-stable.deb
  sudo dpkg -i --ignore-depends=docker-ce lando-stable.deb
  echo "${green}Task: Lando - Done"
}

setup_ubuntu
setup_php
setup_composer
setup_composer_packages
setup_lando