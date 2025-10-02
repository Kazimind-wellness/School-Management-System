# Use an official PHP image with required extensions
FROM php:8.1-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath xml zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy app
COPY . /var/www/html

# Install composer dependencies
RUN composer install --no-dev --optimize-autoloader

# Copy .env (you may override in Render by env vars)
# (Better: don’t copy .env; use render env vars)
# RUN cp .env.example .env

# Generate optimized files
RUN php artisan key:generate \
    && php artisan config:cache \
    && php artisan route:cache \
    && php artisan view:cache

# Expose port (Render will provide PORT env var)
EXPOSE 8000

# Start the application (you can use artisan serve or php-fpm + nginx)
CMD php artisan serve --host=0.0.0.0 --port=${PORT:-8000}
