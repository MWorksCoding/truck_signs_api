# Truck Signs API Docker Deployment

A full Django backend project packaged with Docker. The application runs with PostgreSQL in a separate container, all containers communicate on the same Docker network, and the backend is exposed via Gunicorn WSGI on port 8020.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Quickstart](#-quickstart)
3. [Usage](#-usage)

   * [Create Docker Network](#-create-docker-network)
   * [Run PostgreSQL Container](#-run-postgresql-container)
   * [Build and Run Backend Container](#-build-and-run-backend-container)
   * [Docker Management Commands](#docker-management-commands)
4. [Project Checklist](#project-checklist)

---

## Prerequisites

Before you begin, ensure the following is installed:

* [Docker](https://docs.docker.com/get-docker/)

---

## 🚀 Quickstart

Clone the repository:

```
git clone https://github.com/MWorksCoding/truck_signs_api
cd truck_signs_api
```

Create a `.env` file in the root directory with all environment variables:

```
cp example.env .env
```

> Make sure to update the `.env` values for your environment (database credentials, secret key, superuser credentials, Stripe, email, etc.)

---

## 🧑‍💻 Usage

### 🚀 Create Docker Network

All containers must be on the same network to communicate by name:

```
docker network create truck-signs-net
```

---

### 🚀 Run PostgreSQL Container

Create a persistent volume to store database data:

```
docker volume create truck-signs-db-data
```

Start the Postgres container:

```
docker run -d 
--name db 
--network truck-signs-net 
--restart always 
-e POSTGRES_DB=truckdb 
-e POSTGRES_USER=truckuser 
-e POSTGRES_PASSWORD=truckpassword 
-v truck-signs-db-data:/var/lib/postgresql/data 
postgres:15
```

> Replace `truckdb`, `truckuser`, `truckpassword` with your `.env` values if needed.

---

### 🚀 Build and Run Backend Container

Build the Docker image:

```
docker build -t truck-signs-api .
```

Run the backend container:

```
docker run -d 
--name truck-signs-api 
--network truck-signs-net 
--restart always 
--env-file .env 
-p 8020:8020 
truck-signs-api
```

> The backend will automatically:
>
> * Wait for PostgreSQL
> * Run `collectstatic`
> * Run `makemigrations` + `migrate`
> * Create a superuser if it does not exist
> * Start Gunicorn WSGI on port 8020

---

### 🚀 Verify

Check running containers:

```
docker ps
```

Follow backend logs:

```
docker logs -f truck-signs-api
```


You can check our your localhost at port 8020:
```
http://localhost:8020
```

Admin panel:

```
http://localhost:8020/admin
```

Or if running on a server with a public IP:
```
http://<your-ip>:8080
```

Admin panel:

```
http://<your-ip>:8020/admin
```


---

### 🐳 Docker Management Commands

| Command                                    | Description                            |
| ------------------------------------------ | -------------------------------------- |
| `docker build -t truck-signs-api .`        | Build the Docker image.                |
| `docker run -d --name truck-signs-api ...` | Run the backend container.             |
| `docker rm -f truck-signs-api`             | Stop and remove the backend container. |
| `docker restart truck-signs-api`           | Restart the backend container.         |
| `docker logs -f truck-signs-api`           | Follow backend logs in real time.      |
| `docker ps`                                | List running containers.               |
| `docker network ls`                        | List Docker networks.                  |
| `docker volume ls`                         | List Docker volumes.                   |

> Postgres container should **never be removed** unless you want to lose all data.

---

## Project Checklist

You can find a detailed checklist for this project in PDF format:

- [Download the Checklist](../wordpress-docker/docs/checklist.pdf)