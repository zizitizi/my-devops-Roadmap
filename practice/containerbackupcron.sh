#!/bin/bash

#*********please give this file +x permission to execute backup********************

#*********please copy this file in /etc/cron.hourly/ to perform auotomated action backup********************

# get all running docker container names

containers=$(sudo docker ps | awk '{if(NR>1) print $NF}')

#get host names

host=$(hostname)

#repousername="zeintiz"

#reponame="container-backup"

tagname=`date +%Y%m%d-%H%M%S`

#OUTPUT=/home/zizi/

for container in $containers
do
        echo $container
        CONNAME=${container}:${tagname}
        echo $CONNAME
        docker commit ${container} backup-${CONNAME}
        docker save backup-${CONNAME} > ~/backup-${CONNAME}.tar
        if [ $? -eq 0 ]
        then
                 find ~ -name "backup-${container}*.tar" -type f -mmin +60 -exec rm -rf {} \;
        fi
done


