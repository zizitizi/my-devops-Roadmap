
#### dashbiard in grafana

may be some dashboard did not work im our grafana then we must make our dashboard manually

free space formula in dashboard:

                  
                  100 - ((node_filesystem_avail_bytes{instance=~"172.31.10.118:9100",mountpoint="/",fstype=~"ext4|xfs"} * 100) / node_filesystem_size_bytes {instance=~"172.31.10.118:9100",mountpoint="/",fstype=~"ext4|xfs"})
                  

#### alert rules in grafana



write rule in added dashboard tab.  im experssion section choose spacified graph section in reduce B chhose A. choose function: commonly last then choose mode for ex.: strict. choose treshold for ex.: imput : B and is above 75 . use prewiew to test it. be careful in graph section define wich instace.  foe example in metric browser:

100-((avg(irate(node_cpu_second_total{instance="192.168.44.136:9100", mode="idle"} [1m])))*100)



add experssion as you want. add folder to categorize alerts. for exapmle infra structure alerts. or all infra cpu folder
or all onfra  mem forlder ,....

add evaluation group too evaluate that gruop items in sequnce . fro ex.: cpu usage ,... mem usage,....

in no data section set it to alerting also in erroror timeout  set it to alerting.


set label to severity and major. in cooman way.



sample: if you want number of user in site in nginx access log, then write script use push gateway



## push gateway

run it with specified docker compose. we should add push gate way in prometheus.yml file like others.

prom pull all exporter like: push gateway. but we push desired app in push gateway

      
      - job_name:
        honor_labels: true
        scrape_interval: 5s
        static_configs:
            - targets: ['pushgateway:9091']
        
  

when it run its web gui in 9091 port without anything . if u write job it shows metrics


        
        version: "2"
        
        services:
          prometheus:
            image: prom/prometheus:latest
            container_name: prometheus
            hostname: prometheus
            restart: always
            tty: true
            volumes:
              - /etc/prometheus.yml:/etc/prometheus/prometheus.yml
            ports:
              - '9090:9090'
            networks:
              - prometheus
        
          grafana:
            image: grafana/grafana:latest
            container_name: grafana
            restart: always
            ports:
              - '3000:3000'
            networks:
              - prometheus
            volumes:
              - /etc/grafana.ini:/etc/grafana/grafana.ini
        
          pushgateway:
            image: prom/pushgateway
            container_name: pushgateway
            hostname: pushgateway
            restart: unless-stopped
            expose:
              - 9091
            ports:
              - "9091:9091"
            networks:
              - prometheus
            labels:
              org.label-schema.group: "monitoring"
        
        networks:
          prometheus:
        
        


use save this command to every push gataway:

  cat << EOF | curl --data-binary @- http://172.31.3.30:9091/metrics/job/Websocket-connection/instance/172.31.3.30:9100
      websocket_current_tcp_connections $WEBSOCKET_CONNECTIONS
      EOF
      

http://172.31.3.30:9091/metrics   - push gateway address

job/Websocket-connection/instance/172.31.3.30:9100 websocket_current_tcp_connections    - and other filter is query tha push to push gateway


      
      
      #!/bin/bash
      
      while true
      do
      
      WEBSOCKET_CONNECTIONS=`netstat -pentaul | grep ESTABLISHED | awk '{print $4}' | grep 9001 | grep -v 127.0.0.1 | wc -l`
      
      cat << EOF | curl --data-binary @- http://172.31.3.30:9091/metrics/job/Websocket-connection/instance/172.31.3.30:9100
      websocket_current_tcp_connections $WEBSOCKET_CONNECTIONS
      EOF
      
      echo "`date +%Y/%m/%d-%H:%M:%S`: Number of Websocket Connections = $WEBSOCKET_CONNECTIONS" >> /root/pushgateway/result.log
      
      sleep 5
      
      done
      
      









      
      [Unit]
      Description=Websocket Connection Monitoring
      After=network.target
       
      [Service]
      User=root
      Group=root
      Type=simple
      ExecStart=/root/pushgateway/websocket_connection_script.sh
       
      [Install]
      WantedBy=multi-user.target









      
      # my global config
      global:
        scrape_interval: 15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
        evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
        # scrape_timeout is set to the global default (10s).
      
      # Alertmanager configuration
      alerting:
        alertmanagers:
          - static_configs:
              - targets:
                # - alertmanager:9093
      
      # Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
      rule_files:
        # - "first_rules.yml"
        # - "second_rules.yml"
      
      # A scrape configuration containing exactly one endpoint to scrape:
      # Here it's Prometheus itself.
      scrape_configs:
        # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
        - job_name: "prometheus"
          static_configs:
            - targets: ["localhost:9090"]
      
        - job_name: 'Realtime Websocket Staging'
          static_configs:
          - targets: ['172.31.3.30:9100']
      
        - job_name: 'Realtime Websocket Production'
          static_configs:
          - targets: ['172.31.6.108:9100']
      
        - job_name: 'Pushgateway'
          honor_labels: true
          scrape_interval: 5s
          static_configs:
          - targets: ['172.31.3.30:9091']
      
      
      











