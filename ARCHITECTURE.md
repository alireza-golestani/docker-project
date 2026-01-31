# ShopStream – Architecture & Planning Document

Author: Alireza Golestani  
Date: 2026-01-31


## 1. System Overview

ShopStream is a production-oriented e-commerce platform designed using a microservices architecture and deployed with Docker Swarm.

The goal of this system is to support core e-commerce capabilities such as user authentication, product catalog management, order processing, and notifications while ensuring scalability, high availability, and fault tolerance.

A microservices approach is used to allow independent development, deployment, and scaling of each service based on workload and responsibility.

Docker Swarm is selected as the container orchestrator to provide multi-node scheduling, service replication, rolling updates, self-healing, and built-in service discovery.

In this phase, the project focuses on planning and infrastructure setup only, including cluster design, networking, secrets, and persistence, without implementing full business logic.

---

## 2. Service Architecture

The platform is composed of multiple independent services, each responsible for a specific domain of the system. This separation improves scalability, maintainability, and fault isolation.

### 2.1 Edge Layer
- **Traefik**  
  Acts as the ingress controller and reverse proxy, handling incoming HTTP traffic, load balancing, and routing requests to internal services.

### 2.2 Application Layer
- **Frontend Service**  
  A static web application (SPA) served via Nginx, responsible for rendering the user interface and communicating with backend APIs.

- **API Gateway**  
  Serves as a single entry point for backend APIs, responsible for request routing, authentication validation, and basic rate limiting.

- **Authentication Service**  
  Handles user authentication, token generation (JWT), and session-related logic.

- **Product Service**  
  Manages product catalog operations including listing, creation, updates, and search integration.

- **Order Service**  
  Responsible for order creation, processing, and interaction with payment and inventory systems (mocked in this phase).

- **Notification Service**  
  Handles real-time notifications such as order status updates using WebSocket or asynchronous messaging.

### 2.3 Data Layer
- **MariaDB**  
  Primary relational database for persistent application data.

- **Redis**  
  Used for session storage, caching, and rate limiting.

- **RabbitMQ**  
  Message broker used for asynchronous communication between services.

- **MinIO**  
  Object storage for static assets such as product images.

- **Elasticsearch**  
  Provides full-text search capabilities for the product catalog.

### 2.4 Observability Layer
- **Prometheus**  
  Collects metrics from services and infrastructure.

- **Grafana**  
  Visualizes metrics through dashboards.

- **Loki**  
  Aggregates and stores logs from all services.

- **Promtail**  
  Collects logs from nodes and forwards them to Loki.

---

## 3. Network Design and Isolation

The platform uses multiple Docker overlay networks to enforce strict network isolation and follow the principle of least privilege.

### Networks
- **traefik-public**  
  Public-facing network used exclusively by Traefik to accept incoming traffic from the internet.

- **frontend**  
  Network connecting the frontend service with Traefik.

- **backend** (internal)  
  Internal network used by backend microservices. This network is not accessible externally.

- **data** (internal)  
  Dedicated internal network for databases and stateful services.

- **monitoring**  
  Network reserved for observability and monitoring components.

Services are attached only to the networks they require, preventing unauthorized access between layers.

---

## 4. Secrets Management

All sensitive information is managed using Docker Secrets to avoid hardcoding credentials in configuration files or version control.

### Secrets include:
- Database root and application passwords
- JWT signing keys
- Redis authentication password
- RabbitMQ credentials
- MinIO secret keys
- Grafana admin password
- TLS private keys (if applicable)

Secrets are injected into containers at runtime and never stored in images or source code.

---

## 5. Configuration Management

Non-sensitive configuration files are managed using Docker Configs. These configurations are version-controlled and mounted into containers at runtime.

### Configs include:
- Traefik configuration
- Nginx configuration for frontend
- Prometheus and Alertmanager configuration
- Grafana dashboards and datasources
- Loki configuration

---

## 6. Data Persistence Strategy

All stateful services use Docker volumes to ensure data persistence beyond the lifecycle of individual containers.

### Persistent volumes include:
- MariaDB data
- Redis data
- RabbitMQ data
- MinIO data
- Elasticsearch data
- Prometheus data
- Grafana data
- Loki data

This ensures that application data is preserved during restarts, updates, or failures.

---

## 7. Node Placement Strategy

Placement constraints are used to improve reliability and operational safety.

- Traefik and critical stateful services are scheduled on manager nodes.
- Stateless application services are distributed across worker nodes.
- Services are spread across nodes to maximize availability.

---

## 8. Deployment and Update Strategy

All services are deployed using Docker Stack with a declarative configuration.

Rolling updates are configured to ensure zero-downtime deployments:
- Services are updated one replica at a time.
- New containers start before old ones are stopped.
- Automatic rollback is triggered in case of failure.

---

## 9. Verification and Validation

The infrastructure setup is verified using the following commands:
- `docker node ls` to validate cluster state
- `docker network ls` to verify network creation
- `docker secret ls` to confirm secrets management

These checks ensure the platform is ready for application deployment in later phases.

