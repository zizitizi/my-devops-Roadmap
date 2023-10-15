
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



Node environment monitoring:
Recommended: https://grafana.com/grafana/dashboards/159 
https://grafana.com/dashboards/1860 
https://grafana.com/dashboards/3662 
https://grafana.com/dashboards/8919 
https://github.com/arashforoughi/grafana-dashboards



Docker and System Monitoring:
Recommended: https://grafana.com/grafana/dashboards/14282 
https://grafana.com/grafana/dashboards/179 
https://grafana.com/grafana/dashboards/11600 
https://grafana.com/grafana/dashboards/193 




Kubernetes Cluster Monitoring:
Recommended: https://grafana.com/grafana/dashboards/315 
https://grafana.com/grafana/dashboards/6336 
https://grafana.com/grafana/dashboards/395 
https://grafana.com/grafana/dashboards/7249 








# helm

is package manager for k8s

helm.sh

https://artifacthub.io/

  
helm list

helm uninstall packagename


helm repo list

you can install kube-prometheus-stack from helm repo


Add repository

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

Install chart

helm install my-kube-prometheus-stack prometheus-community/kube-prometheus-stack --version 51.7.0


to monitor pods

goto exportersite

https://prometheus.io/docs/instrumenting/exporters/

https://github.com/kubernetes/kube-state-metrics


one installation is enough for all your cluster becouse it run as daemon set



                  apiVersion: apps/v1
                  kind: DaemonSet
                  spec:
                    template:
                      spec:
                        containers:
                        - image: registry.k8s.io/kube-state-metrics/kube-state-metrics:IMAGE_TAG
                          name: kube-state-metrics
                          args:
                          - --resource=pods
                          - --node=$(NODE_NAME)
                          env:
                          - name: NODE_NAME
                            valueFrom:
                              fieldRef:
                                apiVersion: v1
                                fieldPath: spec.nodeName



then run  


add its scrape config
              









  












