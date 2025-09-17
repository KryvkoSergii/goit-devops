pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: jenkins-kaniko
spec:
  serviceAccountName: jenkins-sa
  containers:
    - name: kaniko
      image: gcr.io/kaniko-project/executor:v1.16.0-debug
      imagePullPolicy: Always
      command:
        - sleep
      args:
        - 99d
"""
    }
  }

  environment {
    ECR_REGISTRY = "307987835663.dkr.ecr.eu-north-1.amazonaws.com"
    IMAGE_NAME   = "django-app"
    IMAGE_TAG    = "0.0.1"
  }

  stages {
    stage('Build & Push Docker Image') {
      steps {
        container('kaniko') {
          sh '''
            REPO_DIR="$(pwd)"
            /kaniko/executor \\
              --context "${REPO_DIR}" \\
              --dockerfile "${REPO_DIR}/django/Dockerfile" \\
              --destination="$ECR_REGISTRY/$IMAGE_NAME:$IMAGE_TAG" \\
              --cache=true \\
              --insecure \\
              --skip-tls-verify
          '''
        }
      }
    }
  }
}
