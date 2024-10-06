pipeline {
    agent {label 'agent_1'}
    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        ECR_REPOSITORY = '141330218853.dkr.ecr.us-east-1.amazonaws.com/bank-leumi-project-app'
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t bank-leumi-project-app .'
                }
            }
        }
    stage('Login to ECR') {
       steps {
           script {
               sh '''
               aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 141330218853.dkr.ecr.us-east-1.amazonaws.com
               '''
           }
       }
   }

        stage('Tag and Push Docker Image') {
            steps {
                script {
                    sh '''
                    docker tag bank-leumi-project-app:latest $ECR_REPOSITORY:latest
                    docker push $ECR_REPOSITORY:latest
                    '''
                }
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh '''
		    aws eks update-kubeconfig --name bank_leumi	
                    kubectl rollout restart deployment bank-leumi-app-deployment
                    '''
                }
            }
        }
    }
}

