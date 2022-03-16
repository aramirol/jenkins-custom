# jenkins-custom

[![Docker Image CI](https://github.com/aramirol/jenkins-custom/actions/workflows/docker-image.yml/badge.svg)](https://github.com/aramirol/jenkins-custom/actions/workflows/docker-image.yml)
[![Docker Image Version (latest by date)](https://img.shields.io/docker/v/aramirol/jenkins-custom?logo=docker&logoColor=lightgrey)](https://hub.docker.com/r/aramirol/jenkins-custom)
[![GitHub](https://img.shields.io/github/license/aramirol/jenkins-custom?logo=github&logoColor=lightgrey)](https://github.com/aramirol/jenkins-custom/blob/main/LICENSE)

![GitHub commit activity](https://img.shields.io/github/commit-activity/m/aramirol/jenkins-custom)
![GitHub last commit](https://img.shields.io/github/last-commit/aramirol/jenkins-custom)


Custom Jenkins image that is a customization of the official image by adding the necessary packages to deploy with Ansible and Terraform. In addition, packages have been added to perform testing tasks with Pytest and InSpec. It also includes packages like Kubectl and Helm for deployments on top of K8s.

The docker image will be pushed in [https://hub.docker.com/r/aramirol/jenkins-custom](https://hub.docker.com/r/aramirol/jenkins-custom).

## Requirements

To use `docker` command you must change `docker.sock` permissions on the docker service where jenkins is running. To do this, just type the following command as root:

```sh
chmod 666 /var/run/docker.sock
```

## Build image

If you want to build a new image, you must download the Dockerfile from [GitHub](https://github.com/aramirol/jenkins-custom). Then, type the following command changing the version.

```sh
docker build aramirol/jenkins-custom:x.x.x
```

## Tag image
If you want to modify the tag of the new image, you can use the following command changing soruce and target tags:

```sh
docker tag source:tag target:tag
```

## Example
### Manual use
```sh
$ git clone https://github.com/aramirol/jenkins-custom.git
```
```sh
$ cd jenkins-custom/
```
```sh
$ docker build --tag aramirol/jenkins-custom:x.x.x .
```
```sh
$ docker tag aramirol/jenkins-custom:x.x.x aramirol/jenkins-custom:x.x.y
```
```sh
$ docker login
Authenticating with existing credentials...
WARNING! Your password will be stored unencrypted in /home/<<username>>/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```
```sh
$ docker push aramirol/jenkins-custom:1.0.0
```
```sh
$ docker push aramirol/jenkins-custom:latest
```

### Automated use
If you prefer, you can use the automated build & push image with *Jenkins*. Before begin, you need a *Docker* environment **(K8s recomended)**.

Then, create a new Pipeline en Jenkins and use the `Jenkinsfile` file. Look out that you meybe need to do few changes as the credentials.

Once a pipeline is created, use the `.imagetag.cfg` file to set the new version/tag of the new image. This file will be read during the stages to set the tag version when image is bulding.

## License

MIT License

See [LICENSE](https://github.com/aramirol/jenkins-custom/blob/main/LICENSE) to see the full text.
