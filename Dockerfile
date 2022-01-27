FROM jenkins/jenkins:jdk11

USER root

# Update OS & Packages
RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

# Variables definition
ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG http_port=8080
ARG agent_port=50000
ARG JENKINS_HOME=/var/jenkins_home
ARG ansible_user=ansible
ARG ansible_group=ansible
ARG ansible_uid=1001
ARG ansible_gid=1001

ENV JENKINS_HOME $JENKINS_HOME
ENV JENKINS_SLAVE_AGENT_PORT ${agent_port}
ENV ANSIBLE_HOME /home/ansible
ENV TERRAFORM_VERSION=1.0.9

# Install OS packeges
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        apt-utils \
        bash-completion \
        build-essential \
        vim \
        ca-certificates curl \
        debconf-utils \
        file \
        git \
        gnupg \
        apache2-utils \
        libffi-dev libxslt1-dev libssl-dev libxml2-dev libkrb5-dev \
        openssl \
        python3 python3-dev python3-pip python3-setuptools python3-venv \
        sudo uuid-dev unzip wget && \
    apt-get clean

# Set Timezone as Europe/Madrid
RUN echo "Europe/Madrid" > /etc/timezone

# Install and Upgrade pip
RUN pip3 install --upgrade pip setuptools wheel

# Install Ansible
RUN pip3 install 'ansible==2.10.4' passlib jmespath kerberos pywinrm requests_kerberos xmltodict

# Install Terraform
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin

# Install Kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x kubectl && \
    mv kubectl /usr/bin/kubectl

# Install AWS-IAM-Authenticator
RUN curl -o aws-iam-authenticator https://amazon-eks.s3.us-west-2.amazonaws.com/1.18.9/2020-11-02/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x ./aws-iam-authenticator && \
    mv aws-iam-authenticator /usr/bin/aws-iam-authenticator

# Install GCP-sdk
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && apt-get update -y && apt-get install google-cloud-sdk -y

# Install Helm
RUN wget https://get.helm.sh/helm-v3.4.0-linux-amd64.tar.gz && \
    tar -zxvf helm-v3.4.0-linux-amd64.tar.gz && \
    mv linux-amd64/helm /usr/bin/helm

# Install OpenShift cli
RUN wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz && \
    tar -xzf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz && \
    chmod +x openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc && \
    mv openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /usr/bin/

# Add groups to sudoers
RUN groupadd -g ${ansible_gid} ${ansible_group} \
    && useradd -d "$ANSIBLE_HOME" -u ${ansible_uid} -g ${ansible_gid} -m -s /bin/bash ${ansible_user} \
    && echo "jenkins        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/jenkins \
    && echo "ansible        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/ansible

COPY ansible.cfg /etc/ansible/.

# Install InSpec by Chef
RUN curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P inspec

# Install Docker-CE
#RUN apt install -y apt-transport-https ca-certificates curl software-properties-common && \
#   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
#    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" && \
#    sudo apt update && \
#    sudo apt install -y docker-ce

# Jenkins home volume
VOLUME $JENKINS_HOME

# for main web interface:
EXPOSE ${http_port}

# will be used by attached slave agents:
EXPOSE ${agent_port}

USER ${user}
