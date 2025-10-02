# Use official PHP 8.1 image with extensions
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

# Copy project files
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Give Laravel storage and bootstrap folders the right permissions
RUN chmod -R 775 storage bootstrap/cache

# Expose port (Render injects PORT)
EXPOSE 8000

# Start Laravel app
CMD php artisan serve --host=0.0.0.0 --port=${PORT:-8000}
