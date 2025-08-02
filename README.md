# Kubernetes-ecommerce-project

# E-Commerce Kubernetes Demo Project

A comprehensive Kubernetes project demonstrating real-world application deployment with microservices architecture, showcasing all major Kubernetes objects and Helm charts.

## 🏗️ Architecture Overview

This project implements a complete e-commerce platform with:

- **Frontend**: React-based web application (Nginx + Node.js)
- **Backend API**: Node.js REST API with Express
- **Payment Service**: Python Flask microservice
- **PostgreSQL**: Primary database
- **Redis**: Caching and session storage
- **Ingress**: Load balancing and routing
- **Monitoring**: Prometheus metrics integration

## 📋 Prerequisites

Before running this project, ensure you have:

- **Kubernetes cluster** (v1.20+)
  - Local: Minikube, Kind, Docker Desktop
  - Cloud: GKE, EKS, AKS
- **kubectl** configured to access your cluster
- **Helm 3.x** installed
- **Docker** (for building custom images)

### Quick Setup Verification

```bash
# Check kubectl connectivity
kubectl cluster-info

# Verify Helm installation
helm version

# Check available resources
kubectl get nodes
```

## 🚀 Quick Start

### Option 1: Deploy with Helm (Recommended)

```bash
# Clone the repository
git clone <repository-url>
cd ecommerce-k8s

# Make scripts executable
chmod +x scripts/*.sh

# Deploy using Helm
./scripts/deploy-app.sh

# Set up port forwarding for local access
./scripts/port-forward.sh
```

### Option 2: Deploy with Raw Manifests

```bash
# Deploy all components
./scripts/setup-cluster.sh

# Verify deployment
./scripts/test-deployment.sh
```

## 📁 Project Structure

```
ecommerce-k8s/
├── README.md                          # This file
├── docker/                            # Docker applications
│   ├── frontend/                      # React frontend
│   ├── backend/                       # Node.js API
│   └── payment-service/               # Python payment service
├── k8s-manifests/                     # Raw Kubernetes manifests
│   ├── namespace.yaml                 # Namespace definition
│   ├── configmaps/                    # Configuration data
│   ├── secrets/                       # Sensitive data
│   ├── storage/                       # Persistent volumes
│   ├── database/                      # Database deployments
│   ├── backend/                       # Backend service
│   ├── frontend/                      # Frontend service
│   ├── payment-service/               # Payment service
│   ├── monitoring/                    # Monitoring setup
│   └── rbac/                          # Security policies
├── helm-charts/                       # Helm charts
│   └── ecommerce-app/                 # Main application chart
│       ├── Chart.yaml                 # Chart metadata
│       ├── values.yaml                # Default values
│       ├── values-dev.yaml            # Development values
│       ├── values-prod.yaml           # Production values
│       └── templates/                 # Kubernetes templates
├── scripts/                           # Automation scripts
│   ├── setup-cluster.sh               # Complete setup
│   ├── deploy-app.sh                  # Helm deployment
│   ├── cleanup.sh                     # Resource cleanup
│   ├── port-forward.sh                # Local access
│   ├── test-deployment.sh             # Validation tests
│   └── scale.sh                       # Scaling operations
└── docs/                              # Additional documentation
    ├── architecture.md                # Architecture details
    ├── deployment-guide.md            # Deployment guide
    └── troubleshooting.md             # Common issues
```

## 🔧 Kubernetes Objects Demonstrated

### Core Resources
- **Namespaces**: Logical separation of resources
- **Pods**: Managed via Deployments and StatefulSets
- **Services**: ClusterIP, NodePort, LoadBalancer
- **ConfigMaps**: Application configuration
- **Secrets**: Sensitive data (passwords, API keys)
- **PersistentVolumes**: Database storage
- **PersistentVolumeClaims**: Storage requests

### Workload Controllers
- **Deployments**: Stateless applications (Frontend, Backend, Payment)
- **StatefulSets**: Stateful applications (PostgreSQL)
- **Jobs**: One-time tasks (Database migrations)
- **CronJobs**: Scheduled tasks (Database backups)

### Networking & Security
- **Ingress**: External access and load balancing
- **NetworkPolicies**: Traffic control between pods
- **ServiceAccounts**: Pod identity
- **RBAC**: Role-based access control
- **PodSecurityPolicies**: Security constraints

