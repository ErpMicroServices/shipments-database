FROM postgres:9

ENV POSTGRES_DB=shipments-database
ENV POSTGRES_USER=shipment_database
ENV POSTGRES_PASSWORD=shipment_database

RUN apt-get update -qq && \
    apt-get install -y apt-utils postgresql-contrib
