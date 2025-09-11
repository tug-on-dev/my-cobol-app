# Container Architecture

## Microservices Architecture Overview

The containerized architecture transforms monolithic COBOL programs into a distributed microservices ecosystem, providing improved scalability, maintainability, and deployment flexibility.

## High-Level Architecture

```mermaid
graph TB
    subgraph "Client Layer"
        WEB[Web Applications]
        MOBILE[Mobile Apps]
        API[API Clients]
    end
    
    subgraph "Gateway Layer"
        INGRESS[Ingress Controller]
        GATEWAY[API Gateway]
        LOAD_BALANCER[Load Balancer]
    end
    
    subgraph "Service Mesh"
        ISTIO[Istio Service Mesh]
        ENVOY[Envoy Proxies]
        MTLS[Mutual TLS]
    end
    
    subgraph "Application Services"
        ACCOUNT[Account Service]
        PAYROLL[Payroll Service]
        REPORT[Report Service]
        NOTIFICATION[Notification Service]
    end
    
    subgraph "Data Services"
        POSTGRES[PostgreSQL]
        REDIS[Redis Cache]
        ELASTICSEARCH[Elasticsearch]
    end
    
    subgraph "Platform Services"
        CONFIG[Config Service]
        DISCOVERY[Service Discovery]
        CIRCUIT[Circuit Breaker]
        MONITORING[Monitoring]
    end
    
    WEB --> INGRESS
    MOBILE --> INGRESS
    API --> INGRESS
    
    INGRESS --> GATEWAY
    GATEWAY --> LOAD_BALANCER
    
    LOAD_BALANCER --> ISTIO
    ISTIO --> ENVOY
    ENVOY --> MTLS
    
    MTLS --> ACCOUNT
    MTLS --> PAYROLL
    MTLS --> REPORT
    MTLS --> NOTIFICATION
    
    ACCOUNT --> POSTGRES
    PAYROLL --> POSTGRES
    REPORT --> ELASTICSEARCH
    
    ACCOUNT --> REDIS
    PAYROLL --> REDIS
    
    ACCOUNT --> CONFIG
    PAYROLL --> CONFIG
    REPORT --> CONFIG
    
    CONFIG --> DISCOVERY
    DISCOVERY --> CIRCUIT
    CIRCUIT --> MONITORING
```

## Service Decomposition Strategy

### Domain-Driven Design Approach

```mermaid
graph TB
    subgraph "Account Management Domain"
        ACCOUNT_AGGREGATE[Account Aggregate]
        CUSTOMER_AGGREGATE[Customer Aggregate]
        ACCOUNT_SERVICE[Account Service]
        CUSTOMER_SERVICE[Customer Service]
        
        ACCOUNT_AGGREGATE --> ACCOUNT_SERVICE
        CUSTOMER_AGGREGATE --> CUSTOMER_SERVICE
    end
    
    subgraph "Payroll Domain"
        EMPLOYEE_AGGREGATE[Employee Aggregate]
        PAYROLL_AGGREGATE[Payroll Aggregate]
        EMPLOYEE_SERVICE[Employee Service]
        PAYROLL_SERVICE[Payroll Service]
        
        EMPLOYEE_AGGREGATE --> EMPLOYEE_SERVICE
        PAYROLL_AGGREGATE --> PAYROLL_SERVICE
    end
    
    subgraph "Reporting Domain"
        REPORT_AGGREGATE[Report Aggregate]
        ANALYTICS_AGGREGATE[Analytics Aggregate]
        REPORT_SERVICE[Report Service]
        ANALYTICS_SERVICE[Analytics Service]
        
        REPORT_AGGREGATE --> REPORT_SERVICE
        ANALYTICS_AGGREGATE --> ANALYTICS_SERVICE
    end
    
    subgraph "Shared Kernel"
        COMMON_TYPES[Common Types]
        SHARED_UTILS[Shared Utilities]
        EVENTS[Domain Events]
    end
    
    ACCOUNT_SERVICE -.-> COMMON_TYPES
    PAYROLL_SERVICE -.-> COMMON_TYPES
    REPORT_SERVICE -.-> COMMON_TYPES
    
    ACCOUNT_SERVICE -.-> EVENTS
    PAYROLL_SERVICE -.-> EVENTS
    REPORT_SERVICE -.-> EVENTS
```

