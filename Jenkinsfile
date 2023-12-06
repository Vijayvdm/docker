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
                sh 'docker build -t samplewebapp:latest .'
                sh 'docker tag samplewebapp aswarda/samplewebapp:latest'
                //sh 'docker tag samplewebapp nikhilnidhi/samplewebapp:$BUILD_NUMBER'
            }
        }

        stage('Publish image to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: "dockerHub", url: ""]) {
                    sh 'docker push aswarda/samplewebapp:latest'
                    //  sh 'docker push nikhilnidhi/samplewebapp:$BUILD_NUMBER' 
                }
            }
        }

        stage('Run Docker container on Jenkins Agent') {
            steps {
                sh "docker run -d -p 8003:8080 nikhilnidhi/samplewebapp"
            }
        }

        stage('Run Docker container on remote hosts') {
            steps {
                sh "docker -H ssh://jenkins@34.93.38.164 run -d -p 8003:8080 nikhilnidhi/samplewebapp"
            }
        }
    }
}
