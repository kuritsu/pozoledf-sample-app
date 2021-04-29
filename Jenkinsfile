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
    DOCKER_LOGIN_CMD = credentials("docker-login-cmd")
    JENKINS_GITHUB_CREDS = credentials("jenkins-github-creds")
  }

  stages{
    stage("build"){
      steps {
        sh '''
          docker build --network host -t $DOCKER_REGISTRY/pozoledf-sample-app:$VERSION .
        '''
      }
    }
    stage("publish image"){
      steps {
        sh '''
          set +x
          # This is using an Amazon ECR, change this to your use case
          # eval $(aws ecr get-login --no-include-email --region us-west-2 | sed 's|https://||')
          $DOCKER_LOGIN_CMD
          set -x
          docker push $DOCKER_REGISTRY/pozoledf-sample-app:$VERSION
        '''
      }
    }

    stage("prepare release"){
      steps {
        sh '''
          rm -rf pozoledf-sample-app-deployment
          git clone https://github.com/kuritsu/pozoledf-sample-app-deployment.git
          cd pozoledf-sample-app-deployment
          git checkout -b v$VERSION
          cd habitat/config_install
          kustomize edit set image registry.mycompany.com/pozoledf-sample-app=$DOCKER_REGISTRY/pozoledf-sample-app:$VERSION
          cd ../..
          cat release.json|jq '.dev="'$VERSION'"' >release.copy.json
          cp -u release.copy.json release.json
          rm -rf release.copy.json
          git config user.name "jenkins"
          git config user.email "jenkins@pozoledf.com"
          git add .
          git commit -m "Create release $VERSION"
          git remote set-url origin https://$JENKINS_GITHUB_CREDS@github.com/kuritsu/pozoledf-sample-app-deployment.git
          git push --set-upstream origin v$VERSION
        '''
      }
    }
  }
}