## Container Design Patterns

### 1. Sidecar Pattern

```mermaid
graph LR
    subgraph "Application Pod"
        APP[Application Container<br/>Account Service]
        SIDECAR[Sidecar Container<br/>Logging Agent]
        PROXY[Proxy Container<br/>Envoy Proxy]
    end
    
    subgraph "External Services"
        LOG_SYSTEM[Centralized Logging]
        METRICS[Metrics Collection]
        TRACING[Distributed Tracing]
    end
    
    APP <--> SIDECAR
    APP <--> PROXY
    
    SIDECAR --> LOG_SYSTEM
    PROXY --> METRICS
    PROXY --> TRACING
```

**Implementation Example:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: account-service-pod
spec:
  containers:
  # Main application container
  - name: account-service
    image: company-registry/account-service:latest
    ports:
    - containerPort: 8080
    resources:
      limits:
        memory: "1Gi"
        cpu: "500m"
      requests:
        memory: "512Mi"
        cpu: "250m"
    
  # Sidecar: Logging agent
  - name: filebeat
    image: docker.elastic.co/beats/filebeat:8.8.0
    volumeMounts:
    - name: app-logs
      mountPath: /app/logs
    - name: filebeat-config
      mountPath: /usr/share/filebeat/filebeat.yml
      subPath: filebeat.yml
    
  # Sidecar: Monitoring agent
  - name: prometheus-exporter
    image: prom/jmx-exporter:latest
    ports:
    - containerPort: 9090
    volumeMounts:
    - name: jmx-config
      mountPath: /opt/jmx_prometheus_javaagent.yml
      subPath: config.yml
  
  volumes:
  - name: app-logs
    emptyDir: {}
  - name: filebeat-config
    configMap:
      name: filebeat-config
  - name: jmx-config
    configMap:
      name: jmx-config
```

### 2. Ambassador Pattern

```mermaid
graph TB
    subgraph "Application Pod"
        APP[Application Container]
        AMBASSADOR[Ambassador Container<br/>Database Proxy]
    end
    
    subgraph "External Dependencies"
        DB_PRIMARY[Primary Database]
        DB_READONLY[Read Replica]
        CACHE[Redis Cache]
    end
    
    APP --> AMBASSADOR
    AMBASSADOR --> DB_PRIMARY
    AMBASSADOR --> DB_READONLY
    AMBASSADOR --> CACHE
```

**Database Connection Proxy:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: payroll-service-pod
spec:
  containers:
  - name: payroll-service
    image: company-registry/payroll-service:latest
    env:
    - name: DATABASE_URL
      value: "jdbc:postgresql://localhost:5432/payroll"
    
  - name: db-ambassador
    image: haproxy:alpine
    ports:
    - containerPort: 5432
    volumeMounts:
    - name: haproxy-config
      mountPath: /usr/local/etc/haproxy/haproxy.cfg
      subPath: haproxy.cfg
  
  volumes:
  - name: haproxy-config
    configMap:
      name: db-proxy-config
```

### 3. Adapter Pattern

```mermaid
graph LR
    subgraph "Legacy Integration Pod"
        APP[Modern Application]
        ADAPTER[Protocol Adapter<br/>COBOL/Mainframe Bridge]
    end
    
    subgraph "Legacy Systems"
        MAINFRAME[Mainframe System]
        COBOL_SERVICES[COBOL Services]
    end
    
    APP --> ADAPTER
    ADAPTER --> MAINFRAME
    ADAPTER --> COBOL_SERVICES
```

## Service Communication Patterns

### 1. Synchronous Communication

```mermaid
sequenceDiagram
    participant Client
    participant Gateway
    participant AccountService
    participant PayrollService
    participant Database
    
    Client->>Gateway: POST /payroll/calculate
    Gateway->>PayrollService: Forward Request
    PayrollService->>AccountService: GET /accounts/{id}
    AccountService->>Database: Query Account
    Database-->>AccountService: Account Data
    AccountService-->>PayrollService: Account Response
    PayrollService->>Database: Save Payroll
    Database-->>PayrollService: Confirmation
    PayrollService-->>Gateway: Payroll Result
    Gateway-->>Client: Response
```

