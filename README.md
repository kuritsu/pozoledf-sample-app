# pozoledf-sample-app

[PozoleDF](https://github.com/kuritsu/pozoledf) Sample NodeJS Application prepared for K8S and Jenkins pipeline.

## Requirements

- Docker
- NodeJS 12 or superior

## Running and testing

Use the following command to run the app:

```bash
$ npm start
```

Use the following command to check the published endpoint (once the app is running):

```bash
$ curl http://localhost:3000/health
OK!
```

## Building

Add the project to the Jenkins server installed following the instructions at
https://github.com/kuritsu/pozoledf-chef-repo.

Notice that the following Jenkins credentials are required to get a successful build:

- `docker-registry-fqdn`: Text with the host name of your Docker Registry. Ex. `myregistry.docker.com`.
- `docker-login-cmd`: The Docker login command in case you use a private registry, for example:
  `docker login myregistry.private.com -u admin -p 'MyPassw0rd'`.
- `jenkins-github-creds`: User and password from GitHub. Instead of using a personal password, you should use a PAT (Personal Access Token), check [here](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) for more details. It requires only the `repo` and `user` scopes.

The docker image we use in Jenkins with all the tools required can be found in the
`Dockerfile-pipeline` file. It is hosted already in Docker Hub with the name `kuritsu/pozoledf-jenkins-util:latest` as can be noted in the Jenkinsfile.

The pipeline builds a Docker image configured in the `Dockerfile` with the very simple nodejs API app, it is tagged and pushed to a Docker registry.

Also note that when the build triggers for the `main` branch, the https://github.com/kuritsu/pozoledf-sample-app-deployment repo is cloned, a branch with the release info is created, and the image:tag information is updated with [kustomize](https://kustomize.io). The branch is then pushed to GitHub. This will trigger another Jenkins pipeline contained in the mentioned repo. Read the [README](https://github.com/kuritsu/pozoledf-sample-app-deployment) there to get more details on the flow.
