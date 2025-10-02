# Use official PHP with required extensions
FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git unzip libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libxml2-dev zip curl libpq-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring exif pcntl bcmath gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Node.js + npm (needed for Vite)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
    && apt-get install -y nodejs

# Install Composer (latest v2)
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy composer files first
COPY composer.json composer.lock ./

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction --prefer-dist --no-scripts

# Copy the rest of the application
COPY . .

# Install frontend dependencies + build with Vite
RUN npm install && npm run build

# ✅ Ensure Vite build files are inside /public/build
# By default, Vite + Laravel plugin outputs to public/build
# But in case it's dist/, copy it explicitly
RUN if [ -d "dist" ]; then cp -r dist/* public/; fi

# Expose port 8080 for Render
EXPOSE 8080

# Start Laravel with Artisan’s built-in server
CMD php artisan config:clear \
    && php artisan cache:clear \
    && php artisan route:clear \
    && php artisan view:clear \
    && (php artisan storage:link || true) \
    && php artisan serve --host=0.0.0.0 --port=8080
