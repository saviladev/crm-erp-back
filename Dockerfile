# Use the official PHP image with necessary extensions
FROM php:8.2-fpm

# Set working directory
WORKDIR /var/www

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Clone the application code from GitHub
RUN git clone https://github.com/saviladev/crm-erp-back.git .

# Install Composer
COPY --from=composer:2.5 /usr/bin/composer /usr/bin/composer

# Copy .env.example to .env
RUN cp .env.example .env

# Generate Laravel APP_KEY and JWT secret
RUN php artisan key:generate --force \
    && php artisan jwt:secret --force

# Set permissions for Laravel
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage

# Expose port 9000
EXPOSE 9000

# Start PHP-FPM server
CMD ["php-fpm"]