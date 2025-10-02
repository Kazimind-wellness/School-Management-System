# ----------------------
# Stage 1: Build dependencies
# ----------------------
FROM composer:2 AS vendor

WORKDIR /app

# Copy composer files only (caching layer)
COPY composer.json composer.lock ./

# Install dependencies (production only)
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

# ----------------------
# Stage 2: Application
# ----------------------
FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git unzip curl libpng-dev libonig-dev libxml2-dev zip \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

WORKDIR /var/www/html

# Copy app source code
COPY . .

# Copy vendor folder from builder stage
COPY --from=vendor /app/vendor ./vendor

# Set permissions for Laravel
RUN chown -R www-data:www-data \
        /var/www/html/storage \
        /var/www/html/bootstrap/cache

# Expose port 9000 for PHP-FPM
EXPOSE 9000

CMD ["php-fpm"]
