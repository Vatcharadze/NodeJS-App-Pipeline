pipeline {   
    agent any
    //defining VERSION for no bug issues 
    environment {
        VERSION = ""
        DOCKER_REPO = "yourname/your-repo" //type your own DockerHub Repo name
    }
   //using nodejs for tool
    tools {
        nodejs 'nodejs18'
    }
    stages {
        //debug stage for making sure node is installed on container
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
        //increment version stage that increments version inside package.json
        stage('Increment Version') {
            steps {
                script {
                    echo "Incrementing Version"
                    sh 'cd app && npm version patch --no-git-tag-version'
                }
            }
        }
        //this stage gets us version which was incremented by previous stage so we can use that in Build Image stage
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
        //builds application
        stage("Build") {
            steps {
                script {
                    echo "Building The Application."
                    sh 'cd app && npm ci'
                }
            }
        }
        //tests application
        stage("Test") {
            steps {
                script {
                    echo "Testing The Application."
                    sh 'cd app && npm test'
                }
            }
        }
        //build image stage
        //using credentials to access dockerhub.This stage pushes built image in docker hub with its own incremented version
        stage("Build Image") {
            steps {
                script {
                    def IMAGE_TAG = "${VERSION}-${BUILD_NUMBER}" //using IMAGE_TAG as a main version identifier
                    echo "Building The Docker Image."
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-repo', passwordVariable: 'PASS', usernameVariable: 'USER')]){
                        sh "docker build -t ${DOCKER_REPO}:${IMAGE_TAG} ."
                        sh 'echo $PASS | docker login -u $USER --password-stdin'
                        sh "docker push ${DOCKER_REPO}:${IMAGE_TAG}"

                    }
                }
            }
        }
        //deploy stage. currently nothing's happening there
        stage("deploy") {
            steps {
                script {
                    echo "Deploying The Application."
                }
            }
        }               
    }
} 
