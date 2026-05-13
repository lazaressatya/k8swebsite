pipeline {
    agent any

    environment {
        IMAGE_NAME = "lazares/k8sstaticwebsite"
        TAG = "v1.0-${BUILD_NUMBER}"

        // Jenkins credentials IDs
        DOCKER_CREDS = "dockerhub-creds"
        KUBE_CONFIG  = "kubeconfig-file"

        // GitHub Repo
        GIT_URL = "https://github.com/lazaressatya/k8swebsite.git"
    }

    stages {

        stage('Checkout Code from GitHub') {
            steps {
                git branch: "main", url: "${GIT_URL}"
            }
        }

        stage('Build Docker Image') {
            steps {
                bat "docker build -t %IMAGE_NAME%:%TAG% ."
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: DOCKER_CREDS,
                    usernameVariable: "DOCKER_USER",
                    passwordVariable: "DOCKER_PASS"
                )]) {

                    bat '''
                    docker login -u %DOCKER_USER% -p %DOCKER_PASS%
                    docker push %IMAGE_NAME%:%TAG%
                    docker logout
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([file(credentialsId: KUBE_CONFIG, variable: "KUBECONFIG")]) {

                     bat '''
                    set KUBECONFIG=%KUBECONFIG%

                    kubectl config current-context
                    kubectl get nodes

                    kubectl create namespace website --dry-run=client -o yaml | kubectl apply -f -

                    kubectl apply -f deployment.yml
                    kubectl apply -f service.yml

                    kubectl set image deployment/k8sstatic-web-deployment ^
                    k8sstatic-webs=%IMAGE_NAME%:%TAG% -n website

                    kubectl rollout status deployment/k8sstatic-web-deployment -n website

                    minikube service k8sstatic-web-service -n website
                    '''
                }
            }
        }
    }
}
