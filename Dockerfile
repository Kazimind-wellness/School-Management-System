# Stage 1: Build frontend assets
FROM node:18 as frontend

WORKDIR /app

# Copy package files first (better caching)
COPY package.json package-lock.json* ./

# Install frontend dependencies
RUN npm install

# Copy only the frontend resources needed for build
COPY resources ./resources
COPY vite.config.js ./

# Build frontend assets
RUN npm run build

# Stage 2: PHP + Laravel
FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git unzip libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libxml2-dev zip curl libpq-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring exif pcntl bcmath gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy composer files first for caching
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist

# Copy entire Laravel app
COPY . .

# Copy built frontend assets from frontend stage
COPY --from=frontend /app/public/build ./public/build

# Fix permissions (important for Laravel cache/storage/logs)
RUN chown -R www-data:www-data /var/www/storage /var/www/bootstrap/cache

# Expose port
EXPOSE 8080

# Start Laravel
CMD php artisan config:clear \
    && php artisan cache:clear \
    && php artisan route:clear \
    && php artisan view:clear \
    && (php artisan storage:link || true) \
    && php artisan serve --host=0.0.0.0 --port=8080
