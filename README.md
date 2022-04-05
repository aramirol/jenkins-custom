# Jenkins Custom

![](images/jenkins-custom.png)

[![Docker Image CI](https://github.com/aramirol/jenkins-custom/actions/workflows/docker-image.yml/badge.svg)](https://github.com/aramirol/jenkins-custom/actions/workflows/docker-image.yml)

[![GitHub](https://img.shields.io/github/license/aramirol/jenkins-custom?logo=github&logoColor=lightgrey)](https://github.com/aramirol/jenkins-custom/blob/main/LICENSE)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/aramirol/jenkins-custom?logo=github&logoColor=lightgrey)](https://github.com/aramirol/jenkins-custom)
[![GitHub last commit](https://img.shields.io/github/last-commit/aramirol/jenkins-custom?logo=github&logoColor=lightgrey)](https://github.com/aramirol/jenkins-custom)

[![Docker Image Version (latest by date)](https://img.shields.io/docker/v/aramirol/jenkins-custom?logo=docker&logoColor=lightgrey)](https://hub.docker.com/r/aramirol/jenkins-custom)
[![Docker Pulls](https://img.shields.io/docker/pulls/aramirol/jenkins-custom?color=success&logo=docker&logoColor=lightgrey)](https://hub.docker.com/r/aramirol/jenkins-custom)
[![Docker Image Size](https://img.shields.io/docker/image-size/aramirol/jenkins-custom/latest?logo=jenkins&logoColor=lightgrey)](https://hub.docker.com/r/aramirol/jenkins-custom)


Custom Jenkins image that is a customization of the **[official image](https://hub.docker.com/r/jenkins/jenkins)** by adding the necessary packages to deploy with Ansible and Terraform. In addition, packages have been added to perform testing tasks with Pytest and InSpec. It also includes packages like Kubectl and Helm for deployments on top of K8s.

The docker image is pushed to [https://hub.docker.com/r/aramirol/jenkins-custom](https://hub.docker.com/r/aramirol/jenkins-custom).

## How to build
### Requirements

To use `docker` command you must change `docker.sock` permissions on the docker service where jenkins is running. To do this, just type the following command as root:

```sh
chmod 666 /var/run/docker.sock
```

### Example
#### Manual build and push
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

#### Automated build and push
If you prefer, you can use the automated build & push image with *Jenkins*. Before begin, you need a *Docker* environment **(K8s recomended)**.

Then, create a new Pipeline en Jenkins and use the `Jenkinsfile` file. Look out that you meybe need to do few changes as the credentials.

Once a pipeline is created, use the `.imagetag.cfg` file to set the new version/tag of the new image. This file will be read during the stages to set the tag version when image is bulding.

## How to deploy
### Requirements

This app use remote volumes to save its data and configurations. In the files ***docker-compose.yml*** and ***deploy_jenkins_custom_k8s.yml*** are defined these volumes. Volumes create the path automatically, however, in case of Jenkins it is necesary to create this path before and add custom privileges like assign the owner to user *"1000"*. This is becasuse Jenkins uses this user to write in these files. 

```sh
$ sudo mkdir /data/jenkins-<<env>>
$ sudo mkdir /data/jenkins-<<env>>/jenkins_home
$ sudo chown 1000 /data/jenkins-<<env>>
$ sudo chown 1000 /data/jenkins-<<env>>/jenkins_home
```

**Note** that the path I have used locally as remote volume is `/data/` and remember to rename `<<env>>` for *k8s* or *docker*.

To use `docker` command you must change `docker.sock` permissions on the docker service where jenkins is running. To do this, just type the following command as root:

```sh
$ chmod 666 /var/run/docker.sock
```

This configuration come to default after reboot server so you need to change it again every time you power on the system. To automate this action you can use the following link [https://github.com/aramirol/custom-resources/tree/main/kubernetes/docker.sock](https://github.com/aramirol/custom-resources/tree/main/kubernetes/docker.sock).

To use kubectl command you must need to create a configmap with the correct credentials. For example:

```sh
$ kubectl create configmap config -n jenkins --from-file=$HOME/.kube/config
```

### Deploy to Docker environment

Once the project is downloaded, go to the path where is the file ***docker-compose.yml*** and execute the following command: 

```sh
$ cd Docker
$ docker-compose up -d
```

To stop and delete all created containers, just execute the following command:

```sh
$ cd Docker
$ docker-compose down --rmi=all
```

**NOTE:** *Review the configuration to be sure that all values are what you want.*

### Deploy to Kubernetes environment

Once the project is downloaded, go to the path where is the file ***deploy_jenkins_custom_k8s.yml*** and execute the following command: 

```sh
$ kubectl apply -f kubernetes/deploy_jenkins_custom_k8s.yml
```

This yaml file contains the creation of namespace, pvc, pv, service and deployment using a [custom jenkins image](https://hub.docker.com/r/aramirol/jenkins-custom).

**NOTE:** *Review the configuration to be sure that all values are what you want.*

## Customize Jenkins

Go to [https://github.com/aramirol/custom-resources/tree/master/jenkins-custom-theme](https://github.com/aramirol/custom-resources/tree/master/jenkins-custom-theme). On this site you will find a number of ready-to-use themes.

## License

MIT License

See [LICENSE](https://github.com/aramirol/jenkins-custom/blob/main/LICENSE) to see the full text.
