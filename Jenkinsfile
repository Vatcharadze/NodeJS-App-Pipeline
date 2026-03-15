
pipeline {   
    agent any

    environment {
        VERSION = ""
    }

    tools {
        nodejs 'nodejs18'
    }
    stages {

        stage('Debug') {
            steps {
                script {
                sh 'node -v'
                sh 'npm -v'
                sh 'pwd'
                sh 'ls -la'
                }
             }
        }

        stage('Increment Version') {
            steps {
                script {
                    echo "Incrementing Version"
                    sh 'cd app && npm version patch --no-git-tag-version'
                }
            }
        }

        stage('Get New Version') {
            steps {
                script {
                    VERSION = sh(
                    script: "node -p \"require('./app/package.json').version\"",
                    returnStdout: true
                    ).trim()

                    echo "Application Version: ${VERSION}"
                }
            }
        }

        stage("Build") {
            steps {
                script {
                    echo "Building The Application."
                    sh 'cd app && npm ci'
                }
            }
        }
        stage("Test") {
            steps {
                script {
                    echo "Testing The Application."
                    sh 'cd app && npm test'
                }
            }
        }
        
        stage("Build Image") {
            steps {
                script {
                    def IMAGE_TAG = "${VERSION}-${BUILD_NUMBER}"
                    echo "Building The Docker Image."
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]){
                        sh "docker build -t vatcharadze/demo-app:${IMAGE_TAG} ."
                        sh 'echo $PASS | docker login -u $USER --password-stdin'
                        sh "docker push vatcharadze/demo-app:${IMAGE_TAG}"

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