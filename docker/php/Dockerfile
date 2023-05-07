FROM php


WORKDIR /app
COPY config.prod config
COPY index.php index.php
CMD APP_ENV=prod php -S 0.0.0.0:80
