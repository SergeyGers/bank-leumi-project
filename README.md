
# Bank Leumi CI/CD Pipeline Project

This project demonstrates a CI/CD pipeline that automates the build, containerization, and deployment of a Python application using Jenkins, GitHub, Docker, EKS (Kubernetes), and AWS ECR. The application is exposed through an Ingress controller on port 443.

## Tools and Technologies Used:
- **Jenkins**: Used for automating the build, test, and deployment pipeline.
- **GitHub**: Version control system to store the source code and trigger Jenkins pipelines on code commits.
- **Docker**: Containerizes the application, creating an image that is deployed to Kubernetes.
- **AWS EKS (Elastic Kubernetes Service)**: Manages the Kubernetes cluster where the application is deployed.
- **AWS ECR (Elastic Container Registry)**: Stores Docker images for versioned and scalable deployment.
- **Ingress Controller**: Exposes the application on port 443 for external access.

## Features:
- **Automated CI/CD**: Automatically builds, tests, containerizes, and deploys the application whenever new code is pushed to the GitHub repository.
- **Docker Integration**: Builds a Docker image of the application.
- **AWS ECR Storage**: Pushes the built Docker images to AWS ECR for centralized and secure storage.
- **Kubernetes Deployment**: Deploys the Docker image from ECR to EKS, ensuring high availability and scalability.
- **Ingress Setup**: Exposes the application over HTTPS on port 443 using an NGINX Ingress controller.

## Pipeline Workflow:
1. **GitHub Integration**: 
   - Jenkins listens for changes in the GitHub repository and automatically triggers the pipeline when changes are committed to the main branch.
   
2. **Build and Test**:
   - Jenkins pulls the latest code from GitHub.
   - The application is built and tested using Python (or other supported languages).

3. **Dockerization**:
   - The application is containerized using Docker, and a Docker image is created.

4. **Push to ECR**:
   - The Docker image is tagged and pushed to AWS Elastic Container Registry (ECR) for storage.

5. **Kubernetes Deployment**:
   - The Jenkins pipeline deploys the Docker image from ECR to an AWS EKS cluster.
   - A Kubernetes deployment is applied using `deployment.yaml` and `service.yaml` files to manage the pods and services.

6. **Ingress Exposure**:
   - The application is exposed externally via an NGINX Ingress controller on port 443, allowing HTTPS access to the app.

## Infrastructure Details:
- **Kubernetes Cluster (EKS)**: The Kubernetes cluster is set up using AWS EKS to ensure scalability and reliability.
- **Docker Image**: Stored in AWS ECR for secure and versioned storage.
- **Jenkins Pipeline**: Fully declarative pipeline with steps for build, test, Docker image creation, and deployment to EKS.
- **Application Port**: The application runs inside the container on port 5000 and is exposed via Ingress on port 443.

## Configuration Files:
- **Jenkinsfile**: Contains the pipeline definition for Jenkins.
- **deployment.yaml**: Defines the Kubernetes deployment configuration.
- **service.yaml**: Manages Kubernetes service to expose the application internally.
- **ingress.yaml**: Sets up an NGINX Ingress controller to expose the application on port 443.

## Prerequisites:
- **Jenkins** configured with access to the AWS EKS and ECR.
- **AWS CLI** configured for interaction with EKS and ECR.
- **Docker** installed for building images locally.
- **GitHub** repository with webhooks set up to trigger Jenkins builds.

## How to Use:

1. **Clone the Repository**:
   Clone the GitHub repository containing the source code and Terraform files.

   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Set Up Jenkins**:
   - Configure Jenkins to pull the source code from GitHub.
   - Ensure Jenkins has AWS credentials for accessing EKS and ECR.
   - Create a `Jenkinsfile` in the project repository to define the pipeline stages.

3. **Deploy Kubernetes Resources**:
   - Apply the Kubernetes configuration files (`deployment.yaml`, `service.yaml`, and `ingress.yaml`) to deploy the application and expose it externally.

   ```bash
   kubectl apply -f deployment.yaml
   kubectl apply -f service.yaml
   kubectl apply -f ingress.yaml
   ```

4. **Access the Application**:
   The application is available at the external IP address or DNS name provided by the Ingress controller on port 443.

## Configuration Details:
- **EKS Cluster**: `bank-leumi-cluster`
- **Docker Image**: Stored in AWS ECR.
- **Service**: `bank-leumi-app-service`
- **Ingress**: NGINX Ingress controller configured to expose the app over HTTPS on port 443.

## Cleanup:
To clean up the resources created by this pipeline, delete the Kubernetes resources:

```bash
kubectl delete -f deployment.yaml
kubectl delete -f service.yaml
kubectl delete -f ingress.yaml
```

You can also delete the Docker images from ECR and tear down the Jenkins pipeline if necessary.

## Troubleshooting:
- **Ingress Not Responding**: Verify that the Ingress controller is properly set up and the application pods are running.
- **Pipeline Failure**: Check Jenkins logs for errors in the build, Dockerization, or deployment steps.
- **Deployment Issues**: Ensure that the correct AWS permissions are in place for Jenkins to access EKS and ECR.

## Author:
This CI/CD pipeline project was developed to automate the deployment of a Python-based application using Jenkins, Docker, AWS EKS, and ECR, with Ingress for secure external access.

## URL
    the website - a5ef772c5022a4818b863db0a33068cf-179798786.us-east-1.elb.amazonaws.com
