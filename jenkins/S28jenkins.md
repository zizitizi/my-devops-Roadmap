
#### dashbiard in grafana

may be some dashboard did not work im our grafana then we must make our dashboard manually

free space formula in dashboard:


100 - ((node_filesystem_avail_bytes{instance=~"172.31.10.118:9100",mountpoint="/",fstype=~"ext4|xfs"} * 100) / node_filesystem_size_bytes {instance=~"172.31.10.118:9100",mountpoint="/",fstype=~"ext4|xfs"})


#### alert rules in grafana



write rule in added dashboard tab.  im experssion section choose spacified graph section in reduce B chhose A. choose function: commonly last then choose mode for ex.: strict. choose treshold for ex.: imput : B and is above 75 . use prewiew to test it. be careful in graph section define wich instace.  foe example in metric browser:

100-((avg(irate(node_cpu_second_total{instance="192.168.44.136:9100", mode="idle"} [1m])))*100)





