pipeline{
  agent any

  stages{
    stage("get creds for docker registry") {
      agent {
        docker {
          image 'banst/awscli:latest'
          args  '--entrypoint=/bin/sh'
        }
      }
      steps{
          sh """
          # This is using an Amazon ECR docker registry, change this to your use case
          aws ecr get-login-password --region us-west-2 >ecr-pass
          """
      }
    }
    stage("build"){
      agent any
      environment {
        DOCKER_REGISTRY = credentials('docker-registry-fqdn')
        ORG = credentials('org')
      }
      steps{
          sh """
          cat ecr-pass|docker login --username AWS --password-stdin $DOCKER_REGISTRY
          docker build -t $DOCKER_REGISTRY/$ORG/pozoledf-sample-app:1.0.$BUILD_NUMBER .
          docker push $DOCKER_REGISTRY/$ORG/pozoledf-sample-app:1.0.$BUILD_NUMBER
          """
      }
    }
  }
}