FROM postgres:latest
ARG POSTGRES_USER=postgres
ARG POSTGRES_PASSWORD=postgres
ARG POSTGRES_DB=postgres
# This Dockerfile is used to create a PostgreSQL container for managing databases.
# It uses the official PostgreSQL image from Docker Hub as the base image.
ENV POSTGRES_USER=${POSTGRES_USER}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
ENV POSTGRES_DB=${POSTGRES_DB}

COPY ../scripts/init-db.sql /docker-entrypoint-initdb.d/


EXPOSE 5432
# The default port for PostgreSQL is 5432, so we expose it here.
# This allows the container to be accessed on this port from the host machine.
# The init-db.sql and seed-data.sql files will be executed when the container is started.
# The init-db.sql file is used to initialize the database with the schema.
# The seed-data.sql file is used to populate the database with initial data.
# The environment variables POSTGRES_USER, POSTGRES_PASSWORD, and POSTGRES_DB are used to set the default user, password, and database name.
# These variables can be set in the .env file or passed as arguments when running the container.
               