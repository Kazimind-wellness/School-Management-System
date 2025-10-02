# ----------------------
# Stage 1: Build dependencies
# ----------------------
FROM php:8.2-cli AS vendor

# Install system dependencies needed for composer
RUN apt-get update && apt-get install -y \
    git unzip curl libpng-dev libonig-dev libxml2-dev zip \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app

# Copy composer files only (for caching)
COPY composer.json composer.lock ./

# Install PHP dependencies (production only)
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

# ----------------------
# Stage 2: Application
# ----------------------
FROM php:8.2-fpm

# Install system dependencies for PHP-FPM runtime
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

# Expose port (Render will set $PORT)
EXPOSE 8000

# Start Laravel (using artisan serve for Render simplicity)
CMD php artisan serve --host=0.0.0.0 --port=${PORT:-8000}
