pipeline {
  agent {
    docker {
      image "kuritsu/pozoledf-jenkins-util:latest"
      args "--entrypoint='' --network host -u root --privileged -v /var/run/docker.sock:/var/run/docker.sock"
    }
  }

  environment {
    VERSION = "1.0.${BUILD_NUMBER}"
  }

  stages{
    stage("get creds for docker registry") {
      steps{
          sh """
          # This is using an Amazon ECR docker registry, change this to your use case
          aws ecr get-login-password --region us-west-2 >ecr-pass
          """
      }
    }
    stage("build"){
      environment {
        DOCKER_REGISTRY = credentials("docker-registry-fqdn")
      }
      steps {
          sh '''
          docker_password=`cat ecr-pass`
          docker login --username AWS -p $docker_password $DOCKER_REGISTRY
          docker build -t $DOCKER_REGISTRY/pozoledf-sample-app:$VERSION .
          docker push $DOCKER_REGISTRY/pozoledf-sample-app:$VERSION
          '''
      }
    }
    stage("prepare release"){
      environment {
        JENKINS_GITHUB_CREDS = credentials("jenkins-github-creds")
      }
      steps {
          sh '''
          git clone https://github.com/kuritsu/pozoledf-sample-app-deployment.git
          cd pozoledf-sample-app-deployment
          git checkout v$VERSION
          kustomize edit set image registry.mycompany.com/pozoledf-sample-app=$DOCKER_REGISTRY/pozoledf-sample-app:$VERSION
          git config user.name "jenkins"
          git config user.email "jenkins@pozoledf.com"
          git add .
          git commit -m "Create release $VERSION"
          git remote set-url origin https://$JENKINS_GITHUB_CREDS@github.com/kuritsu/pozoledf-sample-app-deployment.git
          git push origin
          '''
      }
    }
  }
}