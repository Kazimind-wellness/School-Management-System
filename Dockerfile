# ---------- Base image ----------
FROM php:8.2-apache

# ---------- System dependencies ----------
RUN apt-get update && apt-get install -y \
    git unzip curl zip libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libxml2-dev libpq-dev libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring exif pcntl bcmath gd zip opcache

# ---------- Enable Apache rewrite ----------
RUN a2enmod rewrite

# ---------- Working directory ----------
WORKDIR /var/www/html

# ---------- Copy Composer and install PHP dependencies ----------
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist || cat /var/www/html/storage/logs/laravel.log || true

# ---------- Copy full application ----------
COPY . .

# ---------- Node + Vite build ----------
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs \
    && npm install \
    && npm run build \
    && rm -rf node_modules

RUN composer diagnose || true

# ---------- Apache document root ----------
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# ---------- Set permissions ----------
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# ---------- Environment ----------
ENV APACHE_RUN_USER=www-data
ENV APACHE_RUN_GROUP=www-data

# ---------- Expose ----------
EXPOSE 8080

# ---------- (Optional) Safe migrations on deploy ----------
# Uncomment the next line if you want migrations to run automatically
# RUN php artisan migrate --force || true

# ---------- Run migrations then start Apache ----------
CMD ["apache2-foreground"]

