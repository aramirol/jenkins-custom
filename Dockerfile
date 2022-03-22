# Base image 
FROM jenkins/jenkins:jdk11

# User I will use 
USER root

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

##################################################################################################
# Install OS Packages using Package Management 
##################################################################################################

# Install packages 
RUN apt install --no-install-recommends -y \
    apt-utils \
    bash-completion \
    build-essential \
    vim \
    apt-transport-https \
    ca-certificates \
    curl \
    debconf-utils \
    file \
    git \
    gnupg \
    apache2-utils \
    libffi-dev \
    libxslt1-dev \ 
    libssl-dev \
    libxml2-dev \
    libkrb5-dev \
    openssl \
    python3 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-venv \
    sudo \ 
    uuid-dev \
    unzip \
    wget

RUN sudo apt-get clean

# Update all packages
RUN sudo apt upgrade -y

##################################################################################################
# Install aditional needed repos using Package Management
##################################################################################################

# Install Ansible repo 
RUN sudo apt install software-properties-common && \
    sudo add-apt-repository --yes --update ppa:ansible/ansible

# Install Terraform repo 
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - && \
    sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main"

# Install Helm repo 
RUN curl https://baltocdn.com/helm/signing.asc | sudo apt-key add - && \
    sudo apt-get install apt-transport-https --yes && \
    echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

# Install Kubectl repo
RUN sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Update Aditional repos
RUN apt update -y

# Install Aditional Packages 
RUN apt install -y \
    ansible \
    terraform \
    helm \
    kubectl

##################################################################################################
# Install OS Packages using binary files 
##################################################################################################

# Install and Upgrade pip 
RUN pip3 install --upgrade pip setuptools wheel

# Install OpenShift cli 
RUN wget https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz && \
    tar -xzf oc.tar.gz && \
    mv oc /usr/bin/
RUN rm -rf oc.tar.gz

# Install InSpec by Chef 
RUN curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P inspec

##################################################################################################
# Post-Configuration 
##################################################################################################

# Set Timezone as Europe/Madrid 
RUN echo "Europe/Madrid" > /etc/timezone

# Add groups to sudoers 
RUN groupadd -g ${ansible_gid} ${ansible_group} \
    && useradd -d "$ANSIBLE_HOME" -u ${ansible_uid} -g ${ansible_gid} -m -s /bin/bash ${ansible_user} \
    && echo "jenkins        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/jenkins \
    && echo "ansible        ALL=(ALL)       NOPASSWD: ALL" > /etc/sudoers.d/ansible

# Copy Ansible config file 
COPY ansible.cfg /etc/ansible/.

# Jenkins home volume 
VOLUME $JENKINS_HOME

# For main web interface 
EXPOSE ${http_port}

# Will be used by attached slave agents 
EXPOSE ${agent_port}

# User I will run 
USER ${user}
