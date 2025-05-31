FROM dpage/pgadmin4:latest

# Set default environment variables (these can be overridden by docker-compose or .env)
ENV PGADMIN_DEFAULT_EMAIL=admin@admin.com
ENV PGADMIN_DEFAULT_PASSWORD=admin
ENV PGADMIN_LISTEN_PORT=8080

COPY servers.json /pgadmin4/servers.json
# This Dockerfile is used to create a pgAdmin container for managing PostgreSQL databases.

EXPOSE 8080

# No additional commands needed; the base image handles startup.

