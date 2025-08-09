FROM postgres:latest

ENV POSTGRES_DB=shipments
ENV POSTGRES_USER=shipments
ENV POSTGRES_PASSWORD=shipments

# Copy all migration files to init directory
# PostgreSQL will execute these in alphabetical order on first run
COPY sql/V_ship*.sql /docker-entrypoint-initdb.d/

# Ensure the container uses UTF-8 encoding
ENV LANG=en_US.utf8