### 2. Asynchronous Communication

```mermaid
sequenceDiagram
    participant AccountService
    participant MessageBroker
    participant PayrollService
    participant NotificationService
    participant AuditService
    
    AccountService->>MessageBroker: Publish AccountUpdated Event
    MessageBroker->>PayrollService: Consume Event
    MessageBroker->>NotificationService: Consume Event
    MessageBroker->>AuditService: Consume Event
    
    PayrollService->>PayrollService: Update Payroll Data
    NotificationService->>NotificationService: Send Notification
    AuditService->>AuditService: Log Audit Trail
```

### Event-Driven Architecture Implementation

```yaml
# Kafka cluster for event streaming
apiVersion: kafka.strimzi.io/v1beta2
kind: Kafka
metadata:
  name: event-cluster
spec:
  kafka:
    version: 3.5.0
    replicas: 3
    listeners:
      - name: plain
        port: 9092
        type: internal
        tls: false
      - name: tls
        port: 9093
        type: internal
        tls: true
    config:
      offsets.topic.replication.factor: 3
      transaction.state.log.replication.factor: 3
      transaction.state.log.min.isr: 2
      default.replication.factor: 3
      min.insync.replicas: 2
    storage:
      type: persistent-claim
      size: 100Gi
      class: fast-ssd
  zookeeper:
    replicas: 3
    storage:
      type: persistent-claim
      size: 10Gi
      class: fast-ssd
```

## Data Management Patterns

### 1. Database per Service

```mermaid
graph TB
    subgraph "Account Service"
        ACC_APP[Account Application]
        ACC_DB[(Account Database)]
        ACC_APP --> ACC_DB
    end
    
    subgraph "Payroll Service"
        PAY_APP[Payroll Application]
        PAY_DB[(Payroll Database)]
        PAY_APP --> PAY_DB
    end
    
    subgraph "Report Service"
        REP_APP[Report Application]
        REP_DB[(Analytics Database)]
        REP_APP --> REP_DB
    end
    
    subgraph "Data Synchronization"
        EVENT_BUS[Event Bus]
        CDC[Change Data Capture]
        ETL[ETL Pipeline]
    end
    
    ACC_DB -.-> EVENT_BUS
    PAY_DB -.-> EVENT_BUS
    EVENT_BUS --> CDC
    CDC --> ETL
    ETL --> REP_DB
```

### 2. CQRS (Command Query Responsibility Segregation)

```mermaid
graph TB
    subgraph "Command Side"
        COMMAND_API[Command API]
        COMMAND_HANDLERS[Command Handlers]
        WRITE_DB[(Write Database)]
        
        COMMAND_API --> COMMAND_HANDLERS
        COMMAND_HANDLERS --> WRITE_DB
    end
    
    subgraph "Query Side"
        QUERY_API[Query API]
        READ_MODELS[Read Models]
        READ_DB[(Read Database)]
        
        QUERY_API --> READ_MODELS
        READ_MODELS --> READ_DB
    end
    
    subgraph "Event Stream"
        EVENTS[Domain Events]
        PROJECTIONS[Event Projections]
    end
    
    COMMAND_HANDLERS --> EVENTS
    EVENTS --> PROJECTIONS
    PROJECTIONS --> READ_DB
```

## Resilience Patterns

### 1. Circuit Breaker Pattern

```java
@Component
public class AccountServiceClient {
    
    private final RestTemplate restTemplate;
    private final CircuitBreaker circuitBreaker;
    
    public AccountServiceClient() {
        this.circuitBreaker = CircuitBreaker.ofDefaults("accountService");
        this.circuitBreaker.getEventPublisher()
            .onStateTransition(event -> 
                log.info("Circuit breaker state transition: {}", event));
    }
    
    public Account getAccount(String accountId) {
        return circuitBreaker.executeSupplier(() -> {
            return restTemplate.getForObject(
                "/accounts/{id}", Account.class, accountId);
        });
    }
}
```

### 2. Retry Pattern with Exponential Backoff

