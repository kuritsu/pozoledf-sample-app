pipeline {
  agent {
    docker {
      image "kuritsu/pozoledf-jenkins-util:latest"
      args "--entrypoint='' --network host -u root --privileged -v /var/run/docker.sock:/var/run/docker.sock"
    }
  }

  environment {
    VERSION = "1.0.${BUILD_NUMBER}"
    DOCKER_REGISTRY = credentials("docker-registry-fqdn")
    JENKINS_GITHUB_CREDS = credentials("jenkins-github-creds")
  }

  stages{
    stage("build"){
      steps {
        sh '''
          docker build -t $DOCKER_REGISTRY/pozoledf-sample-app:$VERSION .
        '''
      }
    }
    stage("publish image"){
      agent any
      steps {
        sh '''
          set +x
          # This is using an Amazon ECR, change this to your use case
          pass=`aws ecr get-login-password --region us-west-2`
          docker login --username AWS -p $pass $DOCKER_REGISTRY
          set -x
          docker push $DOCKER_REGISTRY/pozoledf-sample-app:$VERSION
        '''
      }
    }

    stage("prepare release"){
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