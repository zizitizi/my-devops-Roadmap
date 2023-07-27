

# Run Haproxy With Docker

We’ll create three instances of a web application, one instance of HAProxy, and a bridge network to join them together. So, once you’ve installed Docker, use the following command to create a new bridge network in Docker:

      $ sudo docker network create --driver=bridge mynetwork


Then use the docker run command to create and run three instances of the web application. In this example, I use the Docker image jmalloc/echo-server. It’s a simple web app that returns back the details of the HTTP requests that you send to it.

      $ sudo docker run -d \
         --name web1 --net mynetwork jmalloc/echo-server:latest
         
      $ sudo docker run -d \
         --name web2 --net mynetwork jmalloc/echo-server:latest
         
      $ sudo docker run -d \
         --name web3 --net mynetwork jmalloc/echo-server:latest


Notice that we assign each one a unique name and attach it to the bridge network we created. You should now have three web applications running, which you can verify by calling the docker ps command:

$ sudo docker ps


      
      CONTAINER ID   IMAGE                        COMMAND              CREATED              STATUS              PORTS      NAMES
      98216bb8c5ff   jmalloc/echo-server:latest   "/bin/echo-server"   About a minute ago   Up About a minute   8080/tcp   web3
      ae6accc111d9   jmalloc/echo-server:latest   "/bin/echo-server"   About a minute ago   Up About a minute   8080/tcp   web2
      554fafbc2b3b   jmalloc/echo-server:latest   "/bin/echo-server"   About a minute ago   Up About a minute   8080/tcp   web1


These containers listen on their own port 8080, but we did not map those ports to the host, so they are not routable. We’ll relay traffic to these containers via the HAProxy load balancer. Next, let’s add HAProxy in front of them. Create a file named haproxy.cfg in the current directory and add the following to it:

      global
        stats socket /var/run/api.sock user haproxy group haproxy mode 660 level admin expose-fd listeners
        log stdout format raw local0 info
      
      defaults
        mode http
        timeout client 10s
        timeout connect 5s
        timeout server 10s
        timeout http-request 10s
        log global
      
      frontend stats
        bind *:8404
        stats enable
        stats uri /
        stats refresh 10s
      
      frontend myfrontend
        bind :80
        default_backend webservers
      
      backend webservers
        server s1 web1:8080 check
        server s2 web2:8080 check
        server s3 web3:8080 check


A few things to note:

In the global section, the stats socket line enables the HAProxy Runtime API and also enables seamless reloads of HAProxy.

The first frontend listens on port 8404 and enables the HAProxy Stats dashboard, which displays live statistics about your load balancer.

The other frontend listens on port 80 and dispatches requests to one of the three web applications listed in the webservers backend.

Instead of using the IP address of each web app, we’re using their hostnames web1, web2, and web3. You can use this type of DNS-based routing when you create a Docker bridge network as we’ve done.

Next, create and run an HAProxy container and map its port 80 to the same port on the host by including the -p argument. Also, map port 8404 for the HAProxy Stats page:

      $ sudo docker run -d \
         --name haproxy \
         --net mynetwork \
         -v $(pwd):/usr/local/etc/haproxy:ro \
         -p 80:80 \
         -p 8404:8404 \
         haproxytech/haproxy-alpine:2.4


Calling docker ps afterwards shows that HAProxy is running:

      $ sudo docker ps
      
      CONTAINER ID   IMAGE                            COMMAND                  CREATED          STATUS          PORTS                                        NAMES
      d734d0ef2635   haproxytech/haproxy-alpine:2.4   "/docker-entrypoint.â¦"   3 seconds ago    Up 2 seconds    0.0.0.0:80->80/tcp, 0.0.0.0:8404->8404/tcp   haproxy


You can access the echo-server web application at http://localhost. Each request to it will be load balanced by HAProxy. Also, you can see the HAProxy Stats page at http://localhost:8404.

If you make a change to your haproxy.cfg file, you can reload the load balancer—without disrupting traffic—by calling the docker kill command:

      $ sudo docker kill -s HUP haproxy


To delete the containers and network, run the docker stop, docker rm, and docker network rm commands:

      $ sudo docker stop web1 && sudo docker rm web1
      $ sudo docker stop web2 && sudo docker rm web2
      $ sudo docker stop web3 && sudo docker rm web3
      $ sudo docker stop haproxy && sudo docker rm haproxy
      $ sudo docker network rm mynetwork




# sample 2 nginx

first you should define appriciate network. for swarm choose --driver=overlay and for docker network type bridge.

            docker network create --driver=bridge mynet

then make your proper nginx docker with specifeid network and other desired options.

            docker run --name nginx136 -dit --network mynet nginx:latest

make config file for haproxy container to mount it in container:

            vi haproxy.cfg

copy below configuration file with Pay attention to the nginx service name, other server name is optional:            


            global
              stats socket /var/run/api.sock user haproxy group haproxy mode 660 level admin expose-fd listeners
              log stdout format raw local0 info
            
            defaults
              mode http
              timeout client 10s
              timeout connect 5s
              timeout server 10s
              timeout http-request 10s
              log global
            
            frontend stats
              bind *:8404
              stats enable
              stats uri /
              stats refresh 10s
            
            frontend myfrontend
              bind :80
              default_backend webservers
            
            backend webservers
              server zizi-pc nginx136:80 check


now run haproxy container with specified configuration:

            docker run -d    --name haproxy    --net mynet    -v $(pwd):/usr/local/etc/haproxy:ro    -p 80:80    -p 8404:8404    haproxytech/haproxy-alpine:2.4


now check the URLs:

curl localhost

curl localhost:8404

http://192.168.44.136/    ---->haproxy server ip 

http://192.168.44.136:8404/

​
# Conclusion

In this toturial , you learned how running HAProxy inside of a Docker container can simplify its deployment and lifecycle management. Docker provides a standardized way for deploying applications, making the process repeatable and testable. While the CPU overhead of running Docker is negligible, it can incur extra network latency, but the impact of that depends on your use case and throughput needs.

To run HAProxy, simply create an HAProxy configuration file and then call the docker run the command with the name of the HAProxy Docker image. HAProxy Technologies supplies up-to-date Docker images on Docker Hub.



### also read :


https://www.haproxy.com/blog/how-to-run-haproxy-with-docker


https://docs.docker.com/engine/swarm/ingress/



