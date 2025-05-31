# PostgreSQL Project

This project sets up a custom PostgreSQL database along with pgAdmin for management using Docker. Below are the instructions to get started.

## Prerequisites

- Docker installed on your machine
- Docker Compose installed

## Project Structure

```
postgresql-project
├── docker
│   ├── postgres
│   │   └── Dockerfile
│   └── pgadmin
│       └── Dockerfile
├── scripts
│   ├── init-db.sql
│   └── seed-data.sql
├── docker-compose.yml
├── .env
└── README.md
```

## Setup Instructions

1. **Clone the repository** (if applicable):
   ```bash
   git clone <repository-url>
   cd postgresql-project
   ```

2. **Configure Environment Variables**:
   - Open the `.env` file and set the necessary environment variables for your PostgreSQL database, such as `POSTGRES_USER`, `POSTGRES_PASSWORD`, and `POSTGRES_DB`.

3. **Build and Run the Containers**:
   - Use Docker Compose to build and run the services:
   ```bash
   docker-compose up --build
   ```

4. **Access pgAdmin**:
   - Once the containers are running, you can access pgAdmin by navigating to `http://localhost:8080` in your web browser.
   - Log in using the credentials specified in the `.env` file.

5. **Initialize the Database**:
   - The `init-db.sql` script will run automatically to set up the database schema.
   - The `seed-data.sql` script can be executed manually through pgAdmin to populate the database with initial data.

## Stopping the Services

To stop the running containers, use:
```bash
docker-compose down
```

## Additional Information

- The `docker/postgres/Dockerfile` contains the instructions to build the PostgreSQL image.
- The `docker/pgadmin/Dockerfile` contains the instructions to build the pgAdmin image.
- The `scripts/init-db.sql` and `scripts/seed-data.sql` files contain the SQL commands for initializing and populating the database.

Feel free to modify the scripts and configurations as needed for your specific use case.