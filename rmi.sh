#!/bin/bash
for image in $(docker images aramirol/jenkins-custom | grep -v IMAGE | awk '{print $3}')
do
        docker rmi $image -f
done
