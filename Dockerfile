# Use official PHP 8.1 image with needed extensions
FROM php:8.1-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy only composer files first (for caching)
COPY composer.json composer.lock ./

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction --no-scripts --prefer-dist

# Now copy the full app
COPY . .

# Run Laravel scripts after code is copied
RUN composer dump-autoload --optimize

# Ensure storage and cache are writable
RUN chmod -R 775 storage bootstrap/cache

# Expose port (Render sets $PORT)
EXPOSE 8000

# Start Laravel (artisan serve)
CMD php artisan serve --host=0.0.0.0 --port=${PORT:-8000}