### Scaling & Monitoring
- **HorizontalPodAutoscaler**: Automatic scaling
- **PodDisruptionBudget**: Availability guarantees
- **ServiceMonitor**: Prometheus metrics collection
- **Custom Metrics**: Application-specific monitoring

## 🎯 Helm Features Showcased

### Chart Management
- **Dependencies**: External chart dependencies (PostgreSQL, Redis)
- **Hooks**: Pre/post deployment actions
- **Tests**: Deployment validation
- **Versioning**: Chart and application versioning

### Templating
- **Values**: Environment-specific configurations
- **Helpers**: Reusable template functions
- **Conditionals**: Feature toggles
- **Loops**: Dynamic resource generation

### Multi-Environment Support
- **Development**: `values-dev.yaml`
- **Staging**: `values-staging.yaml`
- **Production**: `values-prod.yaml`

## 🌐 Access the Application

### Local Development

1. **Start port forwarding**:
   ```bash
   ./scripts/port-forward.sh
   ```

2. **Access services**:
   - Frontend: http://localhost:8080
   - Backend API: http://localhost:3000
   - Payment Service: http://localhost:5000
   - PostgreSQL: localhost:5432
   - Redis: localhost:6379

### Production/Staging

1. **Configure DNS** (add to `/etc/hosts`):
   ```
   <INGRESS_IP> ecommerce.local api.ecommerce.local
   ```

2. **Access via domain**:
   - Frontend: http://ecommerce.local
   - API: http://api.ecommerce.local/api

## 📊 Monitoring and Observability

### Health Checks
All services implement comprehensive health checks:

```bash
# Check service health
curl http://localhost:8080/health
curl http://localhost:3000/api/health
curl http://localhost:5000/health
```

### Metrics
Prometheus metrics available at:
- Backend: `http://localhost:3000/metrics`
- Payment Service: `http://localhost:5000/metrics`

### Logging
View application logs:

```bash
# All pods in namespace
kubectl logs -f -l app.kubernetes.io/name=ecommerce-app -n ecommerce

# Specific service
kubectl logs -f deployment/backend-api -n ecommerce
kubectl logs -f deployment/frontend -n ecommerce
kubectl logs -f deployment/payment-service -n ecommerce
```

## 🔄 Operations

### Scaling

```bash
# Scale up for high traffic
./scripts/scale.sh up

# Scale down to save resources
./scripts/scale.sh down

# Enable auto-scaling
./scripts/scale.sh auto

# Check scaling status
./scripts/scale.sh status
```

### Updates and Rollbacks

```bash
# Update application
helm upgrade ecommerce-app ./helm-charts/ecommerce-app -n ecommerce

# Rollback to previous version
helm rollback ecommerce-app -n ecommerce

# View rollout history
kubectl rollout history deployment/backend-api -n ecommerce
```

### Database Operations

```bash
# Connect to PostgreSQL
kubectl exec -it statefulset/postgres -n ecommerce -- psql -U ecommerce -d ecommerce_db

# Create database backup
kubectl create job --from=cronjob/database-backup manual-backup -n ecommerce

# View backup status
kubectl get jobs -n ecommerce
```

## 🧪 Testing

### Automated Tests

```bash
# Run deployment validation
./scripts/test-deployment.sh

# Helm chart tests
helm test ecommerce-app -n ecommerce
```

### Manual Testing

```bash
# Test API endpoints
curl http://localhost:3000/api/products
curl http://localhost:3000/api/health

# Test payment processing
curl -X POST http://localhost:5000/payment/process \
  -H "Content-Type: application/json" \
  -d '{"amount": 99.99, "currency": "USD", "payment_method": "card"}'
```

## 🔒 Security Features

### Network Security
- **NetworkPolicies**: Restrict inter-pod communication
- **TLS**: Encrypted communication via Ingress
- **Private registries**: Secure image distribution

### Application Security
- **Non-root containers**: All containers run as non-root users
- **ReadOnlyRootFilesystem**: Immutable container filesystems
- **Resource limits**: Prevent resource exhaustion
- **Security contexts**: Fine-grained security controls

### Access Control
- **RBAC**: Role-based access control
- **ServiceAccounts**: Pod-level identity management
- **Secrets management**: Encrypted storage of sensitive data
- **Pod Security Standards**: Enforced security baselines

## 🛠️ Configuration Management

