# Use official PHP with required extensions
FROM php:8.2-fpm

# Install system dependencies + PostgreSQL dev libraries
RUN apt-get update && apt-get install -y \
    git unzip libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libxml2-dev zip curl \
    libpq-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring exif pcntl bcmath gd

# Install Composer (latest v2)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy composer files first
COPY composer.json composer.lock ./

# Install PHP dependencies without running artisan
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist --no-scripts

# Copy rest of the application
COPY . .

# Run artisan commands only after deploy, not during build
CMD php artisan config:cache && php artisan route:cache && php artisan migrate --force && php-fpm
