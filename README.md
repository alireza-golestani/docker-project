# ShopStream – E-Commerce Platform

## Overview

**ShopStream** is a production-ready, scalable e-commerce platform built using **Docker Swarm**. It is designed with a **microservices architecture** to handle core functionalities such as:

- User Authentication and Sessions
- Product Catalog and Search
- Shopping Cart Management
- Order Processing
- Real-Time Notifications
- Centralized Logging
- Full Observability (Metrics, Alerts, Dashboards)

This project aims to showcase DevOps principles, with a focus on **automation**, **scalability**, **availability**, and **fault tolerance**.

## Features

- **Docker Swarm** for orchestration and scaling
- **Traefik** as reverse proxy and SSL termination
- **Multi-replica services** to ensure high availability
- **Secret management** using Docker Secrets
- **Networking isolation** for better security and performance
- **Rolling updates** with zero downtime
- **Persistent storage** for stateful services (using Docker Volumes)
- **Monitoring** with Prometheus and Grafana
- **Centralized logging** using Loki and Promtail

## Architecture

The platform is built on the following **microservices**:

### Edge Layer
- **Traefik**: Reverse proxy for routing traffic to services with SSL termination and load balancing.

### Application Layer
- **Frontend Service**: A static web application served via Nginx.
- **API Gateway**: Handles API request routing and authentication.
- **Authentication Service**: Manages user sessions and JWT token generation.
- **Product Service**: Manages product catalog and search functionality.
- **Order Service**: Handles order creation, processing, and payment.
- **Notification Service**: Sends real-time notifications via WebSockets.

### Data Layer
- **MariaDB**: Primary relational database.
- **Redis**: Caching and session management.
- **RabbitMQ**: Message broker for asynchronous communication.
- **MinIO**: Object storage for product images.
- **Elasticsearch**: Full-text search for product catalog.

### Observability Layer
- **Prometheus**: Metrics collection.
- **Grafana**: Dashboards and monitoring.
- **Loki**: Centralized logging.
- **Promtail**: Collects logs from nodes and sends to Loki.

## Setup Instructions

### Prerequisites
1. **Docker**: Docker 20.10 or later.
2. **Docker Swarm**: At least 3 nodes (1 manager, 2 workers).
3. **Git**: To clone this repository.

### Deployment Steps

1. **Clone the repository:**
    ```bash
    git clone https://github.com/<your-username>/ShopStream.git
    cd ShopStream
    ```

2. **Deploy the stack:**
    - Make sure Docker Swarm is initialized and the nodes are joined.
    - Deploy the stack using:
      ```bash
      docker stack deploy -c docker-stack.yml shopstream
      ```

3. **Check the deployment status:**
    ```bash
    docker service ls
    docker service ps shopstream_frontend
    ```

4. **Access the application:**
    - Frontend should be accessible at `http://<manager-ip>:80`.

### Secrets and Configurations
- Docker secrets are created automatically during deployment (e.g., `db_root_password`, `jwt_secret`).
- Custom configurations for services like Traefik, Prometheus, and Grafana are stored in `configs/` directory.

### Testing the Deployment
- **Health Check**: Ensure services are running by visiting `/health` endpoint for each service.
- **Logs**: Check the logs for any service-related issues using `docker service logs`.

---

## Monitoring and Observability

The platform includes **Prometheus** and **Grafana** for monitoring:

- **Prometheus** collects metrics from Docker containers and hosts.
- **Grafana** visualizes metrics via preconfigured dashboards.

Access Grafana at `http://<manager-ip>:3000` with default credentials `admin:admin`.

## Secrets Management

- Sensitive information (e.g., database passwords, JWT secrets) is managed using **Docker secrets**.
- All sensitive data is injected securely into containers during runtime.

---

## Troubleshooting

1. **Service Fails to Start**: Check the logs using `docker service logs <service-name>`.
2. **Network Issues**: Ensure the correct networks are created and attached to services.
3. **Resource Constraints**: Ensure nodes have sufficient resources (CPU, RAM).

## Future Enhancements
- Implement advanced **auto-scaling** based on metrics.
- Add **CI/CD** pipeline for automated deployments.
- Integrate **payment gateway** for real-world order processing.

## Conclusion
This platform demonstrates how to set up a production-grade e-commerce system using Docker Swarm, with all essential features such as scalability, availability, security, and observability.