### Environment Variables
Key configuration options available via Helm values:

```yaml
# Example values.yaml customization
backend:
  replicaCount: 3
  image:
    tag: "v1.2.0"
  resources:
    limits:
      cpu: 1000m
      memory: 1Gi

postgresql:
  enabled: true
  auth:
    database: "ecommerce_prod"
    username: "ecommerce_user"

ingress:
  enabled: true
  hosts:
    - host: shop.company.com
```

### ConfigMaps and Secrets
Manage configuration and sensitive data:

```bash
# Update application config
kubectl edit configmap app-config -n ecommerce

# Update secrets (base64 encoded)
kubectl edit secret api-keys -n ecommerce

# Apply new configuration
kubectl rollout restart deployment/backend-api -n ecommerce
```

## 🚨 Troubleshooting

### Common Issues

#### 1. Pods in Pending State
```bash
# Check node resources
kubectl describe nodes

# Check PVC status
kubectl get pvc -n ecommerce

# Check events
kubectl get events -n ecommerce --sort-by='.lastTimestamp'
```

#### 2. Database Connection Issues
```bash
# Check database pod logs
kubectl logs statefulset/postgres -n ecommerce

# Test database connectivity
kubectl exec -it deployment/backend-api -n ecommerce -- nc -zv postgres 5432

# Check database secret
kubectl get secret db-secret -n ecommerce -o yaml
```

#### 3. Ingress Not Working
```bash
# Check ingress controller
kubectl get pods -n ingress-nginx

# Verify ingress configuration
kubectl describe ingress ecommerce-ingress -n ecommerce

# Check service endpoints
kubectl get endpoints -n ecommerce
```

#### 4. Application Errors
```bash
# Check application logs
kubectl logs -f deployment/backend-api -n ecommerce
kubectl logs -f deployment/payment-service -n ecommerce

# Check resource usage
kubectl top pods -n ecommerce

# Describe pod for events
kubectl describe pod <pod-name> -n ecommerce
```

### Debug Commands

```bash
# Interactive debugging
kubectl exec -it deployment/backend-api -n ecommerce -- /bin/sh

# Port forward for direct access
kubectl port-forward service/backend-api 3000:3000 -n ecommerce

# Check network connectivity
kubectl exec -it deployment/backend-api -n ecommerce -- nslookup postgres
```

## 📈 Performance Optimization

### Resource Management
```yaml
# Optimal resource configuration
resources:
  requests:
    cpu: 250m
    memory: 256Mi
  limits:
    cpu: 500m
    memory: 512Mi
```

### Autoscaling Configuration
```yaml
hpa:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70
  targetMemoryUtilizationPercentage: 80
```

### Database Performance
```bash
# Monitor database performance
kubectl exec -it statefulset/postgres -n ecommerce -- psql -U ecommerce -d ecommerce_db -c "
SELECT * FROM pg_stat_activity WHERE state = 'active';"

# Check database size
kubectl exec -it statefulset/postgres -n ecommerce -- psql -U ecommerce -d ecommerce_db -c "
SELECT pg_database_size('ecommerce_db');"
```

## 🔄 CI/CD Integration

### GitHub Actions Example
```yaml
# .github/workflows/deploy.yml
name: Deploy to Kubernetes
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Helm
      uses: azure/setup-helm@v3
      with:
        version: '3.10.0'
    
    - name: Deploy to Kubernetes
      run: |
        helm upgrade --install ecommerce-app ./helm-charts/ecommerce-app \
          --namespace ecommerce \
          --values helm-charts/ecommerce-app/values-prod.yaml \
          --wait
```

### GitLab CI Example
```yaml
# .gitlab-ci.yml
stages:
  - build
  - test
  - deploy

deploy:
  stage: deploy
  image: alpine/helm:latest
  script:
    - helm upgrade --install ecommerce-app ./helm-charts/ecommerce-app
      --namespace ecommerce
      --values helm-charts/ecommerce-app/values-prod.yaml
  only:
    - main
```

## 🌍 Multi-Environment Deployment

### Development Environment
```bash
./scripts/deploy-app.sh --environment development
```

### Staging Environment
```bash
./scripts/deploy-app.sh --environment staging --namespace ecommerce-staging
```

### Production Environment
```bash
./scripts/deploy-app.sh --environment production --namespace ecommerce-prod
```

## 📚 Learning Resources