```java
@Component
public class PayrollServiceClient {
    
    @Retryable(
        value = {ServiceUnavailableException.class},
        maxAttempts = 3,
        backoff = @Backoff(delay = 1000, multiplier = 2)
    )
    public PayrollResult calculatePayroll(PayrollRequest request) {
        return restTemplate.postForObject(
            "/payroll/calculate", request, PayrollResult.class);
    }
    
    @Recover
    public PayrollResult recover(ServiceUnavailableException ex, PayrollRequest request) {
        log.warn("Payroll calculation failed after retries, using fallback");
        return PayrollResult.fallback(request);
    }
}
```

### 3. Bulkhead Pattern

```yaml
# Resource isolation using separate node pools
apiVersion: v1
kind: Namespace
metadata:
  name: critical-services
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: account-service
  namespace: critical-services
spec:
  replicas: 5
  template:
    spec:
      nodeSelector:
        workload-type: "critical"
      tolerations:
      - key: "critical-workload"
        operator: "Equal"
        value: "true"
        effect: "NoSchedule"
      containers:
      - name: account-service
        image: company-registry/account-service:latest
        resources:
          limits:
            memory: "2Gi"
            cpu: "1000m"
          requests:
            memory: "1Gi"
            cpu: "500m"
```

## Security Architecture

### 1. Zero Trust Network Model

```mermaid
graph TB
    subgraph "Security Layers"
        IDENTITY[Identity & Access<br/>OAuth 2.0 / JWT]
        NETWORK[Network Security<br/>Service Mesh / mTLS]
        APPLICATION[Application Security<br/>RBAC / Policies]
        DATA[Data Security<br/>Encryption / Masking]
    end
    
    subgraph "Security Controls"
        WAF[Web Application Firewall]
        API_GATEWAY[API Gateway Security]
        SERVICE_MESH[Service Mesh Security]
        SECRET_MGMT[Secret Management]
    end
    
    IDENTITY --> WAF
    NETWORK --> API_GATEWAY
    APPLICATION --> SERVICE_MESH
    DATA --> SECRET_MGMT
```

### 2. Service Mesh Security Implementation

```yaml
# Istio security policy
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: default
  namespace: production
spec:
  mtls:
    mode: STRICT
---
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: account-service-authz
  namespace: production
spec:
  selector:
    matchLabels:
      app: account-service
  rules:
  - from:
    - source:
        principals: ["cluster.local/ns/production/sa/api-gateway"]
    to:
    - operation:
        methods: ["GET", "POST", "PUT"]
        paths: ["/api/v1/accounts/*"]
  - from:
    - source:
        principals: ["cluster.local/ns/production/sa/payroll-service"]
    to:
    - operation:
        methods: ["GET"]
        paths: ["/api/v1/accounts/*"]
```

## Monitoring and Observability

### Three Pillars of Observability

```mermaid
graph TB
    subgraph "Observability Stack"
        METRICS[Metrics<br/>Prometheus + Grafana]
        LOGS[Logs<br/>ELK Stack]
        TRACES[Traces<br/>Jaeger/Zipkin]
    end
    
    subgraph "Application Insights"
        HEALTH[Health Checks]
        PERF[Performance Metrics]
        BUSINESS[Business Metrics]
        ALERTS[Alerting Rules]
    end
    
    METRICS --> HEALTH
    METRICS --> PERF
    METRICS --> BUSINESS
    METRICS --> ALERTS
    
    LOGS --> PERF
    TRACES --> PERF
```

### Monitoring Configuration

```yaml
# Service monitor for Prometheus
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: account-service-monitor
spec:
  selector:
    matchLabels:
      app: account-service
  endpoints:
  - port: http
    path: /actuator/prometheus
    interval: 30s
    scrapeTimeout: 10s
---
# Grafana dashboard ConfigMap
apiVersion: v1
kind: ConfigMap
metadata:
  name: account-service-dashboard
data:
  dashboard.json: |
    {
      "dashboard": {
        "title": "Account Service Metrics",
        "panels": [
          {
            "title": "Request Rate",
            "type": "graph",
            "targets": [
              {
                "expr": "rate(http_requests_total{service=\"account-service\"}[5m])"
              }
            ]
          }
        ]
      }
    }
```

This container architecture provides a robust, scalable, and maintainable foundation for migrated COBOL applications, incorporating modern cloud-native patterns and best practices for enterprise-grade systems.