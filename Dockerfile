# ใช้ PHP 8.2 พร้อม Apache
FROM php:8.2-apache

# ติดตั้ง Extension PDO และ MySQLi
RUN apt-get update && docker-php-ext-install pdo pdo_mysql mysqli

# เปิด mod_rewrite
RUN a2enmod rewrite

# อนุญาตให้ .htaccess ทำงาน
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

# คัดลอก htaccess เป็น .htaccess
RUN echo 'RewriteEngine On\nRewriteCond %{REQUEST_FILENAME} !-d\nRewriteCond %{REQUEST_FILENAME}\\.php -f\nRewriteRule ^(.*)$ $1.php [L]' > /var/www/html/.htaccess