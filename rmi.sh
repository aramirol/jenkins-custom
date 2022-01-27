#!/bin/bash
for image in $(docker images | grep -v IMAGE | awk '{print $3}')
do
        docker rmi $image -f
done
