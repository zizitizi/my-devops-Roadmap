#!/bin/bash

# get all running docker container names

containers=$(sudo docker ps | awk '{if(NR>1) print $NF}')

#get host names

host=$(hostname)

#repousername="zeintiz"

reponame="container-backup"

tagname=`date +%Y/%m/%d-%H:%M:%S`

OUTPUT=/home/zizi/

for container in $containers
do
        docker commit container backup-${container}:${tagname}
        docker save backup-${container}:${tagname} > ${OUTPUT}backup-${container}:${tagname}.tar
        if [ $? -eq 0 ]
        then
                 find /home/zizi/ -name "backup-${container}*.tar" -type f -mmin +60 -exec rm -rf {} \;
        fi
done







