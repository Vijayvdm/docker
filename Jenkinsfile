pipeline {
    agent any

    tools {
        maven "Maven"
    }

    stages {
        stage('checkout') {
            steps {
                git branch: 'master', url: 'https://github.com/Vijayvdm/docker.git'
            }
        }
        
        stage('Execute Maven') {
            steps {
                sh 'mvn package'
            }
        }

        stage('Docker Build and Tag') {
            steps {
                // Build and tag Docker image
                sh 'docker build -t samplewebapp:latest .'
                sh 'docker tag samplewebapp:latest aswarda/samplewebapp:latest'
            }
        }

        stage('Publish image to Docker Hub') {
            steps {
                // Push Docker image to Docker Hub
                script {
                    withDockerRegistry([credentialsId: "dockerHub", url: ""]) {
                        sh 'docker push aswarda/samplewebapp:latest'
                    }
                }
            }
        }

        stage('Run Docker container on Jenkins Agent') {
            steps {
                // Run Docker container on Jenkins Agent
                sh 'docker run -d -p 8003:8080 aswarda/samplewebapp:latest'
            }
        }

        stage('Run Docker container on remote hosts') {
            steps {
                // Copy Docker image to remote host and run container
                script {
                    sh "docker save aswarda/samplewebapp:latest | ssh jenkins@34.93.38.164 'docker load'"
                    sh "ssh jenkins@34.93.38.164 'docker run -d -p 8003:8080 aswarda/samplewebapp:latest'"
                }
            }
        }
    }
}
