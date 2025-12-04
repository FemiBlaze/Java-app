pipeline {
    agent any

    tools {
        maven 'maven3'
        jdk 'jdk17'
    }

    stages {
        stage ('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Run Sonar Cloud Analysis') {
            steps {
                withCredentials([string(credentialsId: 'SONAR_TOKEN', variable: 'SONAR_TOKEN')]) {
                    sh 'mvn clean verify sonar:sonar -Dsonar.login=$SONAR_TOKEN -Dsonar.organization=femiblaze -Dsonar.host.url=https://sonarcloud.io -Dsonar.projectKey=femiblaze_java-app'
                }
            }
        }
        stage('Build Java Application') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage ('Synk Scan') {
            tools {
                jdk 'jdk17'
                maven 'maven3'
            }
            environment {
                SNYK_TOKEN = credentials('SNYK_TOKEN')
            }
            steps {
                dir("$WORKSPACE") {
                    sh """
                        chmod +x mvnw
                        ./mvnw dependency:tree -DoutputType=dot
                        snyk test --all-projects --severity-threshold=medium
                    """
                }
            }
        }
        
            
        stage ('Build Docker Image') {
            steps {
                sh 'docker build -t femiblaze/my-java-app:v1 .'
            }
        }

        stage ('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'DOCKER_LOGIN',
                    usernameVariable: 'USERNAME',
                    passwordVariable: 'PASSWORD'
                )]) {
                    sh '''
                        echo $PASSWORD | docker login -u $USERNAME --password-stdin
                        docker push femiblaze/my-java-app:v1
                        docker logout
                    '''
                }
            }
        }
    }

    post {
        success {
            echo '✅ Build and Docker image-push successful'
        }
        failure {
            echo '❌ Build failed. Check the logs for details.'
            }
  }

}
    
        