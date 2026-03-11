
pipeline {   
    agent any
    tools {
        nodejs 'nodejs18'
    }
    stages {
        stage("Build") {
            steps {
                script {
                    echo "Building The Application."
                    sh 'npm ci'
                }
            }
        }
        stage("Test") {
            steps {
                script {
                    echo "Testing The Application."
                    sh 'npm test'
                }
            }
        }
        
        stage("Build Image") {
            steps {
                script {
                    def IMAGE_NAME = "NODEAPP-1.0"
                    echo "Building The Docker Image."
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]){
                        sh "docker build -t vatcharadze/demo-app:${IMAGE_NAME} ."
                        sh 'echo $PASS | docker login -u $USER --password-stdin'
                        sh "docker push nanatwn/demo-app:${IMAGE_NAME}"

                    }
                }
            }
        }

        stage("deploy") {
            steps {
                script {
                    echo "Deploying The Application."
                }
            }
        }               
    }
} 


