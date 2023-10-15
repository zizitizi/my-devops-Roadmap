
# prometheus & grafana


too run with docker compose run prom. with push gateway(port 9091). 

first run prom. and graana just for copy prometheus.yaml ang garafana.ini in docker volume folder too  mount it then run docker compose


docker logs -f prometheus  - to see logs




go to grafana node exporter dashboard. to build cpu usage do edit for a dashboard you can edit with code ( pmql language) or make it with builder. for cpu usage do 1-idle

100-((avg(irate(node-cpu-secpnd_total{instance=~"127.0.0.1:9100",mode="idle"}[1ms])))*100)

=~ means == but theres is string in it

in mem usage : 1- availabe/total

net send , recive unit si






# 



