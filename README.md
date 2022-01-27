# jenkins-custom

[![Jenkins](https://img.shields.io/badge/jenkins_custom-latest-red?logo=jenkins)](https://hub.docker.com/r/aramirol/jenkins-custom)

Custom Jenkins image that is a customization of the official image by adding the necessary packages to deploy with Ansible and Terraform. In addition, packages have been added to perform testing tasks with Pytest and InSpec. It also includes packages like Kubectl and Helm for deployments on top of K8s.

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
```sh
$ git clone https://github.com/aramirol/casare-homelab.git
```
```sh
$ cd casare-homelab/jenkins/jenkins-custom
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
$ docker push aramirol/jenkins-custom:1.0
```
```sh
$ docker push aramirol/jenkins-custom:latest
```

## License

MIT License

See [LICENSE](https://github.com/aramirol/jenkins-custom/blob/main/LICENSE.md) to see the full text.
