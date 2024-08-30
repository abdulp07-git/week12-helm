pipeline {
    
    agent { 
        label 'desktop' 
            
    }
    
    
    environment {
        DOCKERHUB_USER = credentials('dockerhub-username')
        DOCKERHUB_PASS = credentials('dockerhub-password')
        CHART_NAME = "mavenwebapp"
        AWS_DEFAULT_REGION = "ap-south-1"
        AWS_CREDENTIALS_ID = "aws-ecr-credentials"
        AWS_ACCOUNT_ID = "021891584638"
        ECR_REPO = 'abdulp07'
        ECR_REGION = "ap-south-1"
        
        
    }

    stages {
        stage('Chekout') {
            

            steps {
                // Get some code from a GitHub repository
                git 'https://github.com/abdulp07-git/week12-helm.git'

            }

        }
        
        
        stage('Unit test'){
            steps {
                sh 'mvn test'
            }
        }
        
        stage('Build'){
            steps {
                sh 'mvn clean package'
                archiveArtifacts artifacts: '**/target/*.war', allowEmptyArchive: true
            }
        }
        
        stage("tomcat-image"){
            steps {
                script {
                    def dockerImage = "abdulp07/tomcat_helm"
                    def tag = "v${BUILD_NUMBER}"
                    def fullImageName = "${dockerImage}:${tag}"
                    sh "docker build -t ${fullImageName} ."
                    
                }
                
            }
        }
        
        stage("Push image to docker hub"){
            steps {
                script {
                    def dockerImage = "abdulp07/tomcat_helm"
                    def tag = "v${BUILD_NUMBER}"
                    def fullImageName = "${dockerImage}:${tag}"
                    
                    sh '''
                    #!/bin/bash
                    
         echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin
                    '''

                    sh "docker push ${fullImageName}"
                    
                }
            }
            
            post {
                always {
                    sh 'docker logout'
                    sh 'docker rmi abdulp07/tomcat_helm:v${BUILD_NUMBER}'
                }
            }
        }
        
        
        stage ("Update new tag in Charts"){
            steps {
                sh './replacetag.sh'
                sh 'helm package $CHART_NAME'
                
            }
        }
        
        
        stage('Login to AWS ECR') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: "${AWS_CREDENTIALS_ID}"]]) {
                    script {
                        // Log in to AWS ECR
                        sh '''
                            aws ecr get-login-password --region ${AWS_DEFAULT_REGION} | \
                            helm registry login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
                        '''
                    }
                }
            }
        }
        
        
        stage('Push Helm Chart to ECR') {
            steps {
                script {
                    // Push the Helm chart to ECR
                    sh """
    # Check if the repository exists
    REPO_EXISTS=\$(aws ecr describe-repositories --repository-names "${CHART_NAME}" --region "${ECR_REGION}" --query "repositories[0].repositoryName" --output text 2>/dev/null)

    if [ "\${REPO_EXISTS}" != "${CHART_NAME}" ]; then
        
        echo "Creating repository ${CHART_NAME}..."
        aws ecr create-repository --repository-name "${CHART_NAME}" --region "${ECR_REGION}"
        echo "Repository ${CHART_NAME} created."
    fi
    
    # Push the Helm chart to the ECR repository
    helm push ${CHART_NAME}-*.tgz oci://${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_DEFAULT_REGION}.amazonaws.com
"""
                }
            }
        }
        
        
        
        
        
        
        
        
    }
}
