#Below is a local setup to test the application in local dev envrionmnet using Docker Compose

#Part 1: Docker Compose Setup (40% of score)

📋 Prerequisites & Installation

This application is designed to run on a Linux-based system (AWS EC2 Amazon Linux 2 / Amazon Linux 2023)
- Operating System
Amazon Linux 2 / Amazon Linux 2023
Any Linux distribution that supports Docker

- Docker Engine (Required)
  
steps to install
```
sudo yum update -y
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
newgrp docker
```
Verify installation
```
docker --version
```

- Docker Compose v2 Plugin (Required)
Docker Compose v2 is installed as a Docker CLI plugin
```
mkdir -p ~/.docker/cli-plugins

curl -SL https://github.com/docker/compose/releases/download/v2.27.0/docker-compose-linux-x86_64 \
  -o ~/.docker/cli-plugins/docker-compose

chmod +x ~/.docker/cli-plugins/docker-compose
```
Verify installation
```
docker compose version
```

- Network / Firewall Requirements

Ensure the following inbound ports are allowed on the host (EC2 Security Group):
```
Port	Purpose
8080	Frontend web application
22	SSH access
```

<img width="1505" height="81" alt="image" src="https://github.com/user-attachments/assets/61fe58ec-ecbf-4441-8ad3-db6cd862a497" />


Why Docker compose?

For local env, we can use docker compose which helps run multiple containers as microservices and all are within one default private network created by docker compose

-----------------------------------------------------------------------------------------------------------------------
## High level overview
PostgreSQL (with a persistent volume)
Backend API (Node.js + Express) exposing:
GET /healthcheck
GET /message → returns "Hello World"

Frontend (React) that:
Calls /healthcheck
Calls /message
Displays results in the browser
-------------------------------------------------------------------------------------------------------------------------

#Database setup (postgres SQL DB)

PostgreSQL runs as a containerized service using a named Docker volume for persistent storage. The database does not expose any host ports and is only accessible to other services on the private Docker network

Docker stores Postgres data at: /var/lib/docker/volumes/axy-postgres-data
this way even if container dies, data is persisted on host machine and can be reused when new container is spinned up

<img width="771" height="213" alt="image" src="https://github.com/user-attachments/assets/46b71c10-f9d3-4737-82b4-203829c0f060" />


#Backend setup (Node.js + Express)
I have configured below two paths:

```
GET /healthcheck   → { "status": "ok" }
GET /message       → { "message": "Hello World" }
```

and for a simple test to connect to postgres db, i have used env variable file inplace of hardcoding the credentials in docker compose file, this will be pulled at runtime and hence there is no security concern for exposing db credentials
backend container is only accessible from frontend container, as i havent configured public port mapping here as seen in below snapshot

<img width="1898" height="302" alt="image" src="https://github.com/user-attachments/assets/4fbaae00-ba76-4758-94b2-58692912cd5e" />


#Frontend setup (React)
i have configured frontned to call backend for below two paths

```
Calls:
/healthcheck
/message

Displays:
ok
Hello World
```


1️⃣ All Services Communicate Over a Private Docker Network

Docker Compose automatically creates a private bridge network (e.g. axy_default)

All services (frontend, backend, db) are attached to this network

<img width="898" height="333" alt="image" src="https://github.com/user-attachments/assets/3de42fcd-e3f9-4190-b839-87093c79b8e5" />

And containers communicate using service names:
```
Service	Hostname used
Backend → DB	      db
Frontend → Backend	backend
```

✔️ Communication never leaves Docker’s internal network

2️⃣ Only the Frontend Is Exposed to the Host

<img width="1869" height="141" alt="image" src="https://github.com/user-attachments/assets/0d873c8b-ac4a-4a4b-b5b4-b2327684a342" />
here only frontned container has host port mapping , which  means only that is accessible from browser/host, i have all this setup done in one aws instance hence i am accessing this from public ip of the server(if running locally , use curl http://localhost:8080)

<img width="1232" height="356" alt="image" src="https://github.com/user-attachments/assets/e196235d-69c3-4563-9c51-ab22ca91e529" />

3️⃣ Backend & Database NOT Accessible Outside Docker Network

when i try to access backend container from public ip, it fails. This minimizes the attack surface and exposes single public entry point.
<img width="1498" height="751" alt="image" src="https://github.com/user-attachments/assets/4689c257-b024-44e0-8985-14bb128be602" />

A fully functional app is up and running on port 8080 using docker compose for local application development & testing

To run this application simply run below command from project root folder:
```
docker compose up -d --build
```

<img width="1541" height="676" alt="image" src="https://github.com/user-attachments/assets/8a1b2a48-f735-4623-860c-526472c0a941" />

To verify whether the application is working fine, hit the public ip of the server:8080 (or if running locally then curl http//:localhost:8080)
<img width="1919" height="434" alt="image" src="https://github.com/user-attachments/assets/f8399c62-dc91-4b8a-86bb-bcbb3c3f55f0" />

To stop the application:
```
docker compose down
```

To remove volumes (will delete DB data):
```
docker compose down -v
```


Key Design Decisions
1. Service Networking
Docker Compose automatically creates a shared network.
Backend connects to PostgreSQL via db:5432 (service name as DNS).

2. Persistent Database
PostgreSQL data stored in a named volume (postgres_data)
Data survives container restarts.

3. Environment-Driven Configuration
No hard-coded secrets in code.
Same pattern works in AWS (via ECS task definitions / Secrets Manager).

4. Independent Builds
Frontend and backend have their own Dockerfile
Mirrors how services are deployed independently in production.




