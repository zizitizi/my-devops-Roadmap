
# prometheus & grafana


too run with docker compose run prom. with push gateway(port 9091). 

first run prom. and graana just for copy prometheus.yaml ang garafana.ini in docker volume folder too  mount it then run docker compose


docker logs -f prometheus  - to see logs




go to grafana node exporter dashboard. to build cpu usage do edit for a dashboard you can edit with code ( pmql language) or make it with builder. for cpu usage do 1-idle

100-((avg(irate(node-cpu-secpnd_total{instance=~"127.0.0.1:9100",mode="idle"}[1ms])))*100)

=~ means == but theres is string in it

in mem usage : 1- availabe/total

net send , recive unit si






# CAdvisor

cAdvisor is a daemon that runs into a container that exports statistics regarding containers resource usage from the host machine.We can use it as stand-alone or export its statistics to Prometheus.cAdvisor can be run on two way:
1- Docker
2- Docker-Compose (optional)


      - job_name: 'cadvisor'
          static_configs:
          - targets: ['cadvisor:8080']
            labels:
              alias: 'cadvisor'
      

to run it in docker:


https://prometheus.io/docs/instrumenting/exporters/


https://github.com/google/cadvisor


VERSION=v0.36.0 # use the latest release version from https://github.com/google/cadvisor/releases
sudo docker run \
  --volume=/:/rootfs:ro \
  --volume=/var/run:/var/run:ro \
  --volume=/sys:/sys:ro \
  --volume=/var/lib/docker/:/var/lib/docker:ro \
  --volume=/dev/disk/:/dev/disk:ro \
  --publish=8080:8080 \
  --detach=true \
  --name=cadvisor \
  --privileged \
  --device=/dev/kmsg \
  gcr.io/cadvisor/cadvisor


cadvisor per each server install and add its scrape config to prometheus.yml in docker swarm


http://192.168.44.136:8080/containers/

then add its scrape config to promethus.yml

  - job_name: "containerszizi"
    static_configs:
      - targets: ["172.18.0.1:8080"]



save and reset container . check it up:

http://192.168.44.136:9090/targets?search=


then go to grafana dashboard and import it. then go to grafana dashboard site:

https://grafana.com/grafana/dashboards


add id to your dashboard


to filter result in edit dashboard go to code write down:

{name!="containernotwanttoseeit" , name}



# helm

is package manager for k8s
  


  












