
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
  gcr.io/cadvisor/cadvisor:$VERSION



  



![image](https://github.com/zizitizi/my-devops-Roadmap/assets/123273835/6c761f0b-b31a-4cc7-a945-ae406f5eedfd)



![image](https://github.com/zizitizi/my-devops-Roadmap/assets/123273835/e331ef60-3168-44b5-8d8c-fc8d15553f33)





![image](https://github.com/zizitizi/my-devops-Roadmap/assets/123273835/5f53be14-fa1e-4ff4-813a-a1457aabd8cf)





![image](https://github.com/zizitizi/my-devops-Roadmap/assets/123273835/f28560fc-ac81-458f-be27-d10ea237e511)