### Kubernetes Concepts Covered
1. **Pod Lifecycle**: Understanding pod creation, scheduling, and termination
2. **Service Discovery**: How services communicate within the cluster
3. **Storage Management**: Persistent volumes and dynamic provisioning
4. **Network Policies**: Micro-segmentation and traffic control
5. **Resource Management**: CPU/memory requests and limits
6. **Security**: RBAC, service accounts, and pod security
7. **Monitoring**: Metrics collection and observability
8. **Scaling**: Manual and automatic scaling strategies

### Helm Best Practices Demonstrated
1. **Chart Structure**: Proper organization of templates and values
2. **Templating**: Advanced templating techniques
3. **Dependencies**: Managing external chart dependencies
4. **Hooks**: Lifecycle management with hooks
5. **Testing**: Chart testing and validation
6. **Versioning**: Semantic versioning for charts
7. **Values Management**: Environment-specific configurations

## 🤝 Contributing

### Development Setup
```bash
# Fork and clone the repository
git clone <your-fork-url>
cd ecommerce-k8s

# Create feature branch
git checkout -b feature/your-feature

# Make changes and test
./scripts/test-deployment.sh

# Commit and push
git commit -m "Add your feature"
git push origin feature/your-feature
```

### Testing Changes
```bash
# Validate Helm charts
helm lint helm-charts/ecommerce-app

# Test template rendering
helm template ecommerce-app helm-charts/ecommerce-app

# Dry run deployment
helm install ecommerce-app helm-charts/ecommerce-app --dry-run --debug
```

## 🧹 Cleanup

### Remove Everything
```bash
# Complete cleanup
./scripts/cleanup.sh

# Force cleanup (skip confirmation)
./scripts/cleanup.sh --force

# Cleanup specific namespace
./scripts/cleanup.sh --namespace ecommerce-staging
```

### Selective Cleanup
```bash
# Remove only application pods
kubectl delete deployment --all -n ecommerce

# Remove specific resources
kubectl delete ingress ecommerce-ingress -n ecommerce
kubectl delete hpa --all -n ecommerce
```

## 📞 Support and Issues

### Getting Help
1. **Check logs**: Always start with pod and service logs
2. **Describe resources**: Use `kubectl describe` for detailed information
3. **Check events**: Monitor cluster events for issues
4. **Verify configuration**: Ensure ConfigMaps and Secrets are correct

### Common Commands for Support
```bash
# Comprehensive status check
kubectl get all -n ecommerce
kubectl describe pods -n ecommerce
kubectl get events -n ecommerce --sort-by='.lastTimestamp'

# Resource usage
kubectl top nodes
kubectl top pods -n ecommerce

# Network diagnostics
kubectl exec -it deployment/backend-api -n ecommerce -- nslookup kubernetes.default
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🎯 What You'll Learn

By working through this project, you'll gain hands-on experience with:

1. **Kubernetes Architecture**: Understanding pods, services, and networking
2. **Container Orchestration**: Managing containerized applications at scale
3. **Microservices Deployment**: Deploying and managing microservices
4. **Service Mesh Concepts**: Traffic management and security
5. **Infrastructure as Code**: Using Helm for declarative deployments
6. **Observability**: Monitoring, logging, and metrics collection
7. **Security Best Practices**: Implementing security controls
8. **Scaling Strategies**: Manual and automatic scaling techniques
9. **CI/CD Integration**: Continuous deployment workflows
10. **Production Operations**: Managing production Kubernetes workloads

## 🚀 Next Steps

After mastering this project, consider exploring:

1. **Service Mesh**: Implement Istio or Linkerd
2. **Advanced Monitoring**: Set up Grafana dashboards
3. **Log Aggregation**: Implement ELK or EFK stack
4. **Security Scanning**: Integrate Falco or Twistlock
5. **GitOps**: Implement ArgoCD or Flux
6. **Multi-Cluster**: Federation and cross-cluster communication
7. **Serverless**: Explore Knative or OpenFaaS
8. **AI/ML Workloads**: Deploy ML models with Kubeflow

---

**Happy Learning! 🎉**

This comprehensive Kubernetes project provides a solid foundation for understanding container orchestration, microservices architecture, and modern DevOps practices. Start with the quick setup, explore the different components, and gradually dive deeper into advanced concepts.

For questions, issues, or contributions, please refer to the project repository and documentation.
