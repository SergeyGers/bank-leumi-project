Bank Leumi Project

This project automates the build and deployment of a Python application using Jenkins, Docker, and Kubernetes on AWS. The pipeline is fully declarative and triggers automatically when changes are pushed to the main branch in GitHub.

Tools Used:
Jenkins: CI/CD pipeline setup for automating the build, tag, and deployment.
Docker: For containerizing the Python application.
Kubernetes (EKS): Deployment platform for the application.
AWS: EC2 for Jenkins and EKS for Kubernetes.
Amazon ECR: Docker images are stored in ECR (Elastic Container Registry) for versioned storage.
Ingress: Manages external access to the application over HTTP/HTTPS.

Features:
Automatic Builds: Whenever code is pushed to GitHub, Jenkins triggers the build.
Docker Integration: Builds a Docker image of the Python app.
ECR Storage: Images are tagged and pushed to ECR for centralized image storage.
Kubernetes Deployment: Automatically deploys the application as a Kubernetes pod using EKS.
Exposed Application on Port 443: Application runs securely over HTTPS via Ingress.

Steps Taken:
GitHub Integration: Set up webhooks to trigger Jenkins builds on commits.
Docker Build: The application is containerized using a Dockerfile.
AWS ECR: The Docker image is tagged and pushed to ECR for storage.
Kubernetes Deployment: Deploys the image from ECR to EKS using deployment.yaml and service.yaml.
Ingress Configuration: Configured Ingress to expose the application on port 443 without SSL, using the provided ELB hostname.

Problems Solved:
Access Issues: Resolved IAM role access for Jenkins to interact with EKS.
ECR Authentication: Fixed Docker authentication to push images to AWS ECR.
Kubernetes Configuration: Ensured proper deployment and service YAML files were applied.
Ingress Configuration: Successfully exposed the application on port 443 and resolved access issues.

How to Reach the Website:
URL: https://a5ef772c5022a4818b863db0a33068cf-179798786.us-east-1.elb.amazonaws.com/