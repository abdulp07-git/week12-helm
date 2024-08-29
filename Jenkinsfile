pipeline {
    agent any
    triggers {
        githubPush()
    }
    environment {
        SONAR_ORG = 'abdulp07-git'
        SONAR_PROJECT_KEY = 'abdulp07-git_jenkins-week9'
        SONAR_TOKEN = credentials('SonarCloudToken')  // Retrieves the token stored as Jenkins credential
    }

    stages {
        stage('CheckOut') {
            steps {
                git 'https://github.com/abdulp07-git/jenkins-week9.git'
            }
        }
        stage('Unit Test') {  // New stage for unit testing
            steps {
                sh 'mvn test'  // Runs the unit tests
            }
            //post {
              //  always {
                //    junit '**/target/surefire-reports/*.xml'  // Publishes the test results
                //}
            //}
        }
        stage('SonarCloud analysis') {
            steps {
                withSonarQubeEnv('MySonarCloud') {
                    sh  '''
			#!/bin/bash
			mvn clean verify sonar:sonar \
                        -Dsonar.login=${SONAR_TOKEN} \
                        -Dsonar.host.url=https://sonarcloud.io \
                        -Dsonar.organization=${SONAR_ORG} \
                        -Dsonar.projectKey=${SONAR_PROJECT_KEY}
		    '''
                }
            }
        }
        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') { 
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage("Build") {
            steps {
                sh 'mvn clean package'
                archiveArtifacts artifacts: '**/target/*.war', allowEmptyArchive: true
            }
        }
        stage("Deploy") {
            steps {
                deploy adapters: [tomcat9(credentialsId: 'Tomcat_deployer', path: '', url: 'http://abdjenkins.com:8081/manager/html')], contextPath: 'Web application', war: '**/*.war'
            }
        }
    }
}

