pipeline {

    agent { label 'slave' }

    environment {    
        DOCKERHUB_CREDENTIALS=credentials('dockerhub-PAT')
    }

    stages {
        stage('SCM_Checkout') {
            steps {
                echo 'Perform SCM Checkout'
                git 'https://github.com/aswin-2404/banking-finance.git'
            }
        }

        stage('Application Build') {
            steps {
                echo 'Perform Application Build'
                sh 'mvn clean package'
            }
        }

        stage('Docker Build') {
            steps {
                echo 'Perform Docker Build'
                sh "docker build -t aswin2404/banking-finance-app:${BUILD_NUMBER} ."
                sh "docker tag aswin2404/banking-finance-app:${BUILD_NUMBER} aswin2404/banking-finance-app:latest"
                sh 'docker image list'
            }
        }

        stage('Login to Dockerhub') {
            steps {
                echo 'Login to DockerHub'                
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u aswin2404 --password-stdin'
            }
        }

        stage('Publish the Image to Dockerhub') {
            steps {
                echo 'Publish to DockerHub'
                sh "docker push aswin2404/banking-finance-app:latest"                
            }
        }

        stage('Deploy to Kubernetes Cluster') {
            steps {
                script {
                    sshPublisher(publishers: [
                        sshPublisherDesc(
                            configName: 'kubernetes-master',
                            transfers: [
                                sshTransfer(
                                    cleanRemote: false,
                                    excludes: '',
                                    execCommand: '''
                                        kubectl apply -f kubernetesdeploy.yaml
                                        kubectl get pods
                                        kubectl get deploy
                                        kubectl get svc
                                    ''',
                                    execTimeout: 120000,
                                    flatten: false,
                                    makeEmptyDirs: false,
                                    noDefaultExcludes: false,
                                    patternSeparator: '[, ]+',
                                    remoteDirectory: '.',
                                    remoteDirectorySDF: false,
                                    removePrefix: '',
                                    sourceFiles: '*.yaml'
                                )
                            ],
                            usePromotionTimestamp: false,
                            useWorkspaceInPromotion: false,
                            verbose: true
                        )
                    ])
                }
            }
        }
    }
}

