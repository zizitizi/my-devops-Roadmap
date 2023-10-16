

# run mongodb in docker


    sudo docker run --name mongo -dit -p 27017:27017 mongodb/mongodb-community-server:lates

    docker ps

 
docker container ls

   docker exec -it mongo mongosh



test with command


   db.runCommand(
      {
         hello: 1
      }
   )


http://192.168.44.151:27017/



# install monodb exporter on that node

https://prometheus.io/docs/instrumenting/exporters/

https://github.com/percona/mongodb_exporter



    docker run -d -p 9216:9216 -p 17001:17001 --name monex percona/mongodb_exporter:0.20 --mongodb.uri=mongodb://192.168.44.151:27017


 test it :

 
http://192.168.44.151:9216/metrics



# add scrape config to prometheus server yml


     - job_name: "mongodocker monitor"
       static_configs:
         - targets: ["192.168.44.151:9216"]



check it up:

http://192.168.44.136:9090/targets?search=


# add grafana dashboard

import mangodb dashboard id and save it. 7353



