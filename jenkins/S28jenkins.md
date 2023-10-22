
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

prom pull all exporter like: push gateway. but we push desired app in push gateway. you can write bash script to give backup daily and send 1 in infinite reapetable while to pushgatway if down send 0. and monitor youe bakcups.

      
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


curl --data-binary @-     - we send data in pushgateway in this format save this      

http://172.31.3.30:9091/metrics   - push gateway address

job/Websocket-connection/instance/172.31.3.30:9100  - and other filter is query tha push to push gateway

websocket_current_tcp_connections   - is the name of metrics

$WEBSOCKET_CONNECTIONS   - value of the metrics


      
      
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
      
      



hint: in bash script while command sleep is same as cpu speed and its very high then it sends too many data to push gateway then use sleep 5 or sleep 1 to delay it.



# service - systemctl 

in all linux system services is in : /lib/systemd/system

third parties service commonly is in : /etc/systemd/system

but no difference in which directory in systemctl daemon reload its reload all those ffolder and files.

3 type of file in system:

- .wants: servive wants to run but if not. no matterthe service will be run.
- .requires: service needs to boot if not load then service not boot.
- .service: to wrie service in /etc/systemd/system/ make file that begin with specail name to specify your custom files from other one. fir ex.: mysrcrit_number_of_socket.service  - that service in systemctl will show be with this name.

in service file we have descriptions that appear in systemctl status .... . we can write the name of auther here.

in after we say to system to run our script after that service its wanted. its cooman to use network.target. because network ls latest service that in run in system boot then we can run our service after it conveniently. best practice***

type is type of that app that may be simple or not. user and grou is that user that have access to that script or app. execstart is path to our script.

wantedby is which run level will be accessible.
      
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



#### runlevel

A runlevel is an operating state on a Unix and Unix-based operating system that is preset on the Linux-based system. Runlevels are numbered from zero to six. Runlevels determine which programs can execute after the OS boots up. when we power on pc then it load bois - health check - boot order ---> boot loader - if have linux boot loader that called grub (here we can change between linux and windows )  -----> kernel - loads in ram to perform with high speed - then run first procces that called init (to run configurations , apps ,..) - then OS is up and if ok then go to states that called run level 

we have 7 type of run level:

0- shutdown -halt
1- maintenance mode (safe mode in windows) - single user mode - with out any deriver or network or .... with just one user
2- multi user mode - same as mode 1 wnd without network but its multi user
3- multi user same as 2 but with network - complete mode with CLI . 
4- reserve and custom mode to use sysadmins
5- complete gui or graphical mode in linux - graphical.target  
6- reboot  - for ex.: when bios or mem is low - go to this run level to maintance server.

with runlevel command we can see : N 5  - from nothing to runlevel 5 

with init you can go to wny run level. init 0  - halt system

systemctl enable --now mysrcrit_number_of_socket.service  - enabled and start that service. 

if we have script and want to use in service then use complete path directory to file. not use dot .  - after every change do systemctl daemon reload and systemctl restart myservice
      
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
      


***practice:*** add zabix agent to your grafana and its exporter to prom.


# JENKINS

but commonly we use   CI/CD in gitlab and github. but procedure is same. 

plan - code - build - test  - integrate (release) - deploy - opretate - monitor

CI (continiuse integration) = plan - code - build - test  

CD ( continiues commonly called deployment or Delivery) = integrate (release) - deploy - opretate - monitor


difference between deploy and delivery??

continiuse delivery ---> continiuse deployment. delivery is before deployment

CI -> CD (DELIVERY) -> CD (DEPLOYMENT)

CI IS BUILD PROCESS - docker file ,.....

CD in delivery  - just app install in test environment - in testbed or staging server

after final test confirmation (ATP=acceptance test procedure from customer or developer manager) when it approved then go to deployment step and implement in production server.

in enterprise company:

devops engineer = integrate (release) - deploy

SRE = opretate (ansible - IAC ,...) - monitor (zabix - prom. - grafana , datadog (reat it important)..)


CI/CD tools:

jenkins - citlab ci - git hub actions - travis ci ( not free) - circle ci (not free)


jenkins needs java 8 or 11 but those deprecated then you should use openjdk-17-jdk - linux and web ui base.


install on docker or helm or linux from jenkins.io

jenkins is heavy by default its not run pipline in master - in 4 slave it run 4 pipline per slave  2 in master ( exec process) then totaly 16+2 pipline - all server master or slave should installed java before hand then use ansible to install it on all server

best practice make user and group jenkins sudoer 


jenkins use port 8080 thne open it in server



























      
      